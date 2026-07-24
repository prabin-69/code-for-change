import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/search_professional.dart';

class ProfessionalCard extends StatelessWidget {
  final SearchProfessional professional;

  const ProfessionalCard({
    super.key,
    required this.professional,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          context.push(
            '/professional-preview',
            extra: {
              'name':
                  '${professional.firstName} ${professional.lastName}',
              'profession':
                  professional.professionName ?? 'Professional',
            },
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: professional.photoUrl != null
                ? NetworkImage(professional.photoUrl!)
                : null,
            child: professional.photoUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(
            '${professional.firstName} ${professional.lastName}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                professional.professionName ?? 'Professional',
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orange,
                  ),
                  Text(' ${professional.rating}'),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}