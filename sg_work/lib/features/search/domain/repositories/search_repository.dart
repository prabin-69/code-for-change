import '../entities/search_professional.dart';


abstract class SearchRepository {

  Future<List<SearchProfessional>> searchProfessionals({
    required String search,
    String? categoryId,
    String? professionId,
  });

}