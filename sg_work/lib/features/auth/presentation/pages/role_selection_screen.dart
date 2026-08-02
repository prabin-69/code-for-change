import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_button.dart';

/// Shown exactly once, right after a brand-new user completes OTP
/// verification (or if an admin resets an existing user's role).
/// The user's choice is persisted to the backend via [SelectRoleEvent]
/// and is never asked for again once selected.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRole;
  bool _isSubmitting = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _submit() {
    final role = _selectedRole;
    if (role == null || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    context.read<AuthBloc>().add(SelectRoleEvent(role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              final role = state.user.role.toUpperCase();
              if (role == "CUSTOMER") {
                context.go(RouteConstants.home);
              } else if (role == "PROFESSIONAL") {
                context.go('/professional/setup');
              }
            } else if (state is AuthFailure) {
              setState(() => _isSubmitting = false);
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // ─── Gradient Header ───
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── SewaGhar Icon ───
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.home_repair_service,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ─── Title ───
                      const Text(
                        'How would you like\nto use SewaGhar?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ─── Subtitle ───
                      Text(
                        'Choose your role to get started.\nYou can update this later in settings.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Body ───
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // ─── Role: Customer ───
                        _RoleCard(
                          icon: Icons.person_search_rounded,
                          title: 'I need a service',
                          subtitle: 'Book trusted professionals for home & repair services',
                          features: const [
                            'Book professionals near you',
                            'Manage service requests',
                            'Track jobs in real-time',
                            'Chat & review professionals',
                          ],
                          value: 'CUSTOMER',
                          isSelected: _selectedRole == 'CUSTOMER',
                          onTap: () => setState(() => _selectedRole = 'CUSTOMER'),
                        ),

                        const SizedBox(height: 14),

                        // ─── Role: Professional ───
                        _RoleCard(
                          icon: Icons.handyman_rounded,
                          title: 'I provide a service',
                          subtitle: 'Get hired for jobs and grow your business',
                          features: const [
                            'Receive job requests instantly',
                            'Manage your work schedule',
                            'Track earnings & performance',
                            'Build your professional profile',
                          ],
                          value: 'PROFESSIONAL',
                          isSelected: _selectedRole == 'PROFESSIONAL',
                          onTap: () => setState(() => _selectedRole = 'PROFESSIONAL'),
                        ),

                        const SizedBox(height: 28),

                        // ─── Continue Button ───
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading || _isSubmitting;
                            return GradientButton(
                              label: 'Continue',
                              icon: Icons.arrow_forward_ios,
                              isLoading: isLoading,
                              onPressed: (_selectedRole == null || isLoading)
                                  ? null
                                  : _submit,
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        // ─── Hint ───
                        const Center(
                          child: Text(
                            'You can switch your role anytime from settings',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Role Card Widget ───

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> features;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Row ───
            Row(
              children: [
                // ─── Icon Container ───
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
color: isSelected
                        ? AppColors.primary
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                // ─── Title & Subtitle ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // ─── Check Circle ───
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                      width: 2,
                    ),
                  ),
child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            // ─── Feature List ───
            if (isSelected) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.outline),
              const SizedBox(height: 12),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          feature,
                          style: const TextStyle(
fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
