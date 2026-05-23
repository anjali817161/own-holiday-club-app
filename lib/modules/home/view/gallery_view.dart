import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../controller/home_controller.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import 'package:own_holiday_app/widgets/skeleton.dart';

class GalleryView extends GetView<HomeController> {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          Obx(() {
            if (controller.isLoading.value && controller.allServicesWithGallery.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: List.generate(3, (index) => _buildSkeletonGroup()),
                  ),
                ),
              );
            }

            if (controller.allServicesWithGallery.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text('No gallery images available.'),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = controller.allServicesWithGallery[index];
                    final gallery = List<String>.from(service['gallery'] ?? []);
                    
                    if (gallery.isEmpty) return const SizedBox.shrink();

                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(service['serviceTitle'] ?? 'Luxury Experience'),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: gallery.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, i) => _buildGalleryImage(gallery[i]),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    );
                  },
                  childCount: controller.allServicesWithGallery.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryWhite,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryBlack, size: 18),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'LUXURY GALLERY',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.normal,
            fontSize: 9.0,
            color: AppColors.primaryWhite,
            letterSpacing: 1.5,
            shadows: [
              Shadow(color: AppColors.primaryBlack.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/santorini_experience.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryBlack.withOpacity(0.2),
                    AppColors.primaryBlack.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primaryYellow,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 9.0,
            fontWeight: FontWeight.normal,
            color: AppColors.primaryBlack,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(String url) {
    return GestureDetector(
      onTap: () {
        // Full screen preview if needed
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Skeleton(),
            errorWidget: (context, url, error) => Container(
              color: AppColors.lightGrey,
              child: const Icon(Icons.broken_image_outlined, color: AppColors.greyText),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Skeleton(height: 24, width: 150),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(4, (index) => const Skeleton(borderRadius: 16.0)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
