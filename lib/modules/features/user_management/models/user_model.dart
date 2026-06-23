import 'package:jawara_mobile/shared/models/base_response.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final String status;
  final String? nik;
  final String? gender;
  final String? phoneNumber;
  final String? identityPhoto;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.status,
    this.nik,
    this.gender,
    this.phoneNumber,
    this.identityPhoto,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['registration_status'] ?? '',
      nik: json['nik'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      identityPhoto: json['identity_photo'],
      avatar: json['avatar'],
    );
  }
}

class UserListResponse extends BaseResponse<List<UserModel>> {
  UserListResponse({
    required super.success,
    required super.message,
    required super.statusCode,
    super.data,
    super.errors,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    List<UserModel> parsedData = [];

    dynamic rawData = json['data'];

    List<dynamic>? items;
    if (rawData is Map) {
      if (rawData['users'] is Map && rawData['users']['data'] is List) {
        items = rawData['users']['data'];
      } else if (rawData['users'] is List) {
        items = rawData['users'];
      } else if (rawData['data'] is List) {
        items = rawData['data'];
      }
    } else if (rawData is List) {
      items = rawData;
    }

    if (items != null) {
      parsedData = items
          .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return UserListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      statusCode: json['_statusCode'] as int? ?? 0,
      data: parsedData,
    );
  }
}

class UserDetailResponse extends BaseResponse<UserModel> {
  UserDetailResponse({
    required super.success,
    required super.message,
    required super.statusCode,
    super.data,
    super.errors,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    UserModel? parsedData;
    if (json['data'] != null && json['data'] is Map) {
      parsedData = UserModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    }

    return UserDetailResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      statusCode: json['_statusCode'] as int? ?? 0,
      data: parsedData,
    );
  }
}
