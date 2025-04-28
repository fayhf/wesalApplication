class DailyExpression {
  final String uid;
  final String name;
  final String description;
  final String? photo;
  final String sound;

  DailyExpression({
    required this.uid,
    required this.name,
    required this.description,
    this.photo,
    required this.sound,
  });

  // Factory constructor to create from Firebase document/map
  factory DailyExpression.fromMap(Map<String, dynamic> data) {
    return DailyExpression(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      photo: data['photo'],
      sound: data['sound'],
    );
  }

  // Convert object to Map for uploading to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      if (photo != null) 'photo': photo,
      'sound': sound,
    };
  }

  // To update any field (immutably)
  DailyExpression copyWith({
    String? uid,
    String? name,
    String? description,
    String? photo,
    String? sound,
  }) {
    return DailyExpression(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      sound: sound ?? this.sound,
    );
  }

  @override
  String toString() {
    return 'DE(uid: $uid, name: $name, description: $description, photo: $photo, sound: $sound)';
  }
}
