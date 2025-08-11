part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthSignInAnonRequested extends AuthEvent {}

class AuthSignInEmailRequested extends AuthEvent {
  const AuthSignInEmailRequested(this.email, this.password);
  final String email;
  final String password;
}

class AuthSignOutRequested extends AuthEvent {}
