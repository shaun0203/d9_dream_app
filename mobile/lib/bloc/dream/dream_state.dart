part of 'dream_bloc.dart';

abstract class DreamState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DreamStateIdle extends DreamState {}

class DreamStateLoading extends DreamState {}

class DreamStateSuccess extends DreamState {
  final Map<String, dynamic> analysis;
  DreamStateSuccess(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

class DreamStateFailure extends DreamState {
  final String message;
  DreamStateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
