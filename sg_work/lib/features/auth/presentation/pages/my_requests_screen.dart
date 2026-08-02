import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../customer/domain/entities/service_request.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/empty_state.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  void initState() {
    super.initState();
    GetIt.I<CustomerBloc>().add(const LoadMyRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<CustomerBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'My Requests',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade400,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CustomerLoading) {
              return _buildSkeletonLoading();
            }

            if (state is MyRequestsLoaded) {
              if (state.requests.isEmpty) {
                return const EmptyState(
                  icon: Icons.list_alt_rounded,
                  title: 'No Requests Yet',
                  subtitle:
                      'When you book a service,\nyour requests will appear here.',
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  GetIt.I<CustomerBloc>().add(const LoadMyRequestsEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.requests.length,
                  itemBuilder: (context, index) {
                    final request = state.requests[index];
                    return _RequestTimelineCard(
                      request: request,
                      onTap: () => context.push(
                        '/customer/request-details',
                        extra: request.id,
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ShimmerLoading(height: 180),
        );
      },
    );
  }
}

class _RequestTimelineCard extends StatelessWidget {
  final ServiceRequest request;
  final VoidCallback onTap;

  const _RequestTimelineCard({
    required this.request,
    required this.onTap,
  });

  static const _statuses = ['pending', 'accepted', 'on_the_way', 'in_progress', 'completed'];

  int _statusIndex(String status) {
    final idx = _statuses.indexOf(status);
    return idx >= 0 ? idx : -1;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'accepted':
        return AppColors.statusAccepted;
      case 'on_the_way':
        return AppColors.statusOngoing;
      case 'in_progress':
      case 'started':
        return AppColors.statusOngoing;
      case 'completed':
        return AppColors.statusCompleted;
      case 'cancelled':
        return AppColors.danger;
      default:
        return AppColors.textTertiary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'on_the_way':
        return Icons.directions_car;
      case 'in_progress':
      case 'started':
        return Icons.construction;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'on_the_way':
        return 'On The Way';
      case 'in_progress':
      case 'started':
        return 'Work Started';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx = _statusIndex(request.status);
    final isCancelled = request.status == 'cancelled';
    final statusColor = _statusColor(request.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCancelled
                        ? [AppColors.danger.withValues(alpha: 0.1), Colors.transparent]
                        : [statusColor.withValues(alpha: 0.1), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _statusIcon(request.status),
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _statusLabel(request.status),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(request.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (request.budget != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Rs. ${request.budget!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Timeline
              if (!isCancelled) ...[
                SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      _buildTimelineDot(idx >= 0, statusColor),
                      _buildTimelineConnector(idx >= 1, statusColor),
                      _buildTimelineDot(idx >= 1, statusColor),
                      _buildTimelineConnector(idx >= 2, statusColor),
                      _buildTimelineDot(idx >= 2, statusColor),
                      _buildTimelineConnector(idx >= 3, statusColor),
                      _buildTimelineDot(idx >= 3, statusColor),
                      _buildTimelineConnector(idx >= 4, statusColor),
                      _buildTimelineDot(idx >= 4, statusColor),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    _TimelineLabel(text: 'Pending', flex: 1),
                    _TimelineLabel(text: 'Accepted', flex: 1),
                    _TimelineLabel(text: 'En Route', flex: 1),
                    _TimelineLabel(text: 'Started', flex: 1),
                    _TimelineLabel(text: 'Done', flex: 1),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Description
              Text(
                request.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              if (request.address.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request.address,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              if (request.preferredDate != null ||
                  request.preferredTime != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (request.preferredDate != null) ...[
                      const Icon(Icons.calendar_today,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(request.preferredDate!),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    if (request.preferredTime != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        request.preferredTime!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // View Details Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineDot(bool active, Color color) {
    return Container(
      width: active ? 16 : 12,
      height: active ? 16 : 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? color : AppColors.outline,
        border: active
            ? Border.all(color: color.withValues(alpha: 0.3), width: 3)
            : null,
      ),
    );
  }

  Widget _buildTimelineConnector(bool active, Color color) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: active ? color : AppColors.outline,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final dt = date is DateTime ? date : DateTime.parse(date.toString());
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return date.toString();
    }
  }
}

class _TimelineLabel extends StatelessWidget {
  final String text;
  final int flex;

  const _TimelineLabel({
    required this.text,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
