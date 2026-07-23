import '../../domain/entities/search_professional.dart';

class SearchProfessionalModel extends SearchProfessional {

  const SearchProfessionalModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.photoUrl,
    super.phoneNumber,
    super.bio,
    super.categoryName,
    super.professionName,
    required super.rating,
    required super.totalJobs,
    required super.isFeatured,
    required super.availability,
  });


  factory SearchProfessionalModel.fromJson(
      Map<String,dynamic> json){

    return SearchProfessionalModel(
      id: json['user_id'] ?? json['id'] ?? '',

      firstName:
          json['first_name'] ?? 
          json['user']?['first_name'] ??
          '',

      lastName:
          json['last_name'] ??
          json['user']?['last_name'] ??
          '',

      photoUrl:
          json['photo_url'] ??
          json['user']?['photo_url'],

      phoneNumber:
          json['phone_number'] ??
          json['user']?['phone_number'],

      bio: json['bio'],

      categoryName:
          json['category_name'] ??
          json['category']?['name'],

      professionName:
          json['profession_name'] ??
          json['profession']?['name'],

      rating:
          (json['average_rating'] ?? 0)
              .toDouble(),

      totalJobs:
          json['total_jobs'] ?? 0,

      isFeatured:
          json['is_featured'] ?? false,

      availability:
          json['availability'] ?? 'offline',
    );
  }
}