class Certificate {
  final String id;
  final String professionalId;
  final String name;
  final String? issuingOrg;
  final String fileUrl;
  final DateTime? issuedDate;
  final bool verified;
  final DateTime createdAt;

  const Certificate({
    required this.id,
    required this.professionalId,
    required this.name,
    this.issuingOrg,
    required this.fileUrl,
    this.issuedDate,
    required this.verified,
    required this.createdAt,
  });
}