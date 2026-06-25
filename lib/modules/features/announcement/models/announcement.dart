class AnnouncementModel {
  final int id;
  final String title;
  final String creator;
  final String content;
  final String published;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.creator,
    required this.content,
    required this.published,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'] ?? '',
      creator: json['creator'] ?? '',
      content: json['content'] ?? '',
      published: json['published'] ?? '',
    );
  }
}
