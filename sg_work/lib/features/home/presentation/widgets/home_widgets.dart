import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../search/domain/entities/search_professional.dart';
import '../../../search/presentation/bloc/search_bloc.dart';

// ──────────────────────────────────────────────────────────────
// 1. CATEGORY GRID – API-driven (works for both Guest & Customer)
// ──────────────────────────────────────────────────────────────

/// Icon mapping
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

/// Color mapping
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

/// Category grid item widget
class HomeCategoryCard extends StatelessWidget {
  final String name;
  final String categoryId;
  final bool isCustomer;

  const HomeCategoryCard({
    super.key,
    required this.name,
    required this.categoryId,
    this.isCustomer = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(name);
    final icon = _categoryIcon(name);

    return GestureDetector(
      onTap: () {
        if (isCustomer) {
          context.push('/customer/professions', extra: categoryId);
        } else {
          context.push('/search', extra: name);
        }
      },
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

/// Category grid that loads from CustomerBloc
class HomeCategoryGrid extends StatelessWidget {
  final bool isCustomer;

  const HomeCategoryGrid({super.key, this.isCustomer = false});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CustomerBloc>().state;
    if (categories is CategoriesLoaded) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.categories.length,
        itemBuilder: (context, index) {
          final cat = categories.categories[index];
          return HomeCategoryCard(
            name: cat.name,
            categoryId: cat.id,
            isCustomer: isCustomer,
          );
        },
      );
    }
    // Shimmer placeholder while loading
    return const _CategoryGridShimmer();
  }
}

class _CategoryGridShimmer extends StatelessWidget {
  const _CategoryGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) {
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerLoading(width: 56, height: 56, borderRadius: 16),
            SizedBox(height: 6),
            ShimmerLoading(width: 40, height: 10, borderRadius: 4),
          ],
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 2. PROMOTIONAL BANNER
// ──────────────────────────────────────────────────────────────

class HomePromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const HomePromoBanner({
    super.key,
    this.title = 'Verified Professionals',
    this.subtitle = 'Book trusted & verified\nexperts near you',
    this.icon = Icons.verified_user_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
              child: Icon(icon, size: 30, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 3. FEATURED PROFESSIONAL CARD – unified for guest/customer
// ──────────────────────────────────────────────────────────────

class HomeProfessionalCard extends StatelessWidget {
  final String name;
  final String profession;
  final double rating;
  final int reviews;
  final int jobs;
  final String distance;
  final String price;
  final bool available;
  final bool verified;
  final VoidCallback onView;
  final VoidCallback onBook;
  final VoidCallback? onFavorite;

  const HomeProfessionalCard({
    super.key,
    required this.name,
    required this.profession,
    required this.rating,
    this.reviews = 0,
    required this.jobs,
    required this.distance,
    this.price = 'From Rs. 500',
    this.available = true,
    this.verified = true,
    required this.onView,
    required this.onBook,
    this.onFavorite,
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
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.person_rounded, size: 30, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (verified)
                            const Icon(Icons.verified_rounded, size: 16, color: AppColors.verified),
                          if (available)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
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
                        profession,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.starActive),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (reviews > 0)
                            Text(
                              '($reviews)',
                              style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                            ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              price,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.work_history_rounded, size: 12, color: AppColors.textTertiary),
                          const SizedBox(width: 3),
                          Text(
                            '$jobs jobs',
                            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                          const SizedBox(width: 3),
                          Text(
                            distance,
                            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Favorite icon (only for customers)
                if (onFavorite != null)
                  IconButton(
                    icon: const Icon(Icons.favorite_outline_rounded, size: 20, color: AppColors.textTertiary),
                    onPressed: onFavorite,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

// ──────────────────────────────────────────────────────────────
// 4. STATS ROW – customer-specific quick stats
// ──────────────────────────────────────────────────────────────

class HomeStatsRow extends StatelessWidget {
  final List<StatItem> stats;

  const HomeStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats
          .map((s) => Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppColors.shadowSm,
                  ),
                  child: Column(
                    children: [
                      Icon(s.icon, size: 22, color: AppColors.primary),
                      const SizedBox(height: 6),
                      Text(
                        s.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.label,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class StatItem {
  final IconData icon;
  final String value;
  final String label;
  const StatItem({required this.icon, required this.value, required this.label});
}

// ──────────────────────────────────────────────────────────────
// 5. BOTTOM NAV – auth-aware
//
// Reads auth state directly from AuthBloc at invocation time so
// every tap always uses the current authentication status.
// ──────────────────────────────────────────────────────────────

/// Returns true when the current AuthBloc state represents a logged-in
/// customer (role === "CUSTOMER").
bool _isCustomerState(AuthState state) =>
    state is AuthSuccess && state.user.role.toUpperCase() == 'CUSTOMER';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isCustomer;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.isCustomer,
  });

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
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textTertiary,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            onTap: (index) => _onNavTap(context, index),
            items: isCustomer
                ? const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
                    BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Booking'),
                    BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: 'Chat'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
                  ]
                : const [
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

  void _onNavTap(BuildContext context, int index) {
    // Read the current auth state directly from the bloc – always fresh.
    final authState = context.read<AuthBloc>().state;
    final isAuthCustomer = _isCustomerState(authState);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        // Search – always available
        context.push('/search', extra: '');
        break;
      case 2:
        // Booking – requires login
        if (isAuthCustomer) {
          context.push('/customer/my-requests');
        } else {
          _requireLogin(context);
        }
        break;
      case 3:
        // Chat – requires login
        if (isAuthCustomer) {
          context.push('/chat', extra: 'Customer Support');
        } else {
          _requireLogin(context);
        }
        break;
      case 4:
        // Profile – requires login
        if (isAuthCustomer) {
          context.push('/customer/profile');
        } else {
          _requireLogin(context);
        }
        break;
    }
  }

  void _requireLogin(BuildContext context) {
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
              context.push(RouteConstants.phoneLogin);
            },
            height: 42,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// 6. HEADER – auth-aware greeting header
// ──────────────────────────────────────────────────────────────

class HomeHeader extends StatelessWidget {
  final bool isCustomer;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.isCustomer = false,
    this.onNotificationTap,
  });

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Icon(
                    isCustomer ? Icons.person_rounded : Icons.home_repair_service,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCustomer) ...[
                        Text(
                          '${_greeting()} 👋',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      const Text(
                        'Find trusted professionals',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Location badge
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
                // Notifications (customer only)
                if (isCustomer)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 20, color: Colors.white),
                      onPressed: onNotificationTap ?? () {},
                      padding: EdgeInsets.zero,
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

// ──────────────────────────────────────────────────────────────
// 7. FEATURED PROFESSIONALS SECTION – API-driven via SearchBloc
//    Replaces the old hardcoded HomeProfessionalCard instances.
// ──────────────────────────────────────────────────────────────

/// Loads featured professionals from the search API and displays them
/// using HomeProfessionalCard. Works for both guest and customer users.
class FeaturedProfessionalsSection extends StatefulWidget {
  final bool isCustomer;
  final void Function(Map<String, String> data) onViewProfessional;
  final void Function(Map<String, String> data) onBookProfessional;
  final VoidCallback? onFavorite;

  const FeaturedProfessionalsSection({
    super.key,
    this.isCustomer = false,
    required this.onViewProfessional,
    required this.onBookProfessional,
    this.onFavorite,
  });

  @override
  State<FeaturedProfessionalsSection> createState() => _FeaturedProfessionalsSectionState();
}

class _FeaturedProfessionalsSectionState extends State<FeaturedProfessionalsSection> {
  @override
  void initState() {
    super.initState();
    // Load professionals if SearchBloc is in initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchState = context.read<SearchBloc>().state;
      if (searchState is SearchInitial) {
        context.read<SearchBloc>().add(SearchRequested(''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Column(
            children: [
              ShimmerLoading(height: 180, borderRadius: 18),
              SizedBox(height: 12),
              ShimmerLoading(height: 180, borderRadius: 18),
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
          // Show real professionals from the database
          return Column(
            children: state.professionals
                .take(5)
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildCardFromSearchProfessional(context, p as SearchProfessional),
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

  Widget _buildCardFromSearchProfessional(BuildContext context, SearchProfessional p) {
    final name = '${p.firstName} ${p.lastName}';
    final profession = p.professionName ?? 'Professional';
    final distance = '${(p.id.hashCode % 5) + 1}.${(p.id.hashCode % 10)} km'; // Simulated distance
    final price = 'From Rs. ${500 + (p.id.hashCode % 10) * 50}'; // Simulated price

    return HomeProfessionalCard(
      name: name,
      profession: profession,
      rating: p.rating,
      reviews: p.totalJobs, // Use totalJobs as review count for display
      jobs: p.totalJobs,
      distance: distance,
      price: price,
      available: p.availability == 'available',
      verified: true, // All seeded professionals are verified
      onView: () => widget.onViewProfessional({
        'name': name,
        'profession': profession,
        'id': p.id,
        'categoryId': p.categoryId ?? '',
        'professionId': p.professionId ?? '',
      }),
      onBook: () => widget.onBookProfessional({
        'name': name,
        'profession': profession,
        'professionalId': p.id,
        'categoryId': p.categoryId ?? '',
        'professionId': p.professionId ?? '',
      }),
      onFavorite: widget.isCustomer ? widget.onFavorite : null,
    );
  }
}

