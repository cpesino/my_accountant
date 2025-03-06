import 'package:flutter/material.dart';
import 'package:my_accountant/src/util/constants/sizes.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, required this.itemCount});
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        bool isFirst = index == 0;
        bool isLast = index == itemCount - 1;
        return Container(
          height: 72.0,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: isFirst
                    ? const Radius.circular(TSizes.borderRadiusLg)
                    : Radius.zero,
                bottom: isLast
                    ? const Radius.circular(TSizes.borderRadiusLg)
                    : Radius.zero),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: const Row(
              children: [
                Skeleton(height: 40, width: 40),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(height: 15, width: 130),
                    SizedBox(height: 8),
                    Skeleton(height: 12, width: 75),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Skeleton(height: 20, width: 40),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width});

  final double? height, width;
  final double defaultPadding = 16.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(TSizes.borderRadiusMd),
        ),
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({super.key, this.size = 24});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}
