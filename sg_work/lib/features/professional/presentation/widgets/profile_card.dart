import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String profession;
  final bool verified;

  const ProfileCard({
    super.key,
    required this.name,
    required this.profession,
    this.verified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profession,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (verified)
                    const Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text("Verified"),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}