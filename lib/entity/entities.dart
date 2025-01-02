class CourseEntity {
  final int id;
  final String title;
  final List<List<Map<String, dynamic>>>? questions;
  final List<List<Map<String, dynamic>>>? cards;
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
      questions: json['questions'] != null
          ? (json['questions'] as List<dynamic>)
              .map((nestedList) => (nestedList as List<dynamic>)
                  .map((item) => item as Map<String, dynamic>)
                  .toList())
              .toList()
          : [],
      cards: json['cards'] != null
          ? (json['cards'] as List<dynamic>)
              .map((nestedList) => (nestedList as List<dynamic>)
                  .map((item) => item as Map<String, dynamic>)
                  .toList())
              .toList()
          : [],
      noteContent: json['note_content'] ?? '',
    );
  }
}


class CourseCardEntity {
  final int id;
  final String date;
  final String title;
  final String? file;


  CourseCardEntity({
    required this.id,
    required this.date,
    required this.title,
    required this.file

  });

  factory CourseCardEntity.fromJson(Map<String, dynamic> json) {
    return CourseCardEntity(
      id: json['id'],
      date: json['created_at'],
      title: json['title'],
      file: json['file'],

    );
  }
}
