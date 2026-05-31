import 'package:jawara_mobile/modules/features/login/models/user_model.dart';
import 'package:jawara_mobile/shared/models/base_response.dart';

class LoginResponse extends BaseResponse {
  final UserModel? user;
  final String? token;
  final String? tokenType;

  LoginResponse({
    required super.success,
    required super.message,
    required super.statusCode,
    super.errors,
    this.user,
    this.token,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final base = BaseResponse.fromJson(json);

    UserModel? user;
    if (json['data'] != null && json['data']['user'] != null) {
      user = UserModel.fromJson(
        json['data']['user'] as Map<String, dynamic>,
        permissionsJson: json['data']['permissions'] as Map<String, dynamic>?,
      );
    }

    return LoginResponse(
      success: base.success,
      message: base.message,
      statusCode: base.statusCode,
      errors: base.errors,
      user: user,
      token: json['data']?['token'] as String?,
      tokenType: json['data']?['token_type'] as String?,
    );
  }
}
