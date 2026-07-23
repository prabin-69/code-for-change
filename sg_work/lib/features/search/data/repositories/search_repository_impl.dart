import '../../domain/entities/search_professional.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';


class SearchRepositoryImpl implements SearchRepository {

  final SearchRemoteDataSource remoteDataSource;


  SearchRepositoryImpl({
    required this.remoteDataSource,
  });



  @override
  Future<List<SearchProfessional>> searchProfessionals({

    required String search,

    String? categoryId,

    String? professionId,

  }) async {

    return await remoteDataSource.searchProfessionals(
      search: search,
      categoryId: categoryId,
      professionId: professionId,
    );

  }

}