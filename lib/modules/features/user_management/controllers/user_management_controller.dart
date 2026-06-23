import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/user_management/models/user_model.dart';
import 'package:jawara_mobile/modules/features/user_management/repositories/user_management_repository.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UserManagementController extends GetxController {
  final UserManagementRepository _repository = UserManagementRepository();

  var isLoadingUsers = false.obs;
  var isLoadingPending = false.obs;
  var isProcessingAction = false.obs;

  var errorMessageUsers = ''.obs;
  var errorMessagePending = ''.obs;

  var users = <UserModel>[].obs;
  var pendingResidents = <UserModel>[].obs;

  int _currentUsersPage = 1;
  int _currentPendingPage = 1;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchPendingResidents();
  }

  Future<void> fetchUsers({bool refresh = false, String? search}) async {
    try {
      if (refresh) {
        _currentUsersPage = 1;
        users.clear();
      }
      isLoadingUsers(true);
      errorMessageUsers('');

      final result = await _repository.getUsers(
        page: _currentUsersPage,
        search: search,
      );
      users.addAll(result);
      if (result.isNotEmpty) _currentUsersPage++;
    } catch (e) {
      errorMessageUsers(e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
    } finally {
      isLoadingUsers(false);
    }
  }

  Future<void> fetchPendingResidents({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPendingPage = 1;
        pendingResidents.clear();
      }
      isLoadingPending(true);
      errorMessagePending('');

      final result = await _repository.getResidentApprovals(
        page: _currentPendingPage,
      );
      pendingResidents.addAll(result);
      if (result.isNotEmpty) _currentPendingPage++;
    } catch (e) {
      errorMessagePending(e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
    } finally {
      isLoadingPending(false);
    }
  }

  Future<bool> approveResident(int id) async {
    try {
      isProcessingAction(true);
      await _repository.approveResident(id);
      pendingResidents.removeWhere((item) => item.id == id);
      Get.snackbar('Sukses', 'Registrasi warga disetujui');
      fetchUsers(refresh: true);
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
      return false;
    } finally {
      isProcessingAction(false);
    }
  }

  Future<bool> rejectResident(int id) async {
    try {
      isProcessingAction(true);
      await _repository.rejectResident(id);
      pendingResidents.removeWhere((item) => item.id == id);
      Get.snackbar('Berhasil', 'Registrasi warga ditolak');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
      return false;
    } finally {
      isProcessingAction(false);
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      isProcessingAction(true);
      await _repository.deleteUser(id);
      users.removeWhere((item) => item.id == id);
      Get.snackbar('Sukses', 'Pengguna berhasil dihapus');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
      return false;
    } finally {
      isProcessingAction(false);
    }
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    try {
      isProcessingAction(true);
      final response = await _repository.createUser(data);
      if (response.data != null) {
        users.insert(0, response.data!);
      }
      Get.snackbar('Sukses', 'Pengguna berhasil dibuat');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
      return false;
    } finally {
      isProcessingAction(false);
    }
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    try {
      isProcessingAction(true);
      final response = await _repository.updateUser(id, data);

      if (response.data != null) {
        final index = users.indexWhere((u) => u.id == id);
        if (index != -1) {
          users[index] = response.data!;
        }
      }
      Get.snackbar('Sukses', 'Pengguna berhasil diperbarui');
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      Sentry.captureException(e);
      return false;
    } finally {
      isProcessingAction(false);
    }
  }

  void confirmDeleteUser(BuildContext context, int userId, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text('Apakah anda yakin ingin menghapus pengguna $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteUser(userId);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void confirmApproveResident(BuildContext context, int userId, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terima Warga'),
        content: Text('Apakah anda yakin menerima $name sebagai warga?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            onPressed: () {
              Navigator.pop(context);
              approveResident(userId);
            },
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void confirmRejectResident(BuildContext context, int userId, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tolak Warga'),
        content: Text('Apakah anda yakin menolak pendaftaran $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              rejectResident(userId);
            },
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
