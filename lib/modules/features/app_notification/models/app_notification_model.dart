class AppNotificationModel {
  final int id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final bool isRead;
  final String createdAt;
  final String formattedDate;

  AppNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.createdAt,
    required this.formattedDate,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parsedData = {};
    if (json['data'] is Map<String, dynamic>) {
      parsedData = json['data'];
    }

    return AppNotificationModel(
      id: json['id'],
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: parsedData,
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
      formattedDate: json['formatted_date'] ?? '',
    );
  }
}
