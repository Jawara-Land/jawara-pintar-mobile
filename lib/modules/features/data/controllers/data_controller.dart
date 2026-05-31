import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/data/models/family_model.dart';
import 'package:jawara_mobile/modules/features/data/models/house_model.dart';
import 'package:jawara_mobile/modules/features/data/models/permission_model.dart';
import 'package:jawara_mobile/modules/features/data/models/resident_model.dart';
import 'package:jawara_mobile/modules/features/data/repositories/data_repository.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';

class DataController extends GetxController with GetSingleTickerProviderStateMixin {
  static DataController get to => Get.find();

  late TabController tabController;

  // Permissions
  final Rx<PermissionModel> permissions = PermissionModel().obs;

  // --- Scroll Controllers for Pagination ---
  final ScrollController scrollWarga = ScrollController();
  final ScrollController scrollRumah = ScrollController();
  final ScrollController scrollKeluarga = ScrollController();

  // --- Observables: Warga (Residents) ---
  final RxList<ResidentModel> residents = <ResidentModel>[].obs;
  final RxBool residentsLoading = false.obs;
  final RxBool residentsLoadMore = false.obs;
  final RxInt residentsPage = 1.obs;
  final RxBool residentsHasNext = false.obs;
  final RxList<FamilyModel> familyOptions = <FamilyModel>[].obs;

  // Warga Filters & Search
  final RxString searchWargaQuery = ''.obs;
  final RxString filterGender = ''.obs;
  final RxString filterActiveStatus = ''.obs;
  final RxnInt filterFamilyId = RxnInt();

  // --- Observables: Rumah (Houses) ---
  final RxList<HouseModel> houses = <HouseModel>[].obs;
  final RxBool housesLoading = false.obs;
  final RxBool housesLoadMore = false.obs;
  final RxInt housesPage = 1.obs;
  final RxBool housesHasNext = false.obs;

  // Rumah Filters & Search
  final RxString searchRumahQuery = ''.obs;
  final RxString filterHouseStatus = ''.obs;

  // --- Observables: Keluarga (Families) ---
  final RxList<FamilyModel> families = <FamilyModel>[].obs;
  final RxBool familiesLoading = false.obs;
  final RxBool familiesLoadMore = false.obs;
  final RxInt familiesPage = 1.obs;
  final RxBool familiesHasNext = false.obs;
  final RxList<HouseModel> houseOptions = <HouseModel>[].obs;

  // Keluarga Filters & Search
  final RxString searchKeluargaQuery = ''.obs;
  final RxnInt filterHouseId = RxnInt();
  final RxString filterIsActive = ''.obs;

  // --- Observables: My Family (Resident Role) ---
  final Rxn<FamilyModel> myFamily = Rxn<FamilyModel>();
  final RxList<ResidentModel> myFamilyMembers = <ResidentModel>[].obs;
  final RxBool myFamilyLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Load permissions from AuthController
    final authUser = Get.find<AuthController>().currentUser.value;
    if (authUser != null) {
      permissions.value = authUser.permissions;
    }

    // Initialize TabController based on permissions
    int tabCount = permissions.value.hasDataAccess ? 3 : 2;
    tabController = TabController(length: tabCount, vsync: this);

    // Setup scroll listeners for lazy loading
    scrollWarga.addListener(() {
      if (scrollWarga.position.pixels >= scrollWarga.position.maxScrollExtent - 200) {
        loadMoreResidents();
      }
    });

    scrollRumah.addListener(() {
      if (scrollRumah.position.pixels >= scrollRumah.position.maxScrollExtent - 200) {
        loadMoreHouses();
      }
    });

    scrollKeluarga.addListener(() {
      if (scrollKeluarga.position.pixels >= scrollKeluarga.position.maxScrollExtent - 200) {
        loadMoreFamilies();
      }
    });

    // Debounce search inputs so we don't spam the API
    debounce(searchWargaQuery, (_) => fetchResidents(refresh: true), time: const Duration(milliseconds: 500));
    debounce(searchRumahQuery, (_) => fetchHouses(refresh: true), time: const Duration(milliseconds: 500));
    debounce(searchKeluargaQuery, (_) => fetchFamilies(refresh: true), time: const Duration(milliseconds: 500));

