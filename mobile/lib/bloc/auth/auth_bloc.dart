import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthStateInitial()) {
    on<AuthEventAppStarted>((event, emit) async {
      emit(AuthStateLoading());
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthStateAuthenticated(user));
      } else {
        emit(AuthStateUnauthenticated());
      }
      await emit.forEach<fb.User?>(_authRepository.authStateChanges, onData: (user) {
        if (user != null) {
          return AuthStateAuthenticated(user);
        }
        return AuthStateUnauthenticated();
      });
    });

    on<AuthEventSignInAnonymously>((event, emit) async {
      emit(AuthStateLoading());
      try {
        final user = await _authRepository.signInAnonymously();
        emit(AuthStateAuthenticated(user));
      } catch (e) {
        emit(AuthStateFailure(e.toString()));
      }
    });

    on<AuthEventSignOut>((event, emit) async {
      await _authRepository.signOut();
      emit(AuthStateUnauthenticated());
    });
  }
}
