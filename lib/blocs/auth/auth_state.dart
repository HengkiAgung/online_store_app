part of 'auth_bloc.dart';

class AuthState {
  final UiState<LoginResponseModel> loginState;
  final UiState<String> token;
  final UiState<String> registerState;
  final bool isAuthenticated;

  const AuthState({
    required this.loginState,
    required this.token,
    required this.registerState,
    required this.isAuthenticated,
  });

  factory AuthState.initial() => AuthState(
    loginState: const NotLogged(),
    token: const NotLogged(),
    registerState: const NotLogged(),
    isAuthenticated: false,
  );

  AuthState copyWith({
    UiState<LoginResponseModel>? loginState,
    UiState<String>? token,
    UiState<String>? registerState,
    bool? isAuthenticated,
  }) {
    return AuthState(
      loginState: loginState ?? this.loginState,
      token: token ?? this.token,
      registerState: registerState ?? this.registerState,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
