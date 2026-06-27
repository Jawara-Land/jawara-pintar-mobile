import 'package:jawara_mobile/shared/models/base_response.dart';

class AspirationModel {
  final int id;
  final String title;
  final String description;
  final String authorName;
  final String status;
  final String? categoryName;
  final DateTime? createdAt;

  const AspirationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.status,
    this.categoryName,
    this.createdAt,
  });

  factory AspirationModel.fromJson(Map<String, dynamic> json) {
    return AspirationModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description:
          json['description'] as String? ??
          json['content'] as String? ??
          json['message'] as String? ??
          '',
      authorName:
          (json['resident_name'] ??
                  json['author_name'] ??
                  json['user_name'] ??
                  'Warga')
              .toString(),
      status: (json['status'] ?? 'pending').toString(),
      categoryName: json['category_name']?.toString(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
    );
  }
}

class AspirationCategory {
  final int id;
  final String name;

  const AspirationCategory({required this.id, required this.name});

  factory AspirationCategory.fromJson(Map<String, dynamic> json) {
    return AspirationCategory(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class AspirationListResponse extends BaseResponse<List<AspirationModel>> {
  AspirationListResponse({
    required super.success,
    required super.message,
    required super.statusCode,
    super.data,
    super.errors,
  });
}
