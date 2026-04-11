class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String registrationStatus;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.registrationStatus,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      registrationStatus: json['registration_status'] as String? ?? 'pending',
      roles: json['roles'] != null
          ? List<String>.from(json['roles'] as List<dynamic>)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'registration_status': registrationStatus,
      'roles': roles,
    };
  }
}
