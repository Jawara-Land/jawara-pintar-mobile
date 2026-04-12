import 'package:jawara_mobile/shared/models/base_response.dart';

class RegisterResponse extends BaseResponse {
  RegisterResponse({
    required super.success,
    required super.message,
    required super.statusCode,
    super.errors,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final base = BaseResponse.fromJson(json);

    return RegisterResponse(
      success: base.success,
      message: base.message,
      statusCode: base.statusCode,
      errors: base.errors,
    );
  }
}
