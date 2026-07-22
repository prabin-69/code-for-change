import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/payment.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final double amount;
  final String currency;
  final String gateway;
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  final String status; // 'PENDING', 'SUCCESS', 'FAILED'
  final String type; // 'SUBSCRIPTION', 'VERIFICATION_FEE', 'FEATURED'
  @JsonKey(name: 'related_id')
  final String? relatedId;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  PaymentModel({
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  Payment toEntity() {
    return Payment(
      id: id,
      userId: userId,
      amount: amount,
      currency: currency,
      gateway: gateway,
      transactionId: transactionId,
      status: status,
      type: type,
      relatedId: relatedId,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}