class EventModel {
  final int id;
  final String category;
  final String name;
  final String creator;
  final String date;
  final String description;
  final String? personInCharge;
  final bool hasReport;
  final List<EventPhotoModel>? eventPhotos;

  EventModel({
    required this.id,
    required this.category,
    required this.name,
    required this.creator,
    required this.date,
    required this.description,
    this.personInCharge,
    required this.hasReport,
    this.eventPhotos,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      creator: json['creator'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      personInCharge: json['person_in_charge'],
      hasReport: json['has_report'] == 1 ? true : false,
      eventPhotos: json['event_photos'] != null
          ? (json['event_photos'] as List)
                .map((i) => EventPhotoModel.fromJson(i))
                .toList()
          : null,
    );
  }
}

class EventPhotoModel {
  final int id;
  final String filePath;

  EventPhotoModel({required this.id, required this.filePath});

  factory EventPhotoModel.fromJson(Map<String, dynamic> json) {
    return EventPhotoModel(id: json['id'], filePath: json['file_path']);
  }
}
