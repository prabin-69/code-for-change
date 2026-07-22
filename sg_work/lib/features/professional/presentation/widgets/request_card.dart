import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;

  const RequestCard({super.key, required this.request, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final distanceM = request['distance'] as num? ?? 0;
    final distanceKm = (distanceM / 1000).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request['description'] as String? ?? 'No description',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '$distanceKm km away',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Category: ${(request['category'] as Map<String, dynamic>?)?['name'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Profession: ${(request['profession'] as Map<String, dynamic>?)?['name'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Accept Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
