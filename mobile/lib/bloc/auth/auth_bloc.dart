import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:d9_dream_app/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(AuthLoading()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInAnonRequested>(_onAnon);
    on<AuthSignInEmailRequested>(_onEmail);
    on<AuthSignOutRequested>(_onSignOut);
    on<_AuthUserChanged>(_onAuthUserChanged);
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _sub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    _sub?.cancel();
    _sub = _authRepository.onAuthStateChanged.listen((user) {
      add(_AuthUserChanged(user));
    });
  }

  Future<void> _onAnon(AuthSignInAnonRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInAnonymously();
    } catch (e) {
      emit(AuthFailure(e.toString()));
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(Unauthenticated());
    }
  }

  Future<void> _onEmail(AuthSignInEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithEmail(event.email, event.password);
    } catch (e) {
      emit(AuthFailure(e.toString()));
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);
  final User? user;

  @override
  List<Object?> get props => [user?.uid];
}

extension on AuthBloc {
  void _onAuthUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    if (user == null) {
      emit(Unauthenticated());
    } else {
      emit(Authenticated(user));
    }
  }
}
