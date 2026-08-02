import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/domain/entities/search_professional.dart';
import '../widgets/home_widgets.dart';

/// ─────────────────────────────────────────────────────────────
/// SHARED HOME SCREEN
///
/// ONE screen for both Guest (unauthenticated) and Customer
/// (authenticated with role "CUSTOMER").
///
/// Guests can browse categories & professionals.
/// Protected actions (Book, Chat, Favorite, Request Service)
/// prompt login.
///
/// Logged-in Customers see the same UI with features unlocked.
///
/// All data is loaded from backend APIs - no hardcoded/mock data.
/// ─────────────────────────────────────────────────────────────
/// Returns true when the current AuthBloc state represents a logged-in
/// customer (role === "CUSTOMER").
bool _isCustomerState(AuthState state) =>
    state is AuthSuccess && state.user.role.toUpperCase() == 'CUSTOMER';

class SharedHomeScreen extends StatelessWidget {
  const SharedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AuthBloc>()),
        BlocProvider(
          create: (_) => GetIt.I<CustomerBloc>()..add(LoadCategoriesEvent()),
        ),
        BlocProvider(
          create: (_) => GetIt.I<SearchBloc>()..add(SearchRequested('')),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            final role = state.user.role.toUpperCase();
            if (role == 'PROFESSIONAL') {
              context.go('/professional/dashboard');
            }
          } else if (state is RoleSelectionRequired) {
            context.push(RouteConstants.roleSelection);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final isCustomer = _isCustomerState(authState);

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: _SharedHomeBody(isCustomer: isCustomer),
              ),
              bottomNavigationBar: HomeBottomNav(
                currentIndex: 0,
                isCustomer: isCustomer,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// SHARED HOME BODY
///
/// Separated from the outer widget so the body can internally use
/// [context.watch] / [context.read] without conflicting with the
/// BlocBuilder scope above.
/// ─────────────────────────────────────────────────────────────
class _SharedHomeBody extends StatefulWidget {
  final bool isCustomer;

  const _SharedHomeBody({required this.isCustomer});

  @override
  State<_SharedHomeBody> createState() => _SharedHomeBodyState();
}

class _SharedHomeBodyState extends State<_SharedHomeBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    context.push('/search', extra: query);
  }

  /// Guest-accessible actions – always allowed
  void _onViewProfessional(Map<String, String> data) {
    context.push('/professional-preview', extra: data);
  }

  /// Protected actions – require login for guests.
  /// Reads auth state directly from the bloc at invocation time.
  void _onBookProfessional(Map<String, String> data) {
    final authState = context.read<AuthBloc>().state;
    if (_isCustomerState(authState)) {
      context.push('/booking', extra: data);
    } else {
      _requireLogin(context, 'Please login to book a professional.');
    }
  }

  void _onFavorite() {
    final authState = context.read<AuthBloc>().state;
    if (!_isCustomerState(authState)) {
      _requireLogin(context, 'Please login to save favorites.');
    }
  }

  void _requireLogin(BuildContext context, String message) {
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
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(RouteConstants.phoneLogin);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustomer = widget.isCustomer;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        const SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: HomeHeader(isCustomer: false),
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
            _buildSearchBar(),

            const SizedBox(height: 24),

            // ─── Promo Banner ───
            const HomePromoBanner(),

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

            // ─── Category Grid (API-driven via CustomerBloc) ───
            HomeCategoryGrid(isCustomer: isCustomer),

            const SizedBox(height: 24),

            // ─── Featured Professionals (API-driven via SearchBloc) ───
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

            // ─── API-driven Professional Cards ───
            // Replaces old hardcoded Ram Bahadur & Sita Sharma cards.
            // Loads ONLY professionals from the backend database via SearchBloc.
            // If no professionals exist, shows premium EmptyState.
            _FeaturedProfessionalsSection(
              isCustomer: isCustomer,
              onViewProfessional: _onViewProfessional,
              onBookProfessional: _onBookProfessional,
              onFavorite: _onFavorite,
            ),

            const SizedBox(height: 24),

            // ─── Guest CTA – Join SewaGhar ───
            if (!isCustomer) _buildGuestCTA(),

            // ─── Footer ───
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '© 2025 SewaGhar. All rights reserved.',
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestCTA() {
    return Container(
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
            child: ElevatedButton(
              onPressed: () => context.push(RouteConstants.phoneLogin),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── Featured Professionals Section (API-driven) ───
/// Loads all professionals from the backend via SearchBloc.
/// Shows ONLY real data from the database.
class _FeaturedProfessionalsSection extends StatelessWidget {
  final bool isCustomer;
  final void Function(Map<String, String>) onViewProfessional;
  final void Function(Map<String, String>) onBookProfessional;
  final VoidCallback onFavorite;

  const _FeaturedProfessionalsSection({
    required this.isCustomer,
    required this.onViewProfessional,
    required this.onBookProfessional,
    required this.onFavorite,
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
                      child: _FeaturedProfessionalCard(
                        professional: p as SearchProfessional,
                        isCustomer: isCustomer,
                        onViewProfessional: onViewProfessional,
                        onBookProfessional: onBookProfessional,
                        onFavorite: onFavorite,
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

/// Featured professional card using SearchProfessional entity from API
class _FeaturedProfessionalCard extends StatelessWidget {
  final SearchProfessional professional;
  final bool isCustomer;
  final void Function(Map<String, String>) onViewProfessional;
  final void Function(Map<String, String>) onBookProfessional;
  final VoidCallback onFavorite;

  const _FeaturedProfessionalCard({
    required this.professional,
    required this.isCustomer,
    required this.onViewProfessional,
    required this.onBookProfessional,
    required this.onFavorite,
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
                if (isCustomer)
                  IconButton(
                    icon: const Icon(Icons.favorite_outline_rounded, size: 20, color: AppColors.textTertiary),
                    onPressed: onFavorite,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onViewProfessional({
                      'name': '${professional.firstName} ${professional.lastName}',
                      'profession': professional.professionName ?? 'Professional',
                      'id': professional.id,
                    }),
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
                    onPressed: () => onBookProfessional({
                      'name': '${professional.firstName} ${professional.lastName}',
                      'profession': professional.professionName ?? 'Professional',
                      'professionalId': professional.id,
                    }),
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
