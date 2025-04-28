from flask import Flask, request
from flask_cors import CORS
import threading
import cv2
import numpy as np
import mediapipe as mp
import tensorflow as tf
from PIL import Image, ImageDraw, ImageFont
import arabic_reshaper
from bidi.algorithm import get_display

app = Flask(__name__)
CORS(app)

labels_dict = {
    0: 'مرحبا', 1: 'كيف حالك', 2: 'كم', 3: 'متى', 4: 'مين',
    5: 'ملعب', 6: 'ماذا', 7: 'فين', 8: 'شركة', 9: 'أحبك'
}

interpreter = tf.lite.Interpreter(model_path="sign_model_optimized.tflite")
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False,
                       max_num_hands=1,
                       min_detection_confidence=0.5,
                       min_tracking_confidence=0.5)
mp_draw = mp.solutions.drawing_utils

# Global variables to control the thread
model_thread = None
stop_event = threading.Event()

def run_model_camera():
    cap = cv2.VideoCapture(0)
    while not stop_event.is_set():  # 👈 check if stop is requested
        ret, frame = cap.read()
        if not ret:
            break
        frame = cv2.flip(frame, 1)

        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        result = hands.process(rgb)

        prediction_text = ""

        if result.multi_hand_landmarks:
            for hand_landmarks in result.multi_hand_landmarks:
                mp_draw.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

                landmarks = []
                for lm in hand_landmarks.landmark:
                    landmarks.extend([lm.x, lm.y])

                if len(landmarks) == 42:
                    input_data = np.array([landmarks], dtype=np.float32)

                    interpreter.set_tensor(input_details[0]['index'], input_data)
                    interpreter.invoke()
                    output_data = interpreter.get_tensor(output_details[0]['index'])
                    prediction = np.argmax(output_data)

                    prediction_text = labels_dict.get(prediction, "غير معروف")

        if prediction_text != "":
            reshaped_text = arabic_reshaper.reshape(prediction_text)
            bidi_text = get_display(reshaped_text)

            frame_pil = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            draw = ImageDraw.Draw(frame_pil)
            font = ImageFont.truetype("arial.ttf", 40)
            draw.text((10, 10), bidi_text, font=font, fill=(0, 255, 0))
            frame = cv2.cvtColor(np.array(frame_pil), cv2.COLOR_RGB2BGR)

        cv2.imshow("Arabic Sign Language", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

@app.route('/receive', methods=['POST'])
def receive():
    global model_thread, stop_event
    data = request.get_json()
    print(f"Received data from Flutter: {data}")

    if model_thread is None or not model_thread.is_alive():
        stop_event.clear()  # clear stop flag
        model_thread = threading.Thread(target=run_model_camera)
        model_thread.start()

    return {'message': 'Model started successfully'}, 200

@app.route('/stop', methods=['POST'])
def stop():
    global stop_event
    stop_event.set()  # signal the thread to stop
    return {'message': 'Model stopping...'}, 200

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)

# from flask import Flask, request
# from flask_cors import CORS
# import threading  # 👈 to run model in a separate thread

# # Import your ML and CV stuff
# import cv2
# import numpy as np
# import mediapipe as mp
# import tensorflow as tf
# from PIL import Image, ImageDraw, ImageFont
# import arabic_reshaper
# from bidi.algorithm import get_display

# # Initialize Flask
# app = Flask(__name__)
# CORS(app)

# # Load your model and prepare other stuff once
# labels_dict = {
#     0: 'مرحبا', 1: 'كيف حالك', 2: 'كم', 3: 'متى', 4: 'مين',
#     5: 'ملعب', 6: 'ماذا', 7: 'فين', 8: 'شركة', 9: 'أحبك'
# }

# # Load TFLite model
# interpreter = tf.lite.Interpreter(model_path="sign_model_optimized.tflite")
# interpreter.allocate_tensors()
# input_details = interpreter.get_input_details()
# output_details = interpreter.get_output_details()

# # Prepare MediaPipe
# mp_hands = mp.solutions.hands
# hands = mp_hands.Hands(static_image_mode=False,
#                        max_num_hands=1,
#                        min_detection_confidence=0.5,
#                        min_tracking_confidence=0.5)
# mp_draw = mp.solutions.drawing_utils

# def run_model_camera():
#     cap = cv2.VideoCapture(0)
#     while True:
#         ret, frame = cap.read()
#         if not ret:
#             break
#         frame = cv2.flip(frame, 1)

#         rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
#         result = hands.process(rgb)

#         prediction_text = ""

#         if result.multi_hand_landmarks:
#             for hand_landmarks in result.multi_hand_landmarks:
#                 mp_draw.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

#                 landmarks = []
#                 for lm in hand_landmarks.landmark:
#                     landmarks.extend([lm.x, lm.y])

#                 if len(landmarks) == 42:
#                     input_data = np.array([landmarks], dtype=np.float32)

#                     interpreter.set_tensor(input_details[0]['index'], input_data)
#                     interpreter.invoke()
#                     output_data = interpreter.get_tensor(output_details[0]['index'])
#                     prediction = np.argmax(output_data)

#                     prediction_text = labels_dict.get(prediction, "غير معروف")

#         # Draw Arabic text
#         if prediction_text != "":
#             reshaped_text = arabic_reshaper.reshape(prediction_text)
#             bidi_text = get_display(reshaped_text)

#             frame_pil = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
#             draw = ImageDraw.Draw(frame_pil)
#             font = ImageFont.truetype("arial.ttf", 40)  # Make sure arial.ttf is available or replace it
#             draw.text((10, 10), bidi_text, font=font, fill=(0, 255, 0))
#             frame = cv2.cvtColor(np.array(frame_pil), cv2.COLOR_RGB2BGR)

#         cv2.imshow("Arabic Sign Language", frame)
#         if cv2.waitKey(1) & 0xFF == ord('q'):
#             break

#     cap.release()
#     cv2.destroyAllWindows()

# @app.route('/receive', methods=['POST'])
# def receive():
#     data = request.get_json()
#     print(f"Received data from Flutter: {data}")

#     # Start the model code in a new thread
#     threading.Thread(target=run_model_camera).start()

#     return {'message': 'Model started successfully'}, 200

# if __name__ == '__main__':
#     app.run(debug=True, host='127.0.0.1', port=5000)
