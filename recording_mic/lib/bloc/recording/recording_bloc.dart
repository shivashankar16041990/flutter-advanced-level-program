import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

import '../Entity/FileFolder.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  RecordingBloc() : super(RecordingInitial()) {
    on<getRecording>((event, emit) async {
      emit(Loading());

      final dir = Directory(FileFolder.filefolder);
      if (dir != null) {
        final files = Directory(dir.path.toString()).listSync();
        if (files.isEmpty) {
          emit(Empty());
        }
        if (files == null) {
          emit(Failure());
        }
        if (files.isNotEmpty) {
          final audioFiles = List<File>.empty(growable: true);
          files.forEach((e) {
            if (e is File &&
                (e.path.contains(".wav") || e.path.contains(".mp3"))) {
              audioFiles.add(e);
            }
          });

          emit(Success(audioFiles));
        }
      } else
        emit(Failure());
    });
  }
}
