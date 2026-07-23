import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_professionals.dart';

part 'search_event.dart';
part 'search_state.dart';



class SearchBloc 
    extends Bloc<SearchEvent, SearchState> {


  final SearchProfessionals searchProfessionals;



  SearchBloc({
    required this.searchProfessionals,
  }) : super(SearchInitial()) {


    on<SearchRequested>(
      _onSearch,
    );

  }



  Future<void> _onSearch(
      SearchRequested event,
      Emitter<SearchState> emit,
      ) async {


    if(event.query.trim().isEmpty){

      emit(SearchInitial());

      return;

    }


    emit(SearchLoading());


    try {


      final result =
          await searchProfessionals(
            search: event.query,
          );


      emit(
        SearchLoaded(result),
      );


    } catch(e){

      emit(
        SearchFailure(
          e.toString(),
        ),
      );

    }

  }

}