import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/payment/process_dummy_payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessDummyPaymentUseCase processDummyPaymentUseCase;

  PaymentBloc({required this.processDummyPaymentUseCase})
      : super(const PaymentInitial()) {
    on<InitiatePayment>(_onInitiatePayment);
    on<ResetPayment>(_onResetPayment);
  }

  Future<void> _onInitiatePayment(
    InitiatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());
    try {
      final result = await processDummyPaymentUseCase(
        ProcessDummyPaymentParams(
          amount: event.amount,
          items: event.items,
        ),
      );
      emit(PaymentSuccess(result));
    } catch (e) {
      emit(PaymentFailureState(
        e.toString().replaceAll('Exception:', '').trim(),
      ));
    }
  }

  void _onResetPayment(ResetPayment event, Emitter<PaymentState> emit) {
    emit(const PaymentInitial());
  }
}
