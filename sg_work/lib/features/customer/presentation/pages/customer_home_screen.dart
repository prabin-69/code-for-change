import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../bloc/customer_bloc.dart';
import '../../domain/entities/category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/domain/entities/search_professional.dart';

/// Time-based greeting
String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

/// Category icon mapping
IconData _categoryIcon(String name) {
  switch (name.toLowerCase()) {
    case 'plumbing':
      return Icons.plumbing;
    case 'electrician':
    case 'electrical':
      return Icons.electrical_services;
    case 'carpenter':
      return Icons.carpenter;
    case 'painter':
    case 'painting':
      return Icons.format_paint;
    case 'cleaner':
    case 'cleaning':
      return Icons.cleaning_services;
    case 'ac repair':
    case 'ac':
      return Icons.ac_unit;
    case 'tutor':
    case 'tutoring':
      return Icons.school;
    case 'photographer':
    case 'photography':
      return Icons.camera_alt;
    case 'moving':
    case 'shifting':
      return Icons.local_shipping;
    case 'gardening':
      return Icons.yard;
    case 'pest control':
      return Icons.bug_report;
    case 'salon':
    case 'beauty':
      return Icons.face;
    default:
      return Icons.build_circle_outlined;
  }
}

/// Category color mapping
Color _categoryColor(String name) {
  switch (name.toLowerCase()) {
    case 'plumbing':
      return const Color(0xFF3B82F6);
    case 'electrician':
    case 'electrical':
      return const Color(0xFFF59E0B);
    case 'carpenter':
      return const Color(0xFF8B5CF6);
    case 'painter':
    case 'painting':
      return const Color(0xFFEC4899);
    case 'cleaner':
    case 'cleaning':
      return const Color(0xFF10B981);
    case 'ac repair':
    case 'ac':
      return const Color(0xFF06B6D4);
    case 'tutor':
    case 'tutoring':
      return const Color(0xFFF97316);
    case 'photographer':
    case 'photography':
      return const Color(0xFF6366F1);
    case 'moving':
    case 'shifting':
      return const Color(0xFFEF4444);
    case 'gardening':
      return const Color(0xFF22C55E);
    default:
      return AppColors.primary;
  }
}

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    if (value.trim().isEmpty) return;
    context.push('/search', extra: value);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<CustomerBloc>()..add(LoadCategoriesEvent()),
        ),
        BlocProvider(
          create: (_) => GetIt.I<SearchBloc>()
            ..add(SearchRequested('')),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ─── Header ───
              _buildHeader(),

              // ─── Body with BlocConsumer ───
              Expanded(
                child: BlocConsumer<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is CustomerFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.danger,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CustomerLoading) {
                      return _buildShimmerLoading();
                    } else if (state is CategoriesLoaded) {
                      return _buildBody(context, state.categories);
                    }
                    return _buildEmptyState();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomNav(index: 0, onTap: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              context.push('/customer/my-requests');
              break;
            case 3:
              context.push('/chat', extra: 'Customer Support');
              break;
            case 4:
              context.push('/customer/profile');
              break;
          }
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          children: [
            // ─── Top Row ───
            Row(
              children: [
                // Avatar + Greeting
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()} 👋',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Find your service',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Location
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Ghorahi',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Notifications
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 20, color: Colors.white),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ─── Search Bar ───
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.shadowLg,
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: const TextStyle(color: AppColors.textTertiary),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
                    onPressed: () => _onSearch(_searchController.text.trim()),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerCategoryGrid(),
          SizedBox(height: 24),
          ShimmerProfessionalCard(),
          SizedBox(height: 12),
          ShimmerProfessionalCard(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: EmptyState(
        icon: Icons.category_outlined,
        title: 'No categories yet',
        subtitle: 'Categories will appear here once available.',
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Category> categories) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Promo Banner ───
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
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
                          'Verified Professionals',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Book trusted & verified\nexperts near you',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.verified_user_rounded, size: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─── Categories Section ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categories', style: AppTextStyles.subHeading),
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

          // ─── Category Grid ───
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(
                name: category.name,
                icon: _categoryIcon(category.name),
                color: _categoryColor(category.name),
                onTap: () => context.push('/customer/professions', extra: category.id),
              );
            },
          ),

          const SizedBox(height: 24),

          // ─── Featured Professionals from API ───
          _FeaturedProfessionals(),

          const SizedBox(height: 24),

          // ─── Footer ───
          const Center(
            child: Text(
              '© 2025 SewaGhar. All rights reserved.',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Featured professionals section loaded from SearchBloc API
class _FeaturedProfessionals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Featured Professionals', style: AppTextStyles.subHeading),
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
        BlocBuilder<SearchBloc, SearchState>(
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
                          child: _FeaturedProfessionalCard(
                            professional: p as SearchProfessional,
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
        ),
      ],
    );
  }
}

/// Featured professional card using SearchProfessional entity from API
class _FeaturedProfessionalCard extends StatelessWidget {
  final SearchProfessional professional;

  const _FeaturedProfessionalCard({required this.professional});

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
            Row(
              children: [
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${professional.firstName} ${professional.lastName}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          if (professional.availability == 'available')
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        professional.professionName ?? 'Professional',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.starActive),
                          const SizedBox(width: 3),
                          Text(
                            professional.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          if (professional.totalJobs > 0) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.work_history_rounded, size: 12, color: AppColors.textTertiary),
                            const SizedBox(width: 3),
                            Text(
                              '${professional.totalJobs} jobs',
                              style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/professional-preview', extra: {
                        'name': '${professional.firstName} ${professional.lastName}',
                        'profession': professional.professionName ?? 'Professional',
                        'id': professional.id,
                        'categoryId': professional.categoryId ?? '',
                        'professionId': professional.professionId ?? '',
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('View Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/booking', extra: {
                        'name': '${professional.firstName} ${professional.lastName}',
                        'profession': professional.professionName ?? 'Professional',
                        'professionalId': professional.id,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

// ─── Category Card ───

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

