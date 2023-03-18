


// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whats_app/core/constants/colors.dart';

class DisplayVideoStatusItem extends StatefulWidget {
  
  File videoFile ;
  DisplayVideoStatusItem ({required this.videoFile});

  @override
  State<DisplayVideoStatusItem> createState() => _DisplayVideoStatusItemState();
}

class _DisplayVideoStatusItemState extends State<DisplayVideoStatusItem> {
 
   late VideoPlayerController videoPlayerController ;
   
   @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.videoFile)..initialize().then((value) {
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
        setState(() {});
    });
  }


  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.bottomCenter,
      children : [ 
        VideoPlayer(
        videoPlayerController
            ),
      Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            if ( videoPlayerController.value.isPlaying ) {
              videoPlayerController.pause() ;
            } else {
              videoPlayerController.play() ;
            }
        
            setState(() {});
          } ,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.greyColor ,
              shape: BoxShape.circle
            ),
            child: Icon(
             videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow ,
               color: AppColors.textColor
                ),
          ),
        ),
      ),
        VideoProgressIndicator( videoPlayerController , allowScrubbing: true,)
      ]
    );
  }
}