import 'package:flutter/material.dart';
import '../../domain/entities/profession.dart';

class ProfessionCard extends StatelessWidget {
  final Profession profession;
  final VoidCallback onTap;

  const ProfessionCard({super.key, required this.profession, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.handyman,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          profession.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
