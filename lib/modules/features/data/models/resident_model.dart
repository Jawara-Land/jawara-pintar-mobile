class ResidentModel {
  final int id;
  final String name;
  final String? nik;
  final String? family;
  final int? familyId;
  final String? familyRole;
  final String? gender;
  final String? activeStatus;
  final String? lifeStatus;
  final String? birthplace;
  final String? birthdate;
  final String? religion;
  final String? bloodType;
  final String? lastEducation;
  final String? occupation;
  final String? phoneNumber;

  ResidentModel({
    required this.id,
    required this.name,
    this.nik,
    this.family,
    this.familyId,
    this.familyRole,
    this.gender,
    this.activeStatus,
    this.lifeStatus,
    this.birthplace,
    this.birthdate,
    this.religion,
    this.bloodType,
    this.lastEducation,
    this.occupation,
    this.phoneNumber,
  });

  bool get isHead => familyRole == 'head';

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    return ResidentModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nik: json['nik'] as String?,
      family: json['family'] as String?,
      familyId: json['family_id'] as int?,
      familyRole: json['family_role'] as String?,
      gender: json['gender'] as String?,
      activeStatus: json['active_status'] as String?,
      lifeStatus: json['life_status'] as String?,
      birthplace: json['birthplace'] as String?,
      birthdate: json['birthdate'] as String?,
      religion: json['religion'] as String?,
      bloodType: json['blood_type'] as String?,
      lastEducation: json['last_education'] as String?,
      occupation: json['occupation'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
}
