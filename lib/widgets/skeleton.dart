import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:own_holiday_app/utils/app_colors.dart';

class Skeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.borderGrey,
      highlightColor: AppColors.lightGrey,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
