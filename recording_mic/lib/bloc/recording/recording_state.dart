part of 'recording_bloc.dart';

abstract class RecordingState extends Equatable {
  const RecordingState();
}

class RecordingInitial extends RecordingState {
  @override
  List<Object> get props => [];
}

class Success extends RecordingState {
  List<FileSystemEntity> files;
  Success(this.files);

  @override
  List<Object> get props => [files];
}

class Loading extends RecordingState {
  @override
  List<Object> get props => [];
}

class Failure extends RecordingState {
  @override
  List<Object> get props => [];
}

class Empty extends RecordingState {
  @override
  List<Object> get props => [];
}
