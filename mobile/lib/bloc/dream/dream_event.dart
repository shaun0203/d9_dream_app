import 'package:equatable/equatable.dart';

abstract class DreamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DreamTextChanged extends DreamEvent {
  final String text;
  DreamTextChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class StartListening extends DreamEvent {}
class StopListening extends DreamEvent {}

class SubmitDream extends DreamEvent {}
