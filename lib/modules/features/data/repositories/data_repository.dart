import 'package:jawara_mobile/modules/features/data/constants/data_api_constant.dart';
import 'package:jawara_mobile/modules/features/data/models/family_model.dart';
import 'package:jawara_mobile/modules/features/data/models/house_model.dart';
import 'package:jawara_mobile/modules/features/data/models/resident_model.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class DataRepository {
  DataRepository._();

  // --- Citizens (Warga) ---
  static Future<Map<String, dynamic>> getResidents({
    String? name,
    String? gender,
    String? activeStatus,
    int? familyId,
    int page = 1,
  }) async {
    final queryParams = <String, String>{};
    queryParams['page'] = page.toString();
    if (name != null && name.isNotEmpty) {
      queryParams['filter[name]'] = name;
    }
    if (gender != null && gender.isNotEmpty) {
      queryParams['filter[gender]'] = gender;
    }
    if (activeStatus != null && activeStatus.isNotEmpty) {
      queryParams['filter[active_status]'] = activeStatus;
    }
    if (familyId != null) {
      queryParams['filter[family_id]'] = familyId.toString();
    }

    final uri = Uri.parse(DataApiConstant.residents).replace(queryParameters: queryParams);
    final response = await ApiService.get(uri.toString());

    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['residents'] as List<dynamic>;
      final residents = list.map((e) => ResidentModel.fromJson(e as Map<String, dynamic>)).toList();
      final pagination = response['data']['pagination'] as Map<String, dynamic>?;

      // Extract families for filtering
      final familiesList = response['data']['families'] as List<dynamic>?;
      final families = familiesList != null
          ? familiesList.map((e) => FamilyModel.fromJson(e as Map<String, dynamic>)).toList()
          : <FamilyModel>[];

      return {
        'success': true,
        'residents': residents,
        'families': families,
        'pagination': pagination,
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load residents.'};
  }

  static Future<Map<String, dynamic>> getResidentDetail(int id) async {
    final response = await ApiService.get('${DataApiConstant.residents}/$id');
    if (response['success'] == true && response['data'] != null) {
      return {
        'success': true,
        'resident': ResidentModel.fromJson(response['data']['resident'] as Map<String, dynamic>),
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load resident detail.'};
  }

  static Future<Map<String, dynamic>> storeResident(Map<String, dynamic> data) async {
    return await ApiService.post(DataApiConstant.residents, data);
  }

  static Future<Map<String, dynamic>> updateResident(int id, Map<String, dynamic> data) async {
    return await ApiService.put('${DataApiConstant.residents}/$id', data);
  }

  static Future<Map<String, dynamic>> deleteResident(int id) async {
    return await ApiService.delete('${DataApiConstant.residents}/$id');
  }

  static Future<List<FamilyModel>> getFamilyOptions() async {
    final response = await ApiService.get(DataApiConstant.familyOptions);
    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['families'] as List<dynamic>;
      return list.map((e) => FamilyModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  // --- Houses (Rumah) ---
  static Future<Map<String, dynamic>> getHouses({
    String? address,
    String? status,
    int page = 1,
  }) async {
    final queryParams = <String, String>{};
    queryParams['page'] = page.toString();
    if (address != null && address.isNotEmpty) {
      queryParams['filter[address]'] = address;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['filter[status]'] = status;
    }

    final uri = Uri.parse(DataApiConstant.houses).replace(queryParameters: queryParams);
    final response = await ApiService.get(uri.toString());

    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['houses'] as List<dynamic>;
      final houses = list.map((e) => HouseModel.fromJson(e as Map<String, dynamic>)).toList();
      final pagination = response['data']['pagination'] as Map<String, dynamic>?;

      return {
        'success': true,
        'houses': houses,
        'pagination': pagination,
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load houses.'};
  }

  static Future<Map<String, dynamic>> getHouseDetail(int id) async {
    final response = await ApiService.get('${DataApiConstant.houses}/$id');
    if (response['success'] == true && response['data'] != null) {
      final house = HouseModel.fromJson(response['data']['house'] as Map<String, dynamic>);
      final historyList = response['data']['resident_histories'] as List<dynamic>? ?? [];
      return {
        'success': true,
        'house': house,
        'resident_histories': historyList,
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load house detail.'};
  }

  static Future<Map<String, dynamic>> storeHouse(Map<String, dynamic> data) async {
    return await ApiService.post(DataApiConstant.houses, data);
  }

  static Future<Map<String, dynamic>> updateHouse(int id, Map<String, dynamic> data) async {
    return await ApiService.put('${DataApiConstant.houses}/$id', data);
  }

  static Future<Map<String, dynamic>> deleteHouse(int id) async {
    return await ApiService.delete('${DataApiConstant.houses}/$id');
  }

  // --- Families (Keluarga) ---
  static Future<Map<String, dynamic>> getFamilies({
    String? name,
    int? currentHouseId,
    String? isActive,
    int page = 1,
  }) async {
    final queryParams = <String, String>{};
    queryParams['page'] = page.toString();
    if (name != null && name.isNotEmpty) {
      queryParams['filter[name]'] = name;
    }
    if (currentHouseId != null) {
      queryParams['filter[current_house_id]'] = currentHouseId.toString();
    }
    if (isActive != null && isActive.isNotEmpty) {
      queryParams['filter[is_active]'] = isActive;
    }

    final uri = Uri.parse(DataApiConstant.families).replace(queryParameters: queryParams);
    final response = await ApiService.get(uri.toString());

    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['families'] as List<dynamic>;
      final families = list.map((e) => FamilyModel.fromJson(e as Map<String, dynamic>)).toList();
      final pagination = response['data']['pagination'] as Map<String, dynamic>?;

      // Extract houses for filtering
      final housesList = response['data']['houses'] as List<dynamic>?;
      final houses = housesList != null
          ? housesList.map((e) => HouseModel.fromJson(e as Map<String, dynamic>)).toList()
          : <HouseModel>[];

      return {
        'success': true,
        'families': families,
        'houses': houses,
        'pagination': pagination,
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load families.'};
  }

  static Future<Map<String, dynamic>> getFamilyDetail(int id) async {
    final response = await ApiService.get('${DataApiConstant.families}/$id');
    if (response['success'] == true && response['data'] != null) {
      final family = FamilyModel.fromJson(response['data']['family'] as Map<String, dynamic>);
      final membersList = response['data']['family_members'] as List<dynamic>? ?? [];
      final members = membersList.map((e) => ResidentModel.fromJson(e as Map<String, dynamic>)).toList();
      return {
        'success': true,
        'family': family,
        'members': members,
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load family detail.'};
  }

  // --- Authenticated User's Own Family ---
  static Future<Map<String, dynamic>> getMyFamily() async {
    final response = await ApiService.get(DataApiConstant.myFamily);
    if (response['success'] == true && response['data'] != null) {
      return {
        'success': true,
        'family': FamilyModel.fromJson(response['data']['family'] as Map<String, dynamic>),
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load family profile.'};
  }

  static Future<Map<String, dynamic>> getMyFamilyMembers() async {
    final response = await ApiService.get(DataApiConstant.myFamilyMembers);
    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['members'] as List<dynamic>;
      final members = list.map((e) => ResidentModel.fromJson(e as Map<String, dynamic>)).toList();
      return {
        'success': true,
        'members': members,
      };
    }
    return {'success': false, 'message': response['message'] ?? 'Failed to load family members.'};
  }

  static Future<Map<String, dynamic>> storeMyFamilyMember(Map<String, dynamic> data) async {
    return await ApiService.post(DataApiConstant.myFamilyMembers, data);
  }

  static Future<Map<String, dynamic>> updateMyFamilyMember(int id, Map<String, dynamic> data) async {
    return await ApiService.put('${DataApiConstant.myFamilyMembers}/$id', data);
  }
}
