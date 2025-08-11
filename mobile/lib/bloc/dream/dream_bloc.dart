import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/dream_repository.dart';

part 'dream_event.dart';
part 'dream_state.dart';

class DreamBloc extends Bloc<DreamEvent, DreamState> {
  final AuthRepository _authRepository;
  final DreamRepository _dreamRepository;
  DreamBloc(this._authRepository, this._dreamRepository) : super(DreamStateIdle()) {
    on<DreamEventAnalyze>((event, emit) async {
      emit(DreamStateLoading());
      try {
        final token = await _authRepository.getIdToken();
        final result = await _dreamRepository.analyzeDream(event.text, token: token);
        emit(DreamStateSuccess(result));
      } catch (e) {
        emit(DreamStateFailure(e.toString()));
      }
    });
  }
}
