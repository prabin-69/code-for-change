import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/professional_bloc.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class ProfessionalHomeScreen extends StatefulWidget {
  const ProfessionalHomeScreen({super.key});

  @override
  State<ProfessionalHomeScreen> createState() => _ProfessionalHomeScreenState();
}

class _ProfessionalHomeScreenState extends State<ProfessionalHomeScreen> {
  bool available = true;

  @override
  void initState() {
    super.initState();
    // Load profile and performance data via ProfessionalBloc
    GetIt.I<ProfessionalBloc>().add(const LoadProfileEvent());
    GetIt.I<ProfessionalBloc>().add(const LoadPerformanceEvent());
    GetIt.I<ProfessionalBloc>().add(const LoadPendingRequestsEvent(lat: 0, lng: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<ProfessionalBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                context.push('/professional/profile');
              },
              icon: const Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProfessionalBloc, ProfessionalState>(
          builder: (context, state) {
            if (state is ProfessionalLoading) {
              return _buildLoadingState();
            }

            String fullName = 'Professional';
            String professionName = 'Service Provider';
            String verificationStatus = 'pending';
            String totalJobs = '0';
            String rating = '0.0';
            String earnings = '0';

            if (state is ProfileLoaded) {
              final profile = state.profile;
              fullName = profile.user is Map<String, dynamic>
                  ? '${(profile.user as Map<String, dynamic>)['first_name'] ?? ''} ${(profile.user as Map<String, dynamic>)['last_name'] ?? ''}'.trim()
                  : profile.user?['full_name'] ?? 'Professional';
              professionName = profile.profession is Map<String, dynamic>
                  ? (profile.profession as Map<String, dynamic>)['name'] as String? ?? 'Service Provider'
                  : 'Service Provider';
              verificationStatus = profile.verificationStatus;
            }

            // Get performance data from the state stream
            String performanceRating = rating;
            String performanceEarnings = earnings;

            // Check for PerformanceLoaded in the current state
            if (state is PerformanceLoaded) {
              final perf = state.data;
              performanceRating = (perf['average_rating'] as num?)?.toStringAsFixed(1) ?? '0.0';
              performanceEarnings = (perf['total_earnings'] as num?)?.toString() ?? '0';
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              totalJobs = profile.totalJobs.toString();
              performanceRating = profile.averageRating.toStringAsFixed(1);
              performanceEarnings = profile.totalJobs.toString();
            }

            // Try to get performance data from the current state
            final perfRating = performanceRating;
            final perfEarnings = performanceEarnings;
            final jobs = totalJobs;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PROFILE HEADER
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                            child: Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  professionName,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      verificationStatus == "approved"
                                          ? "Verified"
                                          : "Pending",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AVAILABILITY
                  Card(
                    child: SwitchListTile(
                      title: const Text(
                        "Available for work",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        available
                            ? "Customers can send requests"
                            : "You are offline",
                      ),
                      value: available,
                      onChanged: (value) {
                        setState(() {
                          available = value;
                        });
                        GetIt.I<ProfessionalBloc>().add(
                          UpdateAvailabilityEvent(value ? 'available' : 'offline'),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ─── Real Stats from Backend API via ProfessionalBloc ───
                  Row(
                    children: [
                      _statCard(
                        jobs,
                        "Jobs",
                        Icons.work,
                      ),
                      _statCard(
                        perfRating,
                        "Rating",
                        Icons.star,
                      ),
                      _statCard(
                        perfEarnings,
                        "Earnings",
                        Icons.currency_rupee,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "New Requests",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Pending Requests from API (ProfessionalBloc)
                  BlocBuilder<ProfessionalBloc, ProfessionalState>(
                    builder: (context, state) {
                      if (state is PendingRequestsLoaded) {
                        final count = state.requests.length;
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              "$count New Customer${count == 1 ? '' : 's'}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "People need your service",
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                context.push('/professional/requests');
                              },
                              child: const Text("View"),
                            ),
                          ),
                        );
                      }
                      // Loading or initial state - show skeleton
                      return Card(
                        elevation: 3,
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: const Text(
                            "Loading...",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                            "Checking for new requests",
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              context.push('/professional/requests');
                            },
                            child: const Text("View"),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _actionCard(context, "Requests", Icons.notifications,
                          '/professional/requests'),
                      _actionCard(
                          context, "My Jobs", Icons.work_history, '/professional/my-jobs'),
                      _actionCard(context, "Chat", Icons.chat, '/chat'),
                      _actionCard(
                          context, "Profile", Icons.person, '/professional/profile'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "Requests"),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
          onTap: (index) {
            if (index == 1) {
              context.push('/professional/requests');
            }
            if (index == 2) {
              context.push('/professional/my-jobs');
            }
            if (index == 3) {
              context.push('/chat', extra: "Customer");
            }
            if (index == 4) {
              context.push('/professional/profile');
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile shimmer
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ShimmerLoading(width: 70, height: 70, borderRadius: 35),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(width: 150, height: 20, borderRadius: 4),
                        SizedBox(height: 8),
                        ShimmerLoading(width: 100, height: 14, borderRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ShimmerLoading(height: 60, borderRadius: 12),
          SizedBox(height: 20),
          ShimmerLoading(width: 100, height: 22, borderRadius: 4),
          SizedBox(height: 12),
          ShimmerStatRow(),
        ],
      ),
    );
  }

  Widget _statCard(String value, String title, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard(
      BuildContext context, String title, IconData icon, String route) {
    return InkWell(
      onTap: () {
        context.push(route);
      },
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
