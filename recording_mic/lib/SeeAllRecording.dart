import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/recording_bloc.dart';

class SeeAllrecording extends StatelessWidget {

  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    context.read<RecordingBloc>().add(getRecording());
    return Scaffold(
      body: Center(
        child: BlocBuilder<RecordingBloc, RecordingState>(
          builder: (context, state) {
            if (state is Success) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.files.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.files[index].path.toString()),
                      onTap: () async {
                        // Create a player
                        final duration = await player.setFilePath(state
                            .files[index]
                            .path); // Schemes: (https: | file: | asset: )
                        ShowPlayDialog(context);
                        player.stop();
                      },
                    );
                  });
            }

            if (state is Failure) {
              return Text("failure");
            }
            if (state is Loading) {
              return CircularProgressIndicator();
            }
            if (state is Empty) {
              return Text("folder is empty");
            }
            if (state is RecordingInitial) {
              return CircularProgressIndicator();
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> ShowPlayDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 250,
              width: 250,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          player.play();
                        },
                        icon: Icon(Icons.play_arrow)),
                    IconButton(
                        onPressed: () {
                          player.pause();
                        },
                        icon: Icon(Icons.pause)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
