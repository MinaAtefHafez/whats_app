// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';

class AudioItem extends StatefulWidget {
  String audioUrl;

  AudioItem({required this.audioUrl});

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration? audioDuration;
  double sliderValue = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.audiotrack,
          color: Colors.deepPurple,
        ),
        const Icon(
          Icons.audiotrack_outlined,
          color: Colors.deepOrange,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'voice',
            style: TextStyle(
                color: AppColors.blueColor,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
                isPlaying = false;
              } else {
                await audioPlayer.play(UrlSource(widget.audioUrl));
                isPlaying = true;
              }

              setState(() {});
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.greyColor,
              size: 35,
            )),
      ],
    );
  }
}
