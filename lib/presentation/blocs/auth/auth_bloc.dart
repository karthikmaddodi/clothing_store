import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(const AuthState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<AuthState> emit) {
    final email = event.email;
    final isEmailValid = Validators.isValidEmail(email);
    final isFormValid = isEmailValid && state.isPasswordValid;

    emit(state.copyWith(
      email: email,
      isEmailValid: isEmailValid,
      isFormValid: isFormValid,
      clearError: true,
      status: AuthStatus.initial,
    ));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<AuthState> emit) {
    final password = event.password;
    final isPasswordValid = Validators.isValidPassword(password);
    final isFormValid = state.isEmailValid && isPasswordValid;

    emit(state.copyWith(
      password: password,
      isPasswordValid: isPasswordValid,
      isFormValid: isFormValid,
      clearError: true,
      status: AuthStatus.initial,
    ));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final user = await loginUseCase(
        LoginParams(
          email: state.email.trim(),
          password: state.password,
        ),
      );
      emit(state.copyWith(
        status: AuthStatus.success,
        user: user,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'An unexpected authentication error occurred.',
      ));
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }
}
