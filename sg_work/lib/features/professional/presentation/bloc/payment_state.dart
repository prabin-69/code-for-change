abstract class PaymentState {}


class PaymentInitial extends PaymentState {}


class PaymentLoading extends PaymentState {}



class PaymentInitiated extends PaymentState {

  final String paymentUrl;


  PaymentInitiated({
    required this.paymentUrl,
  });

}



class PaymentVerified extends PaymentState {


  final bool success;


  PaymentVerified({
    required this.success,
  });


}



class PaymentError extends PaymentState {


  final String message;


  PaymentError({
    required this.message,
  });


}