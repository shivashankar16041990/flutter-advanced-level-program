import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'timer_bloc.dart';

class StopWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
      if (state is Started) {
        return Text(state.elapsedTime.abs().toString().substring(0, 7));
      } else
        return Text("00:00");
    });
  }
}
