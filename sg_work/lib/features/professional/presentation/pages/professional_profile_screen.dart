import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/professional_remote_data_source.dart';
import '../../data/repositories/professional_repository.dart';
import '../controllers/professional_controller.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState
    extends State<ProfessionalProfileScreen> {

  late ProfessionalController controller;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = ProfessionalController(
      ProfessionalRepository(
        ProfessionalRemoteDataSource(
          dio: DioClient().dio,
        ),
      ),
    );

    loadProfile();
  }

  Future<void> loadProfile() async {
    try{
    await controller.loadProfile();
    print(controller.profile?.user);
    print(controller.profile?.profession);
    } catch (e){
      print("ERROR:$e");
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    

    if (controller.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Professional Profile"),
        ),
        body: Center(
          child: Text(controller.error!),
        ),
      );
    }
    final profile = controller.profile!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                loading = true;
              });

              await loadProfile();
            },
          ),

        ],

      ),

      body: RefreshIndicator(

        onRefresh: loadProfile,

        child: SingleChildScrollView(

          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 55,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                profile.user?["full_name"] ?? "Professional",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                profile.profession?["name"] ??"",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: ListTile(

                  leading: Icon(
                    profile.verificationStatus ==
                            "approved"
                        ? Icons.verified
                        : Icons.pending_actions,
                    color: profile.verificationStatus ==
                            "approved"
                        ? Colors.green
                        : Colors.orange,
                  ),

                  title: const Text(
                    "Verification Status",
                  ),

                  subtitle: Text(
                    profile.verificationStatus
                        .toUpperCase(),
                  ),

                ),

              ),

              const SizedBox(height: 20),

              Row(

                children: [

                  Expanded(
                    child: _infoCard(
                      profile.averageRating
                          .toStringAsFixed(1),
                      "Rating",
                      Icons.star,
                    ),
                  ),

                  Expanded(
                    child: _infoCard(
                      profile.totalJobs.toString(),
                      "Jobs",
                      Icons.work,
                    ),
                  ),

                  Expanded(
                    child: _infoCard(
                      (profile.experienceYears ?? 0)
                          .toString(),
                      "Years",
                      Icons.timeline,
                    ),
                  ),

                ],

              ),

              const SizedBox(height: 25),

              Card(

                child: SwitchListTile(

                  title: const Text(
                    "Available for Work",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    profile.availability ==
                            "available"
                        ? "Customers can request you"
                        : "Currently Offline",
                  ),

                  value:
                      profile.availability ==
                          "available",

                  onChanged: (value) async {

                    await controller.changeAvailability(
                      value,
                    );
                    await loadProfile();

                    setState(() {});
                  },

                ),

              ),

              const SizedBox(height: 25),
                            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    ListTile(
                      leading: const Icon(Icons.work_outline),
                      title: const Text("Profession"),
                      subtitle: Text(
                        profile.profession?["name"] ??
                            "Not Selected",
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.category_outlined),
                      title: const Text("Category"),
                      subtitle: Text(
                        profile.category?["name"] ??
                            "Not Selected",
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.workspace_premium),
                      title: const Text("Experience"),
                      subtitle: Text(
                        "${profile.experienceYears ?? 0} Years",
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text("About"),
                      subtitle: Text(
                        profile.about?.isNotEmpty == true
                            ? profile.about!
                            : "No description added.",
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.build_circle_outlined),
                      title: const Text("Skills"),
                      subtitle: Text(
                        profile.skills.isEmpty
                            ? "No skills added"
                            : profile.skills.join(", "),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 25),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    const ListTile(
                      leading: Icon(Icons.analytics_outlined),
                      title: Text("Performance"),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const Icon(Icons.star),
                      title: const Text("Average Rating"),
                      trailing: Text(
                        profile.averageRating
                            .toStringAsFixed(1),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.work_history),
                      title: const Text("Completed Jobs"),
                      trailing: Text(
                        profile.totalJobs.toString(),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.speed),
                      title: const Text("Response Time"),
                      trailing: Text(
                        profile.responseTimeAvg == null
                            ? "-"
                            : "${profile.responseTimeAvg} min",
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.cancel_outlined),
                      title: const Text("Cancellation Rate"),
                      trailing: Text(
                        "${profile.cancellationRate.toStringAsFixed(1)} %",
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(

                  icon: const Icon(Icons.edit),

                  label: const Text(
                    "Edit Profile",
                  ),

                  onPressed: () {

                    context.push(
                      "/professional/edit-profile",
                    );

                  },

                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(

                  icon: const Icon(Icons.verified_user),

                  label: const Text(
                    "Submit Verification",
                  ),

                  onPressed: () async {

                    await controller.submitVerification();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Verification submitted successfully.",
                        ),
                      ),
                    );

                    await loadProfile();

                  },

                ),
              ),

              const SizedBox(height: 30),
                            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text("Member Since"),
                      subtitle: Text(
                        profile.createdAt
                            .toLocal()
                            .toString()
                            .split(" ")
                            .first,
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text("Last Updated"),
                      subtitle: Text(
                        profile.updatedAt
                            .toLocal()
                            .toString()
                            .split(" ")
                            .first,
                      ),
                    ),

                    if (profile.isFeatured)
                      const ListTile(
                        leading: Icon(
                          Icons.workspace_premium,
                          color: Colors.amber,
                        ),
                        title: Text("Featured Professional"),
                        subtitle: Text(
                          "Your profile is currently featured.",
                        ),
                      ),

                  ],
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    String value,
    String title,
    IconData icon,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 10,
        ),
        child: Column(
          children: [

            Icon(
              icon,
              size: 28,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
  }
}