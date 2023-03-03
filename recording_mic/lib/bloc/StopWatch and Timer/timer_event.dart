part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();
}

class Start extends TimerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Stop extends TimerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
