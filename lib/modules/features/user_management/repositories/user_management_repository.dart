import 'package:jawara_mobile/modules/features/user_management/constants/user_management_api_constant.dart';
import 'package:jawara_mobile/modules/features/user_management/models/user_model.dart';
import 'package:jawara_mobile/shared/models/base_response.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class UserManagementRepository {
  Future<List<UserModel>> getUsers({int page = 1, String? search}) async {
    String url = '${UserManagementApiConstant.listUsers}?page=$page';
    if (search != null && search.isNotEmpty) {
      url += '&filter[name]=$search';
    }

    final response = await ApiService.get(url);
    if (response['_statusCode'] == 200) {
      final userResponse = UserListResponse.fromJson(response);
      return userResponse.data ?? [];
    }
    throw Exception(response['message'] ?? 'Failed to load users');
  }

  Future<List<UserModel>> getResidentApprovals({int page = 1}) async {
    String url =
        '${UserManagementApiConstant.listResidentApprovals}?page=$page';

    final response = await ApiService.get(url);
    if (response['_statusCode'] == 200) {
      final userResponse = UserListResponse.fromJson(response);
      return userResponse.data ?? [];
    }
    throw Exception(response['message'] ?? 'Failed to load pending residents');
  }

  Future<BaseResponse> approveResident(int id) async {
    final response = await ApiService.put(
      '${UserManagementApiConstant.approveResident}$id/approve',
      {},
    );
    if (response['_statusCode'] == 200) {
      return BaseResponse.fromJson(response);
    }
    throw Exception(response['message'] ?? 'Failed to approve resident');
  }

  Future<BaseResponse> rejectResident(int id) async {
    final response = await ApiService.put(
      '${UserManagementApiConstant.rejectResident}$id/reject',
      {},
    );
    if (response['_statusCode'] == 200) {
      return BaseResponse.fromJson(response);
    }
    throw Exception(response['message'] ?? 'Failed to reject resident');
  }

  Future<BaseResponse> deleteUser(int id) async {
    final response = await ApiService.delete(
      '${UserManagementApiConstant.deleteUser}$id',
    );
    if (response['_statusCode'] == 200) {
      return BaseResponse.fromJson(response);
    }
    throw Exception(response['message'] ?? 'Failed to delete user');
  }

  Future<UserModel> getUserDetail(int id) async {
    final response = await ApiService.get(
      '${UserManagementApiConstant.userDetail}$id',
    );
    if (response['_statusCode'] == 200) {
      final detail = UserDetailResponse.fromJson(response);
      if (detail.data != null) {
        return detail.data!;
      }
    }
    throw Exception(response['message'] ?? 'Failed to load user details');
  }

  Future<BaseResponse<UserModel>> createUser(Map<String, dynamic> data) async {
    final response = await ApiService.post(
      UserManagementApiConstant.listUsers,
      data,
    );
    if (response['_statusCode'] == 201 || response['_statusCode'] == 200) {
      return UserDetailResponse.fromJson(response);
    }

    String errorMsg = response['message'] ?? 'Failed to create user';
    if (response['errors'] != null && response['errors'] is Map) {
      errorMsg = (response['errors'] as Map).values
          .map((v) => (v as List).join(', '))
          .join('\n');
    }
    throw Exception(errorMsg);
  }

  Future<BaseResponse<UserModel>> updateUser(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.put(
      '${UserManagementApiConstant.userDetail}$id',
      data,
    );
    if (response['_statusCode'] == 200) {
      return UserDetailResponse.fromJson(response);
    }

    String errorMsg = response['message'] ?? 'Failed to update user';
    if (response['errors'] != null && response['errors'] is Map) {
      errorMsg = (response['errors'] as Map).values
          .map((v) => (v as List).join(', '))
          .join('\n');
    }
    throw Exception(errorMsg);
  }
}
