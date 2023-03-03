part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  const TimerState();
}

class TimerInitial extends TimerState {
  @override
  List<Object> get props => [];
}

class Started extends TimerState {
  Duration elapsedTime;
  Started({required this.elapsedTime});
  @override
  // TODO: implement props
  List<Object?> get props => [elapsedTime];
}

class Stoped extends TimerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
