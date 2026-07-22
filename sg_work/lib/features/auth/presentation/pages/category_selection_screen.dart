import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../customer/presentation/widgets/profession_card.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String categoryId;

  const CategorySelectionScreen({super.key, required this.categoryId});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<CustomerBloc>()
        ..add(LoadProfessionsEvent(widget.categoryId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Select Profession')),
        body: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfessionsLoaded) {
              if (state.professions.isEmpty) {
                return const Center(
                    child: Text('No professions available in this category'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.professions.length,
                itemBuilder: (context, index) {
                  final profession = state.professions[index];
                  return ProfessionCard(
                    profession: profession,
                    onTap: () {
                      context.push(
                        '/customer/request-description',
                        extra: {
                          'categoryId': widget.categoryId,
                          'professionId': profession.id,
                        },
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
