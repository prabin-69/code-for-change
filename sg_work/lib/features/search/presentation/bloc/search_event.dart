part of 'search_bloc.dart';


abstract class SearchEvent {}


class SearchRequested extends SearchEvent {

  final String query;


  SearchRequested(this.query);

}