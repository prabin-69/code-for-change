import 'package:equatable/equatable.dart';


abstract class PaymentEvent extends Equatable {

  const PaymentEvent();

  @override
  List<Object?> get props => [];

}



class InitiatePaymentEvent extends PaymentEvent {


  final double amount;
  final String gateway;
  final String type;
  final String? relatedId;
  final String productName;
  final String productId;


  const InitiatePaymentEvent({

    required this.amount,
    required this.gateway,
    required this.type,
    this.relatedId,
    required this.productName,
    required this.productId,

  });



  @override
  List<Object?> get props => [

    amount,
    gateway,
    type,
    relatedId,
    productName,
    productId,

  ];

}



class VerifyPaymentEvent extends PaymentEvent {


  final String transactionId;


  const VerifyPaymentEvent({

    required this.transactionId,

  });


  @override
  List<Object?> get props => [

    transactionId,

  ];

}