import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../professional/presentation/bloc/professional_bloc.dart';
import '../professional/presentation/widgets/profile_stats_card.dart';
import '../../core/widgets/loading_indicator.dart';

class ProfessionalDashboard extends StatefulWidget {
  const ProfessionalDashboard({super.key});

  @override
  State<ProfessionalDashboard> createState() => _ProfessionalDashboardState();
}

class _ProfessionalDashboardState extends State<ProfessionalDashboard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ProfessionalBloc>()..add(LoadProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Professional Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<ProfessionalBloc, ProfessionalState>(
          listener: (context, state) {
            if (state is ProfessionalFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is ProfessionalActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfessionalLoading) {
              return const LoadingIndicator();
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileStatsCard(
                      totalJobs: profile.totalJobs,
                      averageRating: profile.averageRating,
                      verificationStatus: profile.verificationStatus,
                      availability: profile.availability,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.push('/professional/pending-requests'),
                            child: const Text('Pending Requests'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.push('/professional/my-jobs'),
                            child: const Text('My Jobs'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const LoadingIndicator();
          },
        ),
      ),
    );
  }
}
