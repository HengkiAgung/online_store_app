import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_stores_app/models/login_response_model.dart';
import 'package:online_stores_app/repositories/auth_repository.dart';
import '../common/ui_state.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheck>(_onAuthCheck);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginState: const Loading()));
    try {
      final result = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(loginState: Success(result), isAuthenticated: true));
    } catch (e) {
      emit(state.copyWith(loginState: Error(e.toString())));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(registerState: const Loading()));
    try {
      final message = await authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(registerState: Success(message), isAuthenticated: true),
      );
    } catch (e) {
      emit(state.copyWith(registerState: Error(e.toString())));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    // remove token from storage
    authRepository.removeToken();
    emit(AuthState.initial());
  }

  Future<void> _onAuthCheck(AuthCheck event, Emitter<AuthState> emit) async {
    final token = await authRepository.getToken();

    if (token != null) {
      final authCheck = await authRepository.authCheck();

      if (authCheck) {
        emit(state.copyWith(isAuthenticated: true));
      } else {
        emit(state.copyWith(isAuthenticated: false));
      }
    } else {
      emit(state.copyWith(isAuthenticated: false));
    }
  }
}
