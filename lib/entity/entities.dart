class CourseEntity {
  final int id;
  final String title;
  final List<Map<String, dynamic>> questions;
  final List<Map<String, String>> cards;
  final String noteContent;

  CourseEntity({
    required this.id,
    required this.title,
    required this.questions,
    required this.cards,
    required this.noteContent,
  });

  factory CourseEntity.fromJson(Map<String, dynamic> json) {
    return CourseEntity(
      id: json['id'],
      title: json['title'],
      questions: (json['questions'] as List<dynamic>? ?? [])
          .expand((item) => item as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(),
      // Explicitly parse cards as a List<Map<String, String>>
      cards: (json['cards'] as List<dynamic>? ?? [])
          .expand((item) => item as List<dynamic>)
          .map((item) => (item as Map).map(
                (key, value) => MapEntry(
                  key.toString(),
                  value.toString(),
                ),
              ))
          .toList(),
      noteContent: json['note_content'] ?? '',
    );
  }
}

class CourseCardEntity {
  final int id;
  final String date;
  final String title;
  final String? file;

  CourseCardEntity(
      {required this.id,
      required this.date,
      required this.title,
      required this.file});

  factory CourseCardEntity.fromJson(Map<String, dynamic> json) {
    return CourseCardEntity(
      id: json['id'],
      date: json['created_at'],
      title: json['title'],
      file: json['file'],
    );
  }
}
