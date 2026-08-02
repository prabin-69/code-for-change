import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../customer/domain/entities/profession.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/empty_state.dart';

/// Icon mapping for professions
IconData _professionIcon(String name) {
  switch (name.toLowerCase()) {
    case 'plumber':
    case 'plumbing':
      return Icons.plumbing;
    case 'electrician':
    case 'electrical':
      return Icons.electrical_services;
    case 'carpenter':
    case 'carpentry':
      return Icons.carpenter;
    case 'painter':
    case 'painting':
      return Icons.format_paint;
    case 'cleaner':
    case 'cleaning':
      return Icons.cleaning_services;
    case 'ac repair':
    case 'ac technician':
      return Icons.ac_unit;
    case 'tutor':
    case 'tutoring':
      return Icons.school;
    case 'photographer':
    case 'photography':
      return Icons.camera_alt;
    case 'mover':
    case 'moving':
      return Icons.local_shipping;
    case 'gardener':
    case 'gardening':
      return Icons.yard;
    case 'pest control':
      return Icons.bug_report;
    case 'salon':
    case 'beauty':
    case 'barber':
      return Icons.face;
    case 'mechanic':
    case 'auto repair':
      return Icons.build;
    case 'chef':
    case 'cooking':
      return Icons.restaurant;
    case 'designer':
    case 'interior design':
      return Icons.design_services;
    case 'trainer':
    case 'fitness':
      return Icons.fitness_center;
    case 'doctor':
    case 'nurse':
    case 'healthcare':
      return Icons.medical_services;
    default:
      return Icons.handyman;
  }
}

class CategorySelectionScreen extends StatefulWidget {
  final String categoryId;

  const CategorySelectionScreen({super.key, required this.categoryId});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Profession> _filteredProfessions = [];
  List<Profession> _allProfessions = [];

  void _filterProfessions(String query) {
    if (query.trim().isEmpty) {
      setState(() => _filteredProfessions = List.from(_allProfessions));
      return;
    }
    setState(() {
      _filteredProfessions = _allProfessions
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<CustomerBloc>()
        ..add(LoadProfessionsEvent(widget.categoryId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Select Profession',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        body: BlocConsumer<CustomerBloc, CustomerState>(
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
            } else if (state is ProfessionsLoaded) {
              _allProfessions = state.professions;
              if (_filteredProfessions.isEmpty && _searchController.text.isEmpty) {
                _filteredProfessions = List.from(_allProfessions);
              }
              if (state.professions.isEmpty) {
                return _buildEmptyState();
              }
              return _buildBody();
            }
            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerProfessionalCard(),
          SizedBox(height: 12),
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
        icon: Icons.work_outline,
        title: 'No professions available',
        subtitle: 'This category has no professions listed yet.',
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // ─── Search Bar ───
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.shadowMd,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProfessions,
              decoration: InputDecoration(
                hintText: 'Search professions...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.textTertiary),
                        onPressed: () {
                          _searchController.clear();
                          _filterProfessions('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),

        // ─── Count Label ───
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Text(
                '${_filteredProfessions.length} professions available',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),

        // ─── List ───
        Expanded(
          child: _filteredProfessions.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No results found',
                    subtitle: 'Try a different search term.',
                    actionLabel: 'Clear search',
                    onAction: () {
                      _searchController.clear();
                      _filterProfessions('');
                    },
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredProfessions.length,
                  itemBuilder: (context, index) {
                    final profession = _filteredProfessions[index];
                    return _ProfessionTile(
                      profession: profession,
                      onTap: () {
                        context.push(
                          '/customer/request-description',
                          extra: {
                            'categoryId': widget.categoryId,
                            'professionId': profession.id,
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─── Profession Tile ───

class _ProfessionTile extends StatelessWidget {
  final Profession profession;
  final VoidCallback onTap;

  const _ProfessionTile({
    required this.profession,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _professionIcon(profession.name);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                // ─── Icon ───
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                // ─── Info ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profession.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Available',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.infoContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              profession.isActive ? 'Active' : 'Inactive',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ─── Arrow ───
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.primary,
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
