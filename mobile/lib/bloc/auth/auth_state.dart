part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateAuthenticated extends AuthState {
  final fb.User user;
  AuthStateAuthenticated(this.user);

  @override
  List<Object?> get props => [user.uid];
}

class AuthStateUnauthenticated extends AuthState {}

class AuthStateFailure extends AuthState {
  final String message;
  AuthStateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