    // Initial load
    refreshAll();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollWarga.dispose();
    scrollRumah.dispose();
    scrollKeluarga.dispose();
    super.onClose();
  }

  void refreshAll() {
    if (permissions.value.hasDataAccess) {
      fetchResidents(refresh: true);
      fetchHouses(refresh: true);
      fetchFamilies(refresh: true);
    } else if (permissions.value.hasOnlyMyFamilyAccess) {
      fetchMyFamily();
    }
  }

  // --- Fetching Citizens (Warga) ---
  Future<void> fetchResidents({bool refresh = false}) async {
    if (!permissions.value.residentsIndex) return;

    if (refresh) {
      residentsPage.value = 1;
      residentsLoading.value = true;
    } else {
      residentsLoadMore.value = true;
    }

    try {
      final res = await DataRepository.getResidents(
        name: searchWargaQuery.value,
        gender: filterGender.value,
        activeStatus: filterActiveStatus.value,
        familyId: filterFamilyId.value,
        page: residentsPage.value,
      );

      if (res['success'] == true) {
        final list = res['residents'] as List<ResidentModel>;
        if (refresh) {
          residents.assignAll(list);
        } else {
          residents.addAll(list);
        }

        // Setup filter options if available
        final fams = res['families'] as List<FamilyModel>?;
        if (fams != null && fams.isNotEmpty) {
          familyOptions.assignAll(fams);
        }

        final pagination = res['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          residentsHasNext.value = pagination['current_page'] < pagination['last_page'];
        } else {
          residentsHasNext.value = false;
        }
      } else {
        Get.snackbar('Error', res['message'] ?? 'Gagal memuat data warga');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      residentsLoading.value = false;
      residentsLoadMore.value = false;
    }
  }

  void loadMoreResidents() {
    if (!residentsLoading.value && !residentsLoadMore.value && residentsHasNext.value) {
      residentsPage.value++;
      fetchResidents();
    }
  }

  // --- Fetching Houses (Rumah) ---
  Future<void> fetchHouses({bool refresh = false}) async {
    if (!permissions.value.housesIndex) return;

    if (refresh) {
      housesPage.value = 1;
      housesLoading.value = true;
    } else {
      housesLoadMore.value = true;
    }

    try {
      final res = await DataRepository.getHouses(
        address: searchRumahQuery.value,
        status: filterHouseStatus.value,
        page: housesPage.value,
      );

      if (res['success'] == true) {
        final list = res['houses'] as List<HouseModel>;
        if (refresh) {
          houses.assignAll(list);
        } else {
          houses.addAll(list);
        }

        final pagination = res['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          housesHasNext.value = pagination['current_page'] < pagination['last_page'];
        } else {
          housesHasNext.value = false;
        }
      } else {
        Get.snackbar('Error', res['message'] ?? 'Gagal memuat data rumah');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      housesLoading.value = false;
      housesLoadMore.value = false;
    }
  }

  void loadMoreHouses() {
    if (!housesLoading.value && !housesLoadMore.value && housesHasNext.value) {
      housesPage.value++;
      fetchHouses();
    }
  }

  // --- Fetching Families (Keluarga) ---
  Future<void> fetchFamilies({bool refresh = false}) async {
    if (!permissions.value.familiesIndex) return;

    if (refresh) {
      familiesPage.value = 1;
      familiesLoading.value = true;
    } else {
      familiesLoadMore.value = true;
    }

    try {
      final res = await DataRepository.getFamilies(
        name: searchKeluargaQuery.value,
        currentHouseId: filterHouseId.value,
        isActive: filterIsActive.value,
        page: familiesPage.value,
      );

      if (res['success'] == true) {
        final list = res['families'] as List<FamilyModel>;
        if (refresh) {
          families.assignAll(list);
        } else {
          families.addAll(list);
        }

        // Setup filter options if available
        final hs = res['houses'] as List<HouseModel>?;
        if (hs != null && hs.isNotEmpty) {
          houseOptions.assignAll(hs);
        }

        final pagination = res['pagination'] as Map<String, dynamic>?;
        if (pagination != null) {
          familiesHasNext.value = pagination['current_page'] < pagination['last_page'];
        } else {
          familiesHasNext.value = false;
        }
      } else {
        Get.snackbar('Error', res['message'] ?? 'Gagal memuat data keluarga');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      familiesLoading.value = false;
      familiesLoadMore.value = false;
    }
  }

  void loadMoreFamilies() {
    if (!familiesLoading.value && !familiesLoadMore.value && familiesHasNext.value) {
      familiesPage.value++;
      fetchFamilies();
    }
  }

  // --- Fetching My Family (Resident) ---
  Future<void> fetchMyFamily() async {
    myFamilyLoading.value = true;
    try {
      final res = await DataRepository.getMyFamily();
      if (res['success'] == true) {
        myFamily.value = res['family'] as FamilyModel;
        await fetchMyFamilyMembers();
      } else {
        Get.snackbar('Info', res['message'] ?? 'Gagal memuat profil keluarga');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      myFamilyLoading.value = false;
    }
  }

  Future<void> fetchMyFamilyMembers() async {
    try {
      final res = await DataRepository.getMyFamilyMembers();
      if (res['success'] == true) {
        myFamilyMembers.assignAll(res['members'] as List<ResidentModel>);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat anggota keluarga: $e');
    }
  }

  // --- Mutation Methods ---
  Future<bool> createResident(Map<String, dynamic> payload) async {
    try {
      final res = await DataRepository.storeResident(payload);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Warga berhasil ditambahkan!');
        fetchResidents(refresh: true);
        return true;
      } else {
        String errMsg = res['message'] ?? 'Gagal menambahkan warga.';
        if (res['errors'] != null) {
          // Format validation errors nicely
          final errorsMap = res['errors'] as Map<String, dynamic>;
          errMsg = errorsMap.values.map((e) => (e as List).join('\n')).join('\n');
        }
        Get.snackbar('Gagal', errMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> editResident(int id, Map<String, dynamic> payload) async {
    try {
      final res = await DataRepository.updateResident(id, payload);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Warga berhasil diperbarui!');
        fetchResidents(refresh: true);
        return true;
      } else {
        String errMsg = res['message'] ?? 'Gagal memperbarui warga.';
        if (res['errors'] != null) {
          final errorsMap = res['errors'] as Map<String, dynamic>;
          errMsg = errorsMap.values.map((e) => (e as List).join('\n')).join('\n');
        }
        Get.snackbar('Gagal', errMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> deleteResident(int id) async {
    try {
      final res = await DataRepository.deleteResident(id);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Warga berhasil dihapus!');
        fetchResidents(refresh: true);
        return true;
      } else {
        Get.snackbar('Gagal', res['message'] ?? 'Gagal menghapus warga.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> createHouse(Map<String, dynamic> payload) async {
    try {
      final res = await DataRepository.storeHouse(payload);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Rumah berhasil dibuat!');
        fetchHouses(refresh: true);
        return true;
      } else {
        Get.snackbar('Gagal', res['message'] ?? 'Gagal membuat rumah.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> editHouse(int id, Map<String, dynamic> payload) async {
    try {
      final res = await DataRepository.updateHouse(id, payload);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Rumah berhasil diperbarui!');
        fetchHouses(refresh: true);
        return true;
      } else {
        Get.snackbar('Gagal', res['message'] ?? 'Gagal memperbarui rumah.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> deleteHouse(int id) async {
    try {
      final res = await DataRepository.deleteHouse(id);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Rumah berhasil dihapus!');
        fetchHouses(refresh: true);
        return true;
      } else {
        Get.snackbar('Gagal', res['message'] ?? 'Gagal menghapus rumah.');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  // --- Resident Family Member Mutations ---
  Future<bool> createMyFamilyMember(Map<String, dynamic> payload) async {
    try {
      final res = await DataRepository.storeMyFamilyMember(payload);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Anggota keluarga berhasil ditambahkan!');
        fetchMyFamilyMembers();
        return true;
      } else {
        String errMsg = res['message'] ?? 'Gagal menambahkan anggota.';
        if (res['errors'] != null) {
          final errorsMap = res['errors'] as Map<String, dynamic>;
          errMsg = errorsMap.values.map((e) => (e as List).join('\n')).join('\n');
        }
        Get.snackbar('Gagal', errMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  Future<bool> editMyFamilyMember(int id, Map<String, dynamic> payload) async {
    try {
      final res = await DataRepository.updateMyFamilyMember(id, payload);
      if (res['success'] == true) {
        Get.snackbar('Sukses', res['message'] ?? 'Anggota keluarga berhasil diperbarui!');
        fetchMyFamilyMembers();
        return true;
      } else {
        String errMsg = res['message'] ?? 'Gagal memperbarui anggota.';
        if (res['errors'] != null) {
          final errorsMap = res['errors'] as Map<String, dynamic>;
          errMsg = errorsMap.values.map((e) => (e as List).join('\n')).join('\n');
        }
        Get.snackbar('Gagal', errMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }
}
