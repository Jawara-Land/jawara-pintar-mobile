class EventCategoryModel {
  final int id;
  final String name;

  EventCategoryModel({required this.id, required this.name});

  factory EventCategoryModel.fromJson(Map<String, dynamic> json) {
    return EventCategoryModel(id: json['id'], name: json['name'] ?? '');
  }
}
