import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.productDetailRoute, arguments: {'id': product.id});
      },
      child: Card(
        elevation: 4,
        shadowColor: AppColor.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: product.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,

                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColor.surfaceVariant,
                        highlightColor: AppColor.inputFill,
                        child: Container(color: AppColor.surface),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Container(
                      color: AppColor.surfaceVariant,
                      child: Center(child: Icon(Icons.image)),
                    ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.headingSmall,
                  ),

                  SizedBox(height: 4),

                  CurrencyText(
                    product.price,
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColor.primary,
                    ),
                  ),

                  SizedBox(height: 4),

                  Divider(),

                  SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.store, size: 14),

                      SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          product.storeName ?? '',
                          style: AppTextStyle.caption.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
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
