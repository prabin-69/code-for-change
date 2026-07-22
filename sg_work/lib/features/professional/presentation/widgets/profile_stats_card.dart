import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  final int totalJobs;
  final double averageRating;
  final String verificationStatus;
  final String availability;

  const ProfileStatsCard({
    super.key,
    required this.totalJobs,
    required this.averageRating,
    required this.verificationStatus,
    required this.availability,
  });

  Color _availabilityColor(String availability) {
    switch (availability) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat('Total Jobs', totalJobs.toString()),
                _buildStat('Rating', averageRating.toStringAsFixed(1)),
                _buildStat('Verification', verificationStatus),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Availability:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _availabilityColor(availability).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    availability.toUpperCase(),
                    style: TextStyle(
                      color: _availabilityColor(availability),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
