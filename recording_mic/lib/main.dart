import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mic_sample/SeeAllRecording.dart';
import 'package:mic_stream/mic_stream.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Entity/FileFolder.dart';
import 'StopWatch and Timer/stopwatch.dart';
import 'StopWatch and Timer/timer_bloc.dart';
import 'bloc/recording_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => RecordingBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => TimerBloc(),
        ),
      ],
      child: MaterialApp(home: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  late StreamSubscription subscription;
  late String filename;
  late double sampleRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recording"),
          actions: [
            IconButton(
                onPressed: () {
                  ChooseDirectoryToSave(context);
                },
                icon: Icon(Icons.folder_open_rounded))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// to display timmer
                    StopWatch(),

                    /// to display mic / pause icon
                    BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state) {
                      if (state is Started) {
                        return IconButton(
                            onPressed: () async {
                              BlocProvider.of<TimerBloc>(context).add(Stop());
                              await subscription.cancel();
                              await save(File(filename).readAsBytesSync(),
                                  sampleRate.toInt(), filename);
                            },
                            icon: Icon(Icons.stop));
                      } else
                        return IconButton(
                            onPressed: () async {
                              // following code is copy and paste

                              var status = await Permission.storage.status;
                              if (!status.isGranted) {
                                await Permission.storage.request();
                              }

                              print(" permission status ${status.isGranted}");

                              final applicationDirectory =
                                  Directory(FileFolder.filefolder);

                              if (applicationDirectory != null) {
                                filename = path.join(applicationDirectory.path,
                                    "${DateTime.now().toString()}.wav");
                                print("the final path of a file is $filename");
                                File currentrecording =
                                    await File(filename).create(recursive: true)
                                      ..openWrite();

                                BlocProvider.of<TimerBloc>(context)
                                    .add(Start());

                                final myreco = await MicStream.microphone(
                                    audioSource: AudioSource.MIC,
                                    audioFormat:
                                        AudioFormat.ENCODING_PCM_16BIT);
                                // myreco?.forEach((element) {
                                //   currentrecording.writeAsBytes(element, mode: FileMode.append);
                                // });
                                subscription = myreco?.listen((event) {
                                  currentrecording.writeAsBytes(event,
                                      mode: FileMode.append);
                                }) as StreamSubscription;
                                sampleRate = await MicStream.sampleRate ?? 0.0;
                              } else {
                                ShowSnack(context, "dirctory is null");
                              }
                            },
                            icon: Icon(Icons.mic));
                    })
                  ],
                ),
              ),

              //to see what is the sampleRate,bitDepth and bufferSize

              ElevatedButton(
                  onPressed: () async {
                    final sampleRate = await MicStream.sampleRate;
                    ShowSnack(context, sampleRate.toString());
                    await Future.delayed(Duration(seconds: 4));

                    final bitDepth = await MicStream.bitDepth;
                    ShowSnack(context, bitDepth.toString());
                    await Future.delayed(Duration(seconds: 4));
                    final bufferSize = await MicStream.bufferSize;

                    ShowSnack(context, bufferSize.toString());
                    await Future.delayed(Duration(seconds: 4));
                  },
                  child: Text("press")),
              //To view the List of Recording

              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SeeAllrecording()));
                  },
                  child: Text(" see list"))
            ],
          ),
        ));
  }

  // To show Snackbr
  void ShowSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(" Sample BRate: $msg"),
      duration: Duration(seconds: 4),
    ));
  }


  // To Save Recording data into .wav format
  Future<void> save(List<int> data, int sampleRate, String filename) async {
    File recordedFile = File(filename);

    var channels = 1;

    int byteRate = ((16 * sampleRate * channels) / 8).round();

    var size = data.length;

    var fileSize = size + 36;

    Uint8List header = Uint8List.fromList([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((16 * channels) / 8).round(), 0,
      // bitsize
      16, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
      ...data
    ]);
    return recordedFile.writeAsBytesSync(header,
        flush: true, mode: FileMode.writeOnly);
  }


  // User defined directory
  void ChooseDirectoryToSave(BuildContext context) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      ShowSnack(context, "selectedDirectory is not selected");
    } else {
      FileFolder.filefolder = selectedDirectory;
      ShowSnack(context, "Recoding will be saved in the selected folder");
    }
  }
}
