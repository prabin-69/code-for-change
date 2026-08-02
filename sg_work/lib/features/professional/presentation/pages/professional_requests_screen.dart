import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/empty_state.dart';
import '../bloc/professional_bloc.dart';
import 'package:geolocator/geolocator.dart';

class ProfessionalRequestsScreen extends StatefulWidget {
  const ProfessionalRequestsScreen({super.key});

  @override
  State<ProfessionalRequestsScreen> createState() =>
      _ProfessionalRequestsScreenState();
}

class _ProfessionalRequestsScreenState
    extends State<ProfessionalRequestsScreen> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      if (mounted) {
        context.read<ProfessionalBloc>().add(
          LoadPendingRequestsEvent(
            lat: position.latitude,
            lng: position.longitude,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        context.read<ProfessionalBloc>().add(
          const LoadPendingRequestsEvent(lat: 0, lng: 0),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfessionalBloc, ProfessionalState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              "Service Requests",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _loadRequests,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfessionalState state) {
    if (state is ProfessionalLoading) {
      return _buildSkeletonLoading();
    }

    if (state is PendingRequestsLoaded) {
      final requests = state.requests;
      if (requests.isEmpty) {
        return const EmptyState(
          icon: Icons.inbox_rounded,
          title: 'No Pending Requests',
          subtitle: 'When customers request your services,\nthey will appear here.',
        );
      }
      return RefreshIndicator(
        onRefresh: _loadRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return _buildRequestCard(context, request);
          },
        ),
      );
    }

    if (state is ProfessionalFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.danger),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadRequests,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildSkeletonLoading();
  }

  Widget _buildSkeletonLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ShimmerLoading(height: 200),
        );
      },
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> request) {
    final customer = request['customer'] as Map<String, dynamic>? ?? {};
    final category = request['category'] as Map<String, dynamic>? ?? {};
    final profession = request['profession'] as Map<String, dynamic>? ?? {};
    final customerName = [
      customer['first_name'] as String? ?? '',
      customer['last_name'] as String? ?? '',
    ].where((s) => s.isNotEmpty).join(' ');
    final customerPhoto = customer['photo_url'] as String?;
    final serviceName = profession['name'] as String? ?? category['name'] as String? ?? 'Service';
    final budget = request['budget'] != null
        ? 'Rs. ${request['budget']}'
        : 'Not specified';
    final address = request['address'] as String? ?? 'No address provided';
    final description = request['description'] as String? ?? '';
    final createdAt = request['created_at'] as String? ?? '';
    final requestId = request['id'] as String? ?? '';
    final preferredDate = request['preferred_date'] as String?;
    final preferredTime = request['preferred_time'] as String?;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          context.push('/booking-details', extra: request);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryContainer,
                    backgroundImage: customerPhoto != null
                        ? NetworkImage(customerPhoto)
                        : null,
                    child: customerPhoto == null
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.statusPending.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Pending',
                            style: TextStyle(
                              color: AppColors.statusPending,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    budget,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.build_outlined, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    serviceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (preferredDate != null || preferredTime != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (preferredDate != null) ...[
                      const Icon(Icons.calendar_today, size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(preferredDate),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                    if (preferredTime != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        preferredTime,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              if (createdAt.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeAgo(createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<ProfessionalBloc>().add(
                            AcceptRequestEvent(requestId),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        label: const Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<ProfessionalBloc>().add(
                            const LoadPendingRequestsEvent(lat: 0, lng: 0),
                          );
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 20),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.danger),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatTimeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else {
        return '${diff.inDays}d ago';
      }
    } catch (_) {
      return '';
    }
  }
}
