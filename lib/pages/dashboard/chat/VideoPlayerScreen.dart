


import 'dart:io';

import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget{

  String path;

  VideoPlayerScreen(this.path, {super.key});

  @override
  _VideoPlayerScreenState createState() {

    return _VideoPlayerScreenState();
  }

}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>{

  VideoPlayerController? _playerController;
  ChewieController? _controller;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('txt_video'.tr),),

      body: _controller != null?
      Chewie(controller: _controller!)
      : const CircularProgressIndicator(),

    );
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }


  initialization() async {
    _playerController = VideoPlayerController.file(File(widget.path));
    await _playerController?.initialize();
    _controller = ChewieController(videoPlayerController: _playerController!,
    autoPlay: true,
    looping: false);
    setState(() {

    });
  }


  @override
  void dispose() {
    _playerController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

}
