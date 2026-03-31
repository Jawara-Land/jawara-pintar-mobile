import 'package:flutter/material.dart';
import 'package:jawara_mobile/modules/features/marketplace/constants/marketplace_assets_constant.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class MarketplaceScreen extends StatefulWidget {
  MarketplaceScreen({super.key});

  final assetsConstant = MarketplaceAssetsConstant();

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int selectedTabIndex = 0;
  String searchQuery = '';

  final List<String> tabs = ['Semua', 'Paling Populer', 'Termurah'];

  final List<Product> products = [
    Product(
      id: '1',
      title: 'Sayur Organik Segar',
      price: 25000,
      image: Icons.spa,
      seller: 'Pak Budi',
      rating: 4.8,
      sold: 156,
      category: 'Sayuran',
    ),
    Product(
      id: '2',
      title: 'Daging Sapi Premium',
      price: 95000,
      image: Icons.restaurant,
      seller: 'Bu Siti',
      rating: 4.9,
      sold: 89,
      category: 'Daging',
    ),
    Product(
      id: '3',
      title: 'Telur Ayam Kampung',
      price: 45000,
      image: Icons.egg,
      seller: 'Pak Rudi',
      rating: 4.7,
      sold: 234,
      category: 'Telur',
    ),
    Product(
      id: '4',
      title: 'Madu Murni Asli',
      price: 55000,
      image: Icons.water_drop,
      seller: 'Bu Rina',
      rating: 4.9,
      sold: 178,
      category: 'Produk Olahan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Pasar Lokal',
          style: AppTextStyle.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColor.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search & Filter Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadowLight,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari produk...',
                          hintStyle: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.textTertiary,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColor.textTertiary,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadowLight,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune, color: AppColor.textTertiary),
                  ),
                ],
              ),
            ),

            // Seller Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mulai Berjualan',
                          style: AppTextStyle.titleLarge.copyWith(
                            color: AppColor.textOnPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jual produk Anda sekarang',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: AppColor.textOnPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Mulai',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  tabs.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == index
                              ? AppColor.primary
                              : AppColor.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: selectedTabIndex != index
                              ? Border.all(color: AppColor.inputBorder)
                              : null,
                        ),
                        child: Text(
                          tabs[index],
                          style: AppTextStyle.labelSmall.copyWith(
                            color: selectedTabIndex == index
                                ? AppColor.textOnPrimary
                                : AppColor.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColor.primarySurface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                product.image,
                size: 50,
                color: AppColor.primary,
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColor.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${product.price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: AppTextStyle.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.sold})',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColor.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Penjual: ${product.seller}',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String title;
  final int price;
  final IconData image;
  final String seller;
  final double rating;
  final int sold;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.seller,
    required this.rating,
    required this.sold,
    required this.category,
  });
}
