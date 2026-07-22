import '../../domain/entities/certificate.dart';

class CertificateModel {
  final String id;
  final String professionalId;
  final String name;
  final String? issuingOrg;
  final String fileUrl;
  final DateTime? issuedDate;
  final bool verified;
  final DateTime createdAt;

  CertificateModel({
    required this.id,
    required this.professionalId,
    required this.name,
    this.issuingOrg,
    required this.fileUrl,
    this.issuedDate,
    required this.verified,
    required this.createdAt,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String? ?? '',
      professionalId: json['professional_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      issuingOrg: json['issuing_org'] as String?,
      fileUrl: json['file_url'] as String? ?? '',
      issuedDate: json['issued_date'] != null
          ? DateTime.parse(json['issued_date'] as String)
          : null,
      verified: json['verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'professional_id': professionalId,
        'name': name,
        'issuing_org': issuingOrg,
        'file_url': fileUrl,
        'issued_date': issuedDate?.toIso8601String(),
        'verified': verified,
        'created_at': createdAt.toIso8601String(),
      };

  Certificate toEntity() => Certificate(
        id: id,
        professionalId: professionalId,
        name: name,
        issuingOrg: issuingOrg,
        fileUrl: fileUrl,
        issuedDate: issuedDate,
        verified: verified,
        createdAt: createdAt,
      );
}
