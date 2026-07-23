class SearchProfessional {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? bio;
  final String? categoryName;
  final String? professionName;
  final double rating;
  final int totalJobs;
  final bool isFeatured;
  final String availability;

  const SearchProfessional({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.phoneNumber,
    this.bio,
    this.categoryName,
    this.professionName,
    required this.rating,
    required this.totalJobs,
    required this.isFeatured,
    required this.availability,
  });
}