import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/constants/route_constants.dart';

/// Shown exactly once, right after a brand-new user completes OTP
/// verification (or if an admin resets an existing user's role).
/// The user's choice is persisted to the backend via [SelectRoleEvent]
/// and is never asked for again once selected.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  void _submit() {
    final role = _selectedRole;
    if (role == null) return;
    context.read<AuthBloc>().add(SelectRoleEvent(role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(RouteConstants.home);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'How will you use\nServiceMarket?',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose one to continue. You won\'t be asked again.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                _RoleCard(
                  title: 'I need a service',
                  subtitle:
                      'Book trusted professionals for home & repair services',
                  icon: Icons.person_search,
                  value: 'CUSTOMER',
                  groupValue: _selectedRole,
                  onSelected: (value) => setState(() => _selectedRole = value),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  title: 'I provide a service',
                  subtitle:
                      'Get hired for jobs and grow your business as a professional',
                  icon: Icons.handyman,
                  value: 'PROFESSIONAL',
                  groupValue: _selectedRole,
                  onSelected: (value) => setState(() => _selectedRole = value),
                ),
                const Spacer(),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (_selectedRole == null || isLoading)
                            ? null
                            : _submit,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Continue'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String? groupValue;
  final ValueChanged<String> onSelected;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFCCCCCC),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? primaryColor.withValues(alpha: 0.06) : Colors.white,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: isSelected
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.1),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onSelected(v!),
              activeColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
