class Payment {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String gateway;
  final String? transactionId;
  final String status;
  final String type;
  final String? relatedId;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.gateway,
    this.transactionId,
    required this.status,
    required this.type,
    this.relatedId,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  Payment copyWith({
    String? id,
    String? userId,
    double? amount,
    String? currency,
    String? gateway,
    String? transactionId,
    String? status,
    String? type,
    String? relatedId,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      gateway: gateway ?? this.gateway,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}