part of 'dream_bloc.dart';

abstract class DreamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DreamEventAnalyze extends DreamEvent {
  final String text;
  DreamEventAnalyze(this.text);

  @override
  List<Object?> get props => [text];
}
