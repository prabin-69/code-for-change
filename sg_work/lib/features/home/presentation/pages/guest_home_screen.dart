import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/domain/entities/search_professional.dart';
import '../widgets/home_widgets.dart';

/// Benefit cards data (marketing content, not demo data - keep this)
class _Benefit {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _Benefit(this.title, this.subtitle, this.icon, this.color);
}

const List<_Benefit> _benefits = [
  _Benefit('Verified Professionals',
      'All professionals are background verified', Icons.verified_user, AppColors.verified),
  _Benefit('Secure Booking',
      'Your payments and data are protected', Icons.security, AppColors.primary),
  _Benefit('Fast Response',
      'Get responses within minutes', Icons.flash_on, AppColors.warning),
  _Benefit('Fair Pricing',
      'Transparent pricing with no hidden fees', Icons.attach_money, AppColors.success),
];

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchService() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    context.push('/search', extra: query);
  }

  void _showLogin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: AppColors.primary, size: 24),
            SizedBox(width: 10),
            Text(
              'Login Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'Please login to access this feature.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          GradientButton(
            label: 'Login',
            icon: null,
            onPressed: () {
              Navigator.pop(context);
              context.push('/login');
            },
            height: 42,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // ─── Sliver Header ───
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.home_repair_service,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Find trusted\nprofessionals near you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Search Bar ───
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppColors.shadowLg,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _searchService(),
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
                        onPressed: _searchService,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Categories Section (API-driven via CustomerBloc) ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Categories',
                      style: AppTextStyles.subHeading,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      label: const Text('See All'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ─── Category Grid (API-driven, replaces old hardcoded _categories) ───
                const HomeCategoryGrid(isCustomer: false),

                const SizedBox(height: 24),

                // ─── Banner Carousel ───
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppColors.shadowLg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Safety First',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'All professionals are verified\nfor your safety',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Featured Professionals (API-driven via SearchBloc) ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Professionals',
                      style: AppTextStyles.subHeading,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      label: const Text('See All'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ─── API-driven Professional Cards (replaces Ram Bahadur & Sita Sharma) ───
                _FeaturedProfessionalsList(
                  onView: (professional) {
                    context.push('/professional-preview', extra: {
                      'name': '${professional.firstName} ${professional.lastName}',
                      'profession': professional.professionName ?? 'Professional',
                      'id': professional.id,
                    });
                  },
                  onBook: (professional) {
                    _showLogin();
                  },
                ),

                const SizedBox(height: 24),

                // ─── Why Choose SewaGhar ───
                const Text(
                  'Why Choose SewaGhar?',
                  style: AppTextStyles.subHeading,
                ),
                const SizedBox(height: 12),
                ..._benefits.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _BenefitCard(benefit: b),
                    )),

                const SizedBox(height: 32),

                // ─── Login CTA ───
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Join SewaGhar Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Create an account to book services,\nchat with professionals, and more.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          label: 'Get Started',
                          icon: Icons.arrow_forward_ios,
                          onPressed: () => context.push('/login'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Footer ───
                const Center(
                  child: Text(
                    '© 2025 SewaGhar. All rights reserved.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(index: 0, onTap: (i) {
        if (i == 1) _searchService();
        if (i >= 2) _showLogin();
      }),
    );
  }
}

// ─── Bottom Navigation ───

class _BottomNav extends StatelessWidget {
  final int index;
  final void Function(int) onTap;
  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: BottomNavigationBar(
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Booking'),
              BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Featured Professionals List (API-driven) ───

class _FeaturedProfessionalsList extends StatelessWidget {
  final void Function(SearchProfessional) onView;
  final void Function(SearchProfessional) onBook;

  const _FeaturedProfessionalsList({
    required this.onView,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Column(
            children: [
              ShimmerProfessionalCard(),
              SizedBox(height: 12),
              ShimmerProfessionalCard(),
            ],
          );
        }
        if (state is SearchLoaded) {
          if (state.professionals.isEmpty) {
            return const EmptyState(
              icon: Icons.person_search_outlined,
              title: 'No professionals yet',
              subtitle: 'Professionals will appear here once they complete their setup.',
            );
          }
          return Column(
            children: state.professionals
                .take(3)
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SimpleProfessionalCard(
                        professional: p as SearchProfessional,
                        onView: () => onView(p),
                        onBook: () => onBook(p),
                      ),
                    ))
                .toList(),
          );
        }
        if (state is SearchFailure) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Unable to load professionals',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─── Simple Professional Card (API-driven) ───

class _SimpleProfessionalCard extends StatelessWidget {
  final SearchProfessional professional;
  final VoidCallback onView;
  final VoidCallback onBook;

  const _SimpleProfessionalCard({
    required this.professional,
    required this.onView,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.shadowMd,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ─── Top Row ───
            Row(
              children: [
                // ─── Avatar ───
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: professional.photoUrl != null
                        ? Image.network(professional.photoUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, size: 30, color: AppColors.primary))
                        : const Icon(Icons.person_rounded, size: 30, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 14),
                // ─── Info ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${professional.firstName} ${professional.lastName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (professional.availability == 'available')
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        professional.professionName ?? 'Professional',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.starActive),
                          const SizedBox(width: 3),
                          Text(
                            professional.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (professional.totalJobs > 0) ...[
                            const SizedBox(width: 12),
                            const Icon(Icons.work_history_rounded, size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 3),
                            Text(
                              '${professional.totalJobs} jobs',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ─── Action Row ───
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onView,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('View Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Book Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Benefit Card ───

class _BenefitCard extends StatelessWidget {
  final _Benefit benefit;
  const _BenefitCard({required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowSm,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: benefit.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(benefit.icon, size: 22, color: benefit.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  benefit.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
