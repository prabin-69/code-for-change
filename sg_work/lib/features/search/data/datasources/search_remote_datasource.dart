import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/search_professional_model.dart';


class SearchRemoteDataSource {

  final Dio dio;


  SearchRemoteDataSource({
    required this.dio,
  });



  Future<List<SearchProfessionalModel>> searchProfessionals({

    required String search,

    String? categoryId,

    String? professionId,

  }) async {


    final response = await dio.get(

      ApiConstants.search,

      queryParameters: {

        'search': search,

        if(categoryId != null)
          'category_id': categoryId,

        if(professionId != null)
          'profession_id': professionId,

      },

    );


    final List data =
        response.data['data'] ?? [];


    return data
        .map(
          (e)=>SearchProfessionalModel.fromJson(e),
        )
        .toList();

  }

}