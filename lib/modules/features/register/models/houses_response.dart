import 'package:jawara_mobile/modules/features/register/models/house_model.dart';
import 'package:jawara_mobile/shared/models/base_response.dart';

class HousesResponse extends BaseResponse {
  final List<HouseModel> houses;

  HousesResponse({
    required super.success,
    required super.message,
    required super.statusCode,
    super.errors,
    required this.houses,
  });

  factory HousesResponse.fromJson(Map<String, dynamic> json) {
    final base = BaseResponse.fromJson(json);

    List<HouseModel> houses = [];
    if (json['data'] != null && json['data']['houses'] != null) {
      houses = (json['data']['houses'] as List<dynamic>)
          .map((item) => HouseModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return HousesResponse(
      success: base.success,
      message: base.message,
      statusCode: base.statusCode,
      errors: base.errors,
      houses: houses,
    );
  }
}
