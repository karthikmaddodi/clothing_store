import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final AuthStatus status;
  final String? errorMessage;
  final UserEntity? user;

  const AuthState({
    this.email = '',
    this.password = '',
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isFormValid = false,
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isFormValid,
    AuthStatus? status,
    String? errorMessage,
    UserEntity? user,
    bool clearError = false,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isFormValid: isFormValid ?? this.isFormValid,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        status,
        errorMessage,
        user,
      ];
}
