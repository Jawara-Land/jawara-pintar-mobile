import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/repositories/store_repository.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/marketplace_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final ProductModel? product = Get.arguments?['product'];
  final bool isEdit = Get.arguments?['product'] != null;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  // Goods-specific controllers
  final _weightController = TextEditingController();

  // Service-specific controllers
  final _durationController = TextEditingController();
  final _tncController = TextEditingController();
  final _locationController = TextEditingController();

  int? _selectedCategoryId;
  String _productType = 'goods'; // 'goods' or 'service'
  File? _image;
  bool _isLoading = false;

  final marketplaceController = Get.find<MarketplaceController>();

  @override
  void initState() {
    super.initState();
    if (isEdit && product != null) {
      _nameController.text = product!.name;
      _descriptionController.text = product!.description ?? '';
      _priceController.text = product!.price.toString();
      _stockController.text = product!.stock.toString();
      _selectedCategoryId = product!.categoryId;
      _productType = product!.type;
      _weightController.text = product!.weight?.toString() ?? '';
      _durationController.text = product!.duration ?? '';
      _tncController.text = product!.tnc ?? '';
      _locationController.text = product!.location ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    _tncController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      Get.snackbar('Error', 'Silakan pilih kategori produk');
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> response;
      if (isEdit) {
        response = await StoreRepository.updateProduct(
          product!.id,
          name: _nameController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          price: int.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          categoryId: _selectedCategoryId,
          type: _productType,
          duration: _productType == 'service' ? _durationController.text : null,
          tnc: _productType == 'service' ? _tncController.text : null,
          location: _productType == 'service' ? _locationController.text : null,
          image: _image,
        );
      } else {
        if (_image == null) {
          Get.snackbar('Error', 'Gambar produk wajib diupload');
          setState(() => _isLoading = false);
          return;
        }

        response = await StoreRepository.createProduct(
          name: _nameController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          price: int.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          categoryId: _selectedCategoryId!,
          type: _productType,
          duration: _productType == 'service' ? _durationController.text : null,
          tnc: _productType == 'service' ? _tncController.text : null,
          location: _productType == 'service' ? _locationController.text : null,
          image: _image,
        );
      }

      if (response['success'] == true) {
        Get.back();
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Produk berhasil disimpan',
        );
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal menyimpan produk');
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColor.surfaceVariant,
                    border: Border.all(color: AppColor.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : (isEdit && product?.imageUrl != null)
                      ? CachedNetworkImage(
                          imageUrl: product!.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: AppColor.textTertiary,
                            ),
                            SizedBox(height: 8),
                            Text('Tap untuk upload gambar'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // Categories Dropdown
              Obx(() {
                if (marketplaceController.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  hint: const Text('Pilih Kategori *'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: marketplaceController.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategoryId = val;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),

              Text('Tipe Produk *', style: AppTextStyle.labelLarge),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Barang'),
                      value: 'goods',
                      groupValue: _productType,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setState(() {
                          _productType = val!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Jasa'),
                      value: 'service',
                      groupValue: _productType,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setState(() {
                          _productType = val!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),

              SizedBox(height: 16),

              if (_productType == 'service') ...[
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Durasi Layanan (e.g. 2 Jam / 1 Hari) *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      _productType == 'service' && (val == null || val.isEmpty)
                      ? 'Durasi layanan wajib diisi'
                      : null,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi Layanan *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      _productType == 'service' && (val == null || val.isEmpty)
                      ? 'Lokasi layanan wajib diisi'
                      : null,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _tncController,
                  decoration: const InputDecoration(
                    labelText: 'Syarat & Ketentuan *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (val) =>
                      _productType == 'service' && (val == null || val.isEmpty)
                      ? 'Syarat & ketentuan wajib diisi'
                      : null,
                ),

                SizedBox(height: 16),
              ],

              if (_productType == 'goods') ...[
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Berat (gram)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 16),
              ],

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Harga (Rp) *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib' : null,
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: 'Stok *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Wajib' : null,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: AppColor.textOnPrimary,
                      )
                    : Text(isEdit ? 'Simpan' : 'Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
