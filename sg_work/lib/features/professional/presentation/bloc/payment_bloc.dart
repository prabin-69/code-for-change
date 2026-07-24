import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_event.dart';
import 'payment_state.dart';


class PaymentBloc 
extends Bloc<PaymentEvent, PaymentState>{


PaymentBloc()
:super(PaymentInitial()){


on<InitiatePaymentEvent>(
_onInitiatePayment
);


on<VerifyPaymentEvent>(
_onVerifyPayment
);


}




Future<void> _onInitiatePayment(
InitiatePaymentEvent event,
Emitter<PaymentState> emit,
)async{


emit(PaymentLoading());



try{


await Future.delayed(
const Duration(seconds:2)
);



emit(
PaymentInitiated(
paymentUrl:"https://payment-url.com",
)
);



}catch(e){


emit(
PaymentError(
message:e.toString(),
)
);


}


}





Future<void> _onVerifyPayment(
VerifyPaymentEvent event,
Emitter<PaymentState> emit,
)async{


emit(PaymentLoading());



try{


await Future.delayed(
const Duration(seconds:1)
);



emit(
PaymentVerified(
success:true,
)
);



}catch(e){


emit(
PaymentError(
message:e.toString(),
)
);


}


}


}