import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../bloc/professional_bloc.dart';

class ProfessionalEditProfileScreen extends StatefulWidget {
  const ProfessionalEditProfileScreen({super.key});

  @override
  State<ProfessionalEditProfileScreen> createState() =>
      _ProfessionalEditProfileScreenState();
}

class _ProfessionalEditProfileScreenState
    extends State<ProfessionalEditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController aboutController;
  late TextEditingController experienceController;
  String selectedProfession = "";

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    aboutController = TextEditingController();
    experienceController = TextEditingController();

    // Load existing profile data from ProfessionalBloc
    final state = GetIt.I<ProfessionalBloc>().state;
    if (state is ProfileLoaded) {
      final profile = state.profile;
      final fullName = profile.user is Map<String, dynamic>
          ? '${(profile.user as Map<String, dynamic>)['first_name'] ?? ''} ${(profile.user as Map<String, dynamic>)['last_name'] ?? ''}'.trim()
          : profile.user?['full_name'] ?? '';
      nameController.text = fullName;
      aboutController.text = profile.about ?? '';
      experienceController.text = profile.experienceYears?.toString() ?? '';
      if (profile.profession is Map<String, dynamic>) {
        selectedProfession = (profile.profession as Map<String, dynamic>)['name'] as String? ?? '';
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: aboutController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "About Service",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Experience Years",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timeline),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final data = <String, dynamic>{
                    'about': aboutController.text,
                    'experience_years': int.tryParse(experienceController.text) ?? 0,
                  };
                  GetIt.I<ProfessionalBloc>().add(
                    UpdateProfileEvent(data),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile Updated Successfully"),
                    ),
                  );
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
