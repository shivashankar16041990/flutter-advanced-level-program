import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  bool start = false;
  TimerBloc() : super(TimerInitial()) {
    on<TimerEvent>((event, emit) async {
      if (event is Start) {
        start = true;
      }
      if (event is Stop) {
        start = false;
        emit(Stoped());
      }
      int seconds = 0;
      while (start) {
        emit(Started(elapsedTime: Duration(seconds: seconds)));
        print("emitting $seconds");
        await Future.delayed(Duration(seconds: 1));
        seconds = seconds + 1;
      }
    });

    // on<Start>((event, emit) async{
    //   int seconds=0;
    //   while(true){
    //     emit(Started(elapsedTime: Duration(seconds: seconds)));
    //     print("emitting $seconds");
    //     await Future.delayed(Duration(seconds: 1));
    //     seconds=seconds+1;
    //   }
    // });
    // on<Stop>((event, emit) {
    //   emit(Stoped());
    // });
  }
}
