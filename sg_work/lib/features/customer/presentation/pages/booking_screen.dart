import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final String professionalName;
  final String profession;

  const BookingScreen({
    super.key,
    required this.professionalName,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Professional",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            Text(
              professionalName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              profession,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Describe your problem",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking Request Sent"),
                    ),
                  );
                },
                child: const Text("Send Booking Request"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}