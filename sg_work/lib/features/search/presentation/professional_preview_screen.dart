import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfessionalPreviewScreen extends StatelessWidget {
  final String name;
  final String profession;

  const ProfessionalPreviewScreen({
    super.key,
    required this.name,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Professional"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 45),
                ),

                const SizedBox(height: 20),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  profession,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Book Now"),
                    onPressed: () {
                      context.push(
                        '/booking',
                        extra: {
                          'name': name,
                          'profession': profession,
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
        ),
      ),
    );
  }
}