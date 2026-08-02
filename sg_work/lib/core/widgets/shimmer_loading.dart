import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A shimmer/skeleton loading widget for modern loading states.
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(-_animation.value, 0),
              colors: const [
                AppColors.outline,
                AppColors.surfaceVariant,
                AppColors.outline,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pre-built shimmer card for professional listings
class ShimmerProfessionalCard extends StatelessWidget {
  const ShimmerProfessionalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowSm,
      ),
      child: const Row(
        children: [
          ShimmerLoading(width: 56, height: 56, borderRadius: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(width: 140, height: 16, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerLoading(width: 100, height: 12, borderRadius: 4),
                SizedBox(height: 6),
                ShimmerLoading(width: 80, height: 12, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer grid for category listing
class ShimmerCategoryGrid extends StatelessWidget {
  final int itemCount;

  const ShimmerCategoryGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.shadowSm,
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerLoading(width: 40, height: 40, borderRadius: 20),
              SizedBox(height: 12),
              ShimmerLoading(width: 80, height: 14, borderRadius: 4),
            ],
          ),
        );
      },
    );
  }
}

/// Shimmer for dashboard stat cards
class ShimmerStatRow extends StatelessWidget {
  const ShimmerStatRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.shadowSm,
            ),
            child: const Column(
              children: [
                ShimmerLoading(width: 32, height: 32, borderRadius: 16),
                SizedBox(height: 10),
                ShimmerLoading(width: 40, height: 20, borderRadius: 4),
                SizedBox(height: 4),
                ShimmerLoading(width: 50, height: 12, borderRadius: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

