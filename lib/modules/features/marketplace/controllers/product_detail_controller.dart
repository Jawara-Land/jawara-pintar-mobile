import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/controllers/cart_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/repositories/marketplace_repository.dart';

class ProductDetailController extends GetxController {
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final RxBool isLoading = true.obs;
  
  final int productId;

  ProductDetailController({required this.productId});

  @override
  void onInit() {
    super.onInit();
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    isLoading.value = true;
    try {
      final response = await MarketplaceRepository.getProductDetail(productId);
      if (response['success'] == true) {
        product.value = ProductModel.fromJson(response['data']['product']);
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal memuat detail produk');
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(int quantity) async {
    try {
      final cartController = Get.find<CartController>();
      await cartController.addToCart(productId, quantity);
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
