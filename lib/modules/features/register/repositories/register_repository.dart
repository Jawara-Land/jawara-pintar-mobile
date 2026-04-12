import 'dart:io';
import 'package:jawara_mobile/modules/features/register/models/houses_response.dart';
import 'package:jawara_mobile/modules/features/register/models/register_response.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class RegisterRepository {
  RegisterRepository._();

  static Future<HousesResponse> getHouses() async {
    final result = await ApiService.getHouses();
    return HousesResponse.fromJson(result);
  }

  static Future<RegisterResponse> register({
    required String name,
    required String email,
    required String nik,
    required String gender,
    required String phoneNumber,
    required File identityPhoto,
    required String password,
    required String passwordConfirmation,
    required String tempOccupancyStatus,
    int? tempHouseId,
    String? tempAddress,
  }) async {
    final result = await ApiService.register(
      name: name,
      email: email,
      nik: nik,
      gender: gender,
      phoneNumber: phoneNumber,
      identityPhoto: identityPhoto,
      password: password,
      passwordConfirmation: passwordConfirmation,
      tempOccupancyStatus: tempOccupancyStatus,
      tempHouseId: tempHouseId,
      tempAddress: tempAddress,
    );

    return RegisterResponse.fromJson(result);
  }
}
