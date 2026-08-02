import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/search_professional.dart';
import '../bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalPreviewScreen extends StatelessWidget {
  final String name;
  final String profession;
  final String? professionalId;
  final String? categoryId;
  final String? professionId;

  const ProfessionalPreviewScreen({
    super.key,
    required this.name,
    required this.profession,
    this.professionalId,
    this.categoryId,
    this.professionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            SearchProfessional? found;
            if (state is SearchLoaded) {
              try {
                found = state.professionals.firstWhere(
                  (p) {
                    final sp = p as SearchProfessional;
                    if (professionalId != null) return sp.id == professionalId;
                    return '${sp.firstName} ${sp.lastName}' == name;
                  },
                ) as SearchProfessional?;
              } catch (_) {}
            }

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: found?.photoUrl != null
                          ? NetworkImage(found!.photoUrl!)
                          : null,
                      child: found?.photoUrl == null
                          ? const Icon(Icons.person, size: 45)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profession,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (found != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            found.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.work_history_outlined, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${found.totalJobs} jobs',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      if (found.bio != null && found.bio!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          found.bio!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_month),
                        label: const Text("Book Now"),
                        onPressed: () {
                          context.push(
                            '/booking',
                            extra: {
                              'name': name,
                              'profession': profession,
                              'professionalId': found?.id ?? professionalId,
                              'categoryId': found?.categoryId ?? categoryId ?? '',
                              'professionId': found?.professionId ?? professionId ?? '',
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.chat),
                        label: const Text("Chat"),
                        onPressed: () {
                          context.push(
                            '/chat',
                            extra: name,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

