class ActivityLog {
  final int id;
  final String description;
  final String? causer;
  final Map<String, dynamic>? properties;
  final String? createdAt;

  ActivityLog({
    required this.id,
    required this.description,
    this.causer,
    this.properties,
    this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as int,
      description: json['description'] as String,
      causer: json['causer'] as String?,
      properties: json['properties'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
    );
  }
}
