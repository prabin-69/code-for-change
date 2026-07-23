import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/search_bloc.dart';
import '../widgets/professional_card.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.I<SearchBloc>()..add(SearchRequested(query)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(query),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SearchLoaded) {
              if (state.professionals.isEmpty) {
                return const Center(
                  child: Text("No professionals found"),
                );
              }

              return ListView.builder(
                itemCount: state.professionals.length,
                itemBuilder: (context, index) {
                  return ProfessionalCard(
                    professional: state.professionals[index],
                  );
                },
              );
            }

            if (state is SearchFailure) {
              return Center(
                child: Text(state.message),
              );
            }

            return const Center(
              child: Text("Searching..."),
            );
          },
        ),
      ),
    );
  }
}