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
from gtts import gTTS
import pygame
import io
import tempfile
import os


app = Flask(__name__)
CORS(app)

pygame.mixer.init()


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

last_prediction_text = ""

def run_model_camera():
    global last_prediction_text
    cap = cv2.VideoCapture(0)

    while not stop_event.is_set():
        ret, frame = cap.read()
        if not ret:
            break

        frame = cv2.flip(frame, 1)
        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        result = hands.process(rgb)

        current_prediction = ""

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

                    current_prediction = labels_dict.get(prediction, "غير معروف")

        # If we got a new valid prediction and it's different from the last one, speak it
        if current_prediction and current_prediction != last_prediction_text:
            last_prediction_text = current_prediction

            # Play audio for the new prediction
            tts = gTTS(text=last_prediction_text, lang='ar')
            with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as temp_audio:
                temp_filename = temp_audio.name

            tts.save(temp_filename)
            pygame.mixer.music.load(temp_filename)
            pygame.mixer.music.play()

            # Delete audio file after playing
            def delete_temp_file(path):
                import time
                time.sleep(2)
                if os.path.exists(path):
                    os.remove(path)

            threading.Thread(target=delete_temp_file, args=(temp_filename,)).start()

        # Always display the last valid prediction on screen
        if last_prediction_text:
            reshaped_text = arabic_reshaper.reshape(last_prediction_text)
            bidi_text = get_display(reshaped_text)

            frame_pil = Image.fromarray(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            draw = ImageDraw.Draw(frame_pil)
            font = ImageFont.truetype("arial.ttf", 40)
            draw.text((10, 10), bidi_text, font=font, fill=(0, 0, 0))
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

@app.route('/get_prediction', methods=['GET'])
def get_prediction():
    global last_prediction_text
    return {'prediction': last_prediction_text}, 200


if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)

