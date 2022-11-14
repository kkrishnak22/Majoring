import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCustom extends StatefulWidget {
  const VideoPlayerCustom({Key? key}) : super(key: key);

  @override
  State<VideoPlayerCustom> createState() => _VideoPlayerCustomState();
}

class _VideoPlayerCustomState extends State<VideoPlayerCustom> {
  late VideoPlayerController _controller;
  late Future<void> _video;

  @override
  void initState(){
    super.initState();
    _controller=VideoPlayerController.network(""
        "https://www.youtube.com/watch?v=OXQ5ee6p9ZA&t=21s"
        );
    _video=_controller.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _video,
          builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      }

      ),
    );
  }
}
