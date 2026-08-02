import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/professional_bloc.dart';
import '../../../customer/domain/entities/job.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class JobManagementScreen extends StatefulWidget {
  const JobManagementScreen({super.key});

  @override
  State<JobManagementScreen> createState() =>
      _JobManagementScreenState();
}

class _JobManagementScreenState
    extends State<JobManagementScreen> {
  @override
  void initState() {
    super.initState();
    GetIt.I<ProfessionalBloc>().add(const LoadMyJobsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<ProfessionalBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Jobs",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<ProfessionalBloc, ProfessionalState>(
          listener: (context, state) {
            if (state is ProfessionalFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.danger,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfessionalLoading) {
              return _buildSkeletonLoading();
            }

            if (state is MyJobsLoaded) {
              if (state.jobs.isEmpty) {
                return const EmptyState(
                  icon: Icons.work_history_rounded,
                  title: 'No Jobs Yet',
                  subtitle: 'When you accept customer requests,\nyour jobs will appear here.',
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  GetIt.I<ProfessionalBloc>().add(const LoadMyJobsEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.jobs.length,
                  itemBuilder: (context, index) {
                    final job = state.jobs[index];
                    return _buildJobCard(context, job);
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
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        GetIt.I<ProfessionalBloc>().add(const LoadMyJobsEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return _buildSkeletonLoading();
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
          child: ShimmerLoading(height: 200),
        );
      },
    );
  }

  Widget _buildJobCard(BuildContext context, Job job) {
    final status = job.status;
    final req = job.request is Map<String, dynamic> ? job.request as Map<String, dynamic> : <String, dynamic>{};
    final prof = job.professional is Map<String, dynamic> ? job.professional as Map<String, dynamic> : <String, dynamic>{};
    final customerName = req['customer'] is Map<String, dynamic>
        ? '${(req['customer'] as Map<String, dynamic>)['first_name'] ?? ''} ${(req['customer'] as Map<String, dynamic>)['last_name'] ?? ''}'.trim()
        : req['customer_name'] as String? ?? prof['first_name'] as String? ?? 'Customer';
    final serviceName = req['profession'] is Map<String, dynamic>
        ? (req['profession'] as Map<String, dynamic>)['name'] as String? ?? 'Service'
        : 'Service';
    final location = req['address'] as String? ?? '';
    final payment = req['budget'] != null ? 'Rs. ${req['budget']}' : 'N/A';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(serviceName),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (location.isNotEmpty)
              Text("📍 $location"),
            Text("💰 $payment"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _statusColor(status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _statusLabel(status),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final newStatus = _nextStatus(status);
                  if (newStatus != null) {
                    context.read<ProfessionalBloc>().add(
                      UpdateJobStatusEvent(job.id, {'status': newStatus}),
                    );
                  }
                },
                child: Text(_buttonLabel(status)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'on_the_way':
      case 'in_progress':
      case 'started':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
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
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String? _nextStatus(String current) {
    switch (current) {
      case 'pending':
      case 'accepted':
        return 'in_progress';
      case 'in_progress':
      case 'started':
        return 'completed';
      default:
        return null;
    }
  }

  String _buttonLabel(String status) {
    switch (status) {
      case 'pending':
      case 'accepted':
        return 'Start Job';
      case 'in_progress':
      case 'started':
        return 'Complete Job';
      case 'completed':
        return 'Completed';
      default:
        return 'View Details';
    }
  }
}

