import 'package:flutter/material.dart';

class AvailabilityCard extends StatelessWidget {
  final bool available;
  final ValueChanged<bool> onChanged;

  const AvailabilityCard({
    super.key,
    required this.available,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: const Text(
          "Available for work",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          available
              ? "Customers can send requests"
              : "You are offline",
        ),
        value: available,
        onChanged: onChanged,
      ),
    );
  }
}