import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../customer/domain/entities/service_request.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;

  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<CustomerBloc>()
        ..add(LoadRequestDetailsEvent(requestId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Request Details')),
        body: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is RequestCancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request cancelled')),
              );
              Navigator.pop(context);
            } else if (state is CustomerFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RequestDetailsLoaded) {
              return _buildDetails(context, state.request);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, ServiceRequest request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            title: 'Status',
            value: request.status.toUpperCase(),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Description',
            value: request.description,
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Address',
            value: request.address,
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Created At',
            value: DateFormat('MMM d, y – h:mm a').format(request.createdAt),
          ),
          if (request.status == 'pending') ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  context
                      .read<CustomerBloc>()
                      .add(CancelRequestEvent(request.id));
                },
                child: const Text('Cancel Request'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
