// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/constants/colors.dart';

class DisplayVideoItem extends StatefulWidget {
  String videoUrl;
  DisplayVideoItem(this.videoUrl);

  @override
  State<DisplayVideoItem> createState() => _DisplayVideoItemState();
}

class _DisplayVideoItemState extends State<DisplayVideoItem> {
  late CachedVideoPlayerController controller;
  bool isPlaying = false ;
  
  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        controller.setVolume(1);
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(alignment: Alignment.center, children: [
        CachedVideoPlayer(controller),
        IconButton(
            onPressed: () {
              if ( isPlaying ) {
                 setState(() {
                     controller.pause() ;
                     isPlaying = false ;
                 });
              } else {
                setState(() {
                   controller.play(); 
                   isPlaying = true ;
                });
              }
            },
            icon: Icon(
             isPlaying ? Icons.pause_circle : Icons.play_circle ,
              color: AppColors.greyWhiteColor,
              size: 30 ,
            )),
      ]),
    );
  }
}
