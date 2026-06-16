import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/models/cart_item_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/repositories/cart_repository.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxInt totalAmount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAddingToCart = false.obs;
  final RxList<int> selectedCartItemIds = <int>[].obs;

  final RxMap<int, bool> storeSelections = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  List<int> get uniqueStoreIds {
    return cartItems.map((e) => e.product.storeId).toSet().toList();
  }

  Map<int, List<CartItemModel>> get itemsGroupedByStore {
    final map = <int, List<CartItemModel>>{};
    for (final item in cartItems) {
      map.putIfAbsent(item.product.storeId, () => []).add(item);
    }
    return map;
  }

  String getStoreName(int storeId) {
    final item = cartItems.firstWhereOrNull(
      (e) => e.product.storeId == storeId,
    );
    return item?.product.storeName ?? 'Toko';
  }

  bool isStoreFullySelected(int storeId) {
    final storeItems = cartItems.where((e) => e.product.storeId == storeId);
    return storeItems.isNotEmpty &&
        storeItems.every((item) => selectedCartItemIds.contains(item.id));
  }

  void toggleStoreSelection(int storeId) {
    final storeItems = cartItems
        .where((e) => e.product.storeId == storeId)
        .toList();
    final allSelected = isStoreFullySelected(storeId);
    if (allSelected) {
      for (final item in storeItems) {
        selectedCartItemIds.remove(item.id);
      }
    } else {
      for (final item in storeItems) {
        if (!selectedCartItemIds.contains(item.id)) {
          selectedCartItemIds.add(item.id);
        }
      }
    }
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final response = await CartRepository.getCart();
      if (response['success'] == true) {
        final List data = response['data']['cart_items'] ?? [];
        cartItems.value = data.map((e) => CartItemModel.fromJson(e)).toList();
        totalAmount.value = (response['data']['total'] as num?)?.toInt() ?? 0;

        if (selectedCartItemIds.isEmpty) {
          selectedCartItemIds.addAll(cartItems.map((e) => e.id));
        } else {
          final currentIds = cartItems.map((e) => e.id).toSet();
          selectedCartItemIds.removeWhere((id) => !currentIds.contains(id));
        }
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat keranjang: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleItemSelection(int cartId) {
    if (selectedCartItemIds.contains(cartId)) {
      selectedCartItemIds.remove(cartId);
    } else {
      selectedCartItemIds.add(cartId);
    }
  }

  void toggleAllSelections(bool selectAll) {
    selectedCartItemIds.clear();
    if (selectAll) {
      selectedCartItemIds.addAll(cartItems.map((e) => e.id));
    }
  }

  int get selectedTotalAmount {
    return cartItems
        .where((item) => selectedCartItemIds.contains(item.id))
        .fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  Future<void> updateQuantity(int cartId, int newQuantity) async {
    if (newQuantity < 1) return;

    final index = cartItems.indexWhere((element) => element.id == cartId);
    if (index == -1) return;

    // Save old quantity for revert
    final oldItem = cartItems[index];
    final oldQuantity = oldItem.quantity;

    cartItems[index] = CartItemModel(
      id: oldItem.id,
      productId: oldItem.productId,
      quantity: newQuantity,
      product: oldItem.product,
    );
    cartItems.refresh();

    try {
      final response = await CartRepository.updateCartItem(cartId, newQuantity);
      if (response['success'] != true) {
        // Revert on failure
        cartItems[index] = CartItemModel(
          id: oldItem.id,
          productId: oldItem.productId,
          quantity: oldQuantity,
          product: oldItem.product,
        );
        cartItems.refresh();
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal memperbarui kuantitas',
        );
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      // Revert on error
      cartItems[index] = CartItemModel(
        id: oldItem.id,
        productId: oldItem.productId,
        quantity: oldQuantity,
        product: oldItem.product,
      );
      cartItems.refresh();
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> removeItem(int cartId) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Item'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus item ini dari keranjang?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColor.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await CartRepository.deleteCartItem(cartId);
      if (response['success'] == true) {
        cartItems.removeWhere((element) => element.id == cartId);
        selectedCartItemIds.remove(cartId);
        Get.snackbar('Sukses', 'Item dihapus dari keranjang');
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal menghapus item');
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    isAddingToCart.value = true;
    try {
      final response = await CartRepository.addToCart(productId, quantity);
      if (response['success'] == true) {
        Get.snackbar('Sukses', 'Produk berhasil ditambahkan ke keranjang');

        fetchCart();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal menambahkan ke keranjang',
        );
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isAddingToCart.value = false;
    }
  }

  void proceedToCheckout() {
    final selectedItems = cartItems
        .where((item) => selectedCartItemIds.contains(item.id))
        .toList();
    if (selectedItems.isEmpty) {
      Get.snackbar('Info', 'Pilih minimal satu item untuk checkout');
      return;
    }
    Get.toNamed(
      Routes.checkoutRoute,
      arguments: {'selected_items': selectedItems},
    );
  }
}
