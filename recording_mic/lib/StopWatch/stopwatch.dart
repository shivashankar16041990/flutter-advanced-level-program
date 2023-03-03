import 'package:flutter/material.dart';

final stopwatch = Stopwatch();

class StopWatch extends StatelessWidget {
  bool start;
  StopWatch({required this.start});

  @override
  Widget build(BuildContext context) {
    if (start) {
      final start = StartWatch();
      StartWatch();
      return StreamBuilder<Duration>(
          stream: start,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Text(data.toString().substring(0, 7));
            }

            return Text("00:00");
          });
    } else {
      return Text("00:00");
    }
  }

  Stream<Duration> StartWatch() async* {
    stopwatch.start();
    while (stopwatch.isRunning) {
      final seconds = (stopwatch.elapsedTicks / 10000000).toInt();
      yield Duration(seconds: seconds).abs();

      await Future.delayed(Duration(seconds: 1));
    }
  }
}
