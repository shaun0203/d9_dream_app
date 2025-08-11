part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthEventAppStarted extends AuthEvent {}

class AuthEventSignInAnonymously extends AuthEvent {}

class AuthEventSignOut extends AuthEvent {}
