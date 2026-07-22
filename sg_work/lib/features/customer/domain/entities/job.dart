class Job {
  final String id;
  final String requestId;
  final String professionalId;
  final String customerId;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final dynamic request;
  final dynamic professional;
  final dynamic review;

  const Job({
    required this.id,
    required this.requestId,
    required this.professionalId,
    required this.customerId,
    required this.status,
    required this.startedAt,
    this.completedAt,
    required this.beforePhotos,
    required this.afterPhotos,
    this.request,
    this.professional,
    this.review,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
