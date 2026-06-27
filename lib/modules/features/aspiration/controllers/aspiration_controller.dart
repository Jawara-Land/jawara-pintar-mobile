import 'package:get/get.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/modules/features/aspiration/models/aspiration_model.dart';
import 'package:jawara_mobile/modules/features/aspiration/repositories/aspiration_repository.dart';

class AspirationController extends GetxController {
  final AspirationRepository _repository = AspirationRepository();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final aspirations = <AspirationModel>[].obs;
  final categories = <AspirationCategory>[].obs;

  static const writeRoles = ['resident'];
  static const manageRoles = [
    'admin',
    'community_head',
    'secretary',
    'neighborhood_head',
  ];

  bool get canCreate => _hasAnyRole(writeRoles);
  bool get canManage => _hasAnyRole(manageRoles);

  bool _hasAnyRole(List<String> roles) {
    final userRoles = Get.find<AuthController>().currentUser.value?.roles ?? [];
    return userRoles.any(roles.contains);
  }

  @override
  void onInit() {
    super.onInit();
    fetchAspirations();
    fetchCategories();
  }

  Future<void> fetchAspirations() async {
    try {
      isLoading(true);
      errorMessage('');
      aspirations.assignAll(await _repository.getAspirations());
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      categories.assignAll(await _repository.getCategories());
    } catch (_) {}
  }

  Future<void> fetchMyAspirations() async {
    try {
      isLoading(true);
      errorMessage('');
      aspirations.assignAll(await _repository.getMyAspirations());
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> createAspiration(String title, String description) async {
    await _repository.createAspiration(title: title, description: description);
    await fetchAspirations();
  }

  Future<void> updateAspiration(
    int id,
    String title,
    String description,
  ) async {
    await _repository.updateAspiration(
      id: id,
      title: title,
      description: description,
    );
    await fetchAspirations();
  }

  AspirationModel? findAspirationById(int id) {
    for (final item in aspirations) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> deleteAspiration(int id) async {
    await _repository.deleteAspiration(id);
    await fetchAspirations();
  }
}
