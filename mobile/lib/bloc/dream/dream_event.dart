part of 'dream_bloc.dart';

abstract class DreamEvent extends Equatable {
  const DreamEvent();
  @override
  List<Object?> get props => [];
}

class DreamTextChanged extends DreamEvent {
  const DreamTextChanged(this.text);
  final String text;
  @override
  List<Object?> get props => [text];
}

class DreamSubmitted extends DreamEvent {}

class DreamListeningToggled extends DreamEvent {}
