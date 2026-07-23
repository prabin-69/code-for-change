import '../entities/search_professional.dart';
import '../repositories/search_repository.dart';


class SearchProfessionals {

  final SearchRepository repository;


  SearchProfessionals(this.repository);



  Future<List<SearchProfessional>> call({

    required String search,

    String? categoryId,

    String? professionId,

  }) {

    return repository.searchProfessionals(
      search: search,
      categoryId: categoryId,
      professionId: professionId,
    );

  }

}