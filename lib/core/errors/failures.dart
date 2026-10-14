import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache operation failed.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Invalid email or password.']);
}

class PaymentFailure extends Failure {
  const PaymentFailure([super.message = 'Payment processing failed. Please retry.']);
}
