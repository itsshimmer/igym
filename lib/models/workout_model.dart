class WorkoutModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String level;
  final String duration;
  final List<Map<String, dynamic>> exercises;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.duration,
    required this.exercises,
  });

  /// Converte o documento do Firestore (Map) para o objeto Dart
  factory WorkoutModel.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      level: map['level'] ?? '',
      duration: map['duration'] ?? '',
      exercises: List<Map<String, dynamic>>.from(map['exercises'] ?? []),
    );
  }

  /// Converte o objeto Dart para Map (útil para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'duration': duration,
      'exercises': exercises,
    };
  }
}