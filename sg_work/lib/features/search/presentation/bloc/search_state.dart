part of 'search_bloc.dart';


abstract class SearchState {}


class SearchInitial extends SearchState {}


class SearchLoading extends SearchState {}


class SearchLoaded extends SearchState {

  final List professionals;


  SearchLoaded(this.professionals);

}



class SearchFailure extends SearchState {

  final String message;


  SearchFailure(this.message);

}