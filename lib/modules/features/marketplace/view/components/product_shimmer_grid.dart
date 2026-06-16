import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerGrid extends StatelessWidget{
  const ProductShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.surfaceVariant,
          highlightColor: AppColor.inputFill,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container(color: AppColor.surface)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        color: AppColor.surface,
                      ),
                      const SizedBox(height: 6),
                      Container(height: 14, width: 80, color: AppColor.surface),
                      const SizedBox(height: 6),
                      Container(height: 10, width: 60, color: AppColor.surface),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}