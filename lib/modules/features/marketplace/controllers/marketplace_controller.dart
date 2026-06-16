import 'dart:developer';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/product_category_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/repositories/marketplace_repository.dart';

class MarketplaceController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductCategoryModel> categories = <ProductCategoryModel>[].obs;
  
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingCategories = false.obs;
  
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxString searchQuery = ''.obs;
  final RxnInt selectedCategoryId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    Sentry.captureException('MarketplaceController initialized');
    fetchCategories();
    debounce(searchQuery, (_) => fetchProducts(refresh: true), time: const Duration(milliseconds: 500));
    fetchProducts(refresh: true);
  }

  Future<void> onRefresh() async {
    await Future.wait([
      fetchCategories(),
      fetchProducts(refresh: true),
    ]);
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await MarketplaceRepository.getCategories();
      if (response['success'] == true) {
        final List data = response['data']['categories'] ?? [];
        categories.value = data.map((e) => ProductCategoryModel.fromJson(e)).toList();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      products.clear();
    }

    if (!hasMoreData.value || isLoadingProducts.value) return;

    isLoadingProducts.value = true;
    try {
      final response = await MarketplaceRepository.getProducts(
        page: currentPage.value,
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
      );

      if (response['success'] == true) {
        final List data = response['data']['products'] ?? [];
        final newProducts = data.map((e) => ProductModel.fromJson(e)).toList();
        
        if (newProducts.isEmpty) {
          hasMoreData.value = false;
        } else {
          products.addAll(newProducts);
          currentPage.value++;
        }
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat produk: $e');
      log('Error fetching products: $e');
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }

  void onCategorySelected(int? categoryId) {
    selectedCategoryId.value = categoryId;
    fetchProducts(refresh: true);
  }
}