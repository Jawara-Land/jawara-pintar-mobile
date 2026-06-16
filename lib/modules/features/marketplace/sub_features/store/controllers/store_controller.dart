import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/models/store_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/models/store_dashboard_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/models/address_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/repositories/store_repository.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/repositories/address_repository.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class StoreController extends GetxController {
  final Rxn<StoreModel> store = Rxn<StoreModel>();
  final RxList<ProductModel> myProducts = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'all'.obs;
  final Rxn<StoreDashboardModel> dashboard = Rxn<StoreDashboardModel>();
  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;

  final RxBool isLoadingStore = false.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingDashboard = false.obs;
  final RxBool sameAddressAsHome = false.obs;
  final RxBool samePhoneAsHome = false.obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final defaultShippingController = TextEditingController();
  final Rxn<File> storeImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchMyStore();
    fetchDashboard();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    defaultShippingController.dispose();
    super.onClose();
  }

  Future<void> fetchMyStore() async {
    isLoadingStore.value = true;
    try {
      final response = await StoreRepository.getMyStore();
      if (response['success'] == true) {
        if (response['data']['store'] != null) {
          store.value = StoreModel.fromJson(response['data']['store']);
          _populateForm();
          fetchMyProducts();
        }
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat data toko: $e');
      log('Error fetching store: $e');
    } finally {
      isLoadingStore.value = false;
    }
  }

  Future<void> fetchMyProducts() async {
    isLoadingProducts.value = true;
    try {
      final response = await StoreRepository.getMyProducts();
      if (response['success'] == true) {
        final List data = response['data']['products'] ?? [];
        myProducts.value = data.map((e) => ProductModel.fromJson(e)).toList();
        filterProducts();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      log('Error fetching my products: $e');
      Get.snackbar('Error', 'Gagal memuat produk toko: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  Future<void> fetchDashboard() async {
    isLoadingDashboard.value = true;
    try {
      final response = await StoreRepository.getStoreDashboard();
      if (response['success'] == true && response['data'] != null) {
        dashboard.value = StoreDashboardModel.fromJson(response['data']);
        recentOrders.value = dashboard.value?.recentOrders ?? [];
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      log('Error fetching dashboard: $e');
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  void filterProducts() {
    var filtered = myProducts.toList();

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    if (selectedFilter.value == 'active') {
      filtered = filtered.where((p) => p.isActive).toList();
    } else if (selectedFilter.value == 'inactive') {
      filtered = filtered.where((p) => !p.isActive).toList();
    }

    filteredProducts.value = filtered;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterProducts();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    filterProducts();
  }

  Future<void> toggleProductStatus(ProductModel product, bool isActive) async {
    try {
      final response = await StoreRepository.updateProduct(
        product.id,
        isActive: isActive,
      );
      if (response['success'] == true) {
        fetchMyProducts();
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal mengubah status produk');
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void _populateForm() {
    if (store.value != null) {
      nameController.text = store.value!.name;
      descriptionController.text = store.value!.description ?? '';
      addressController.text = store.value!.address ?? '';
      phoneController.text = store.value!.phone ?? '';
      defaultShippingController.text = store.value!.shippingCost.toString();
    }
  }

  Future<void> fillAddressFromHome() async {
    try {
      final response = await AddressRepository.getAddresses();
      if (response['success'] == true) {
        final List data = response['data']['addresses'] ?? [];
        final addresses = data.map((e) => AddressModel.fromJson(e)).toList();
        final primaryAddress = addresses.firstWhereOrNull(
          (element) => element.isPrimary,
        );

        if (primaryAddress != null && primaryAddress.address.isNotEmpty) {
          addressController.text = primaryAddress.address;
        } else {
          sameAddressAsHome.value = false;
          _showNoPrimaryAddressSnackbar();
        }
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      sameAddressAsHome.value = false;
      Get.snackbar('Error', 'Gagal memuat alamat rumah: $e');
    }
  }

  Future<void> fillPhoneFromHome() async {
    try {
      final response = await AddressRepository.getAddresses();
      if (response['success'] == true) {
        final List data = response['data']['addresses'] ?? [];
        final addresses = data.map((e) => AddressModel.fromJson(e)).toList();
        final primaryAddress = addresses.firstWhereOrNull(
          (element) => element.isPrimary,
        );

        if (primaryAddress != null &&
            primaryAddress.phone != null &&
            primaryAddress.phone!.isNotEmpty) {
          phoneController.text = primaryAddress.phone!;
        } else {
          samePhoneAsHome.value = false;
          _showNoPrimaryAddressSnackbar();
        }
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      samePhoneAsHome.value = false;
      Get.snackbar('Error', 'Gagal memuat nomor HP rumah: $e');
    }
  }

  void _showNoPrimaryAddressSnackbar() {
    Get.rawSnackbar(
      title: 'Info',
      message:
          'Alamat utama belum diset, silakan set di profil terlebih dahulu',
      mainButton: TextButton(
        onPressed: () {
          Get.back();
          Get.toNamed(Routes.profileRoute);
        },
        child: Text('Set Profil', style: TextStyle(color: AppColor.warning)),
      ),
    );
  }

  Future<bool> createOrUpdateStore() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Nama toko harus diisi');
      return false;
    }

    isLoadingStore.value = true;
    try {
      Map<String, dynamic> response;
      if (store.value == null) {
        response = await StoreRepository.createStore(
          name: nameController.text,
          description: descriptionController.text,
          address: addressController.text,
          phone: phoneController.text,
          shippingCost: int.tryParse(defaultShippingController.text) ?? 0,
          image: storeImage.value,
        );
      } else {
        response = await StoreRepository.updateStore(
          name: nameController.text,
          description: descriptionController.text,
          address: addressController.text,
          phone: phoneController.text,
          shippingCost: int.tryParse(defaultShippingController.text) ?? 0,
          image: storeImage.value,
        );
      }

      if (response['success'] == true) {
        store.value = StoreModel.fromJson(response['data']['store']);
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Berhasil menyimpan data toko',
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal menyimpan data toko',
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    } finally {
      isLoadingStore.value = false;
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      final response = await StoreRepository.deleteProduct(productId);
      if (response['success'] == true) {
        myProducts.removeWhere((element) => element.id == productId);
        Get.snackbar('Sukses', 'Produk berhasil dihapus');
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal menghapus produk');
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
