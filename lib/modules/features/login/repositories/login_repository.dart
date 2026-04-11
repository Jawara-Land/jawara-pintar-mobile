import 'package:jawara_mobile/modules/features/login/models/login_response.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class LoginRepository {
  LoginRepository._();

  static Future<LoginResponse> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    final result = await ApiService.login(
      email: email,
      password: password,
      deviceName: deviceName,
    );

    return LoginResponse.fromJson(result);
  }
}
