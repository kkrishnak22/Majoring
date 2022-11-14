import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseVideoScreen extends StatefulWidget {
  final String courseVideoLink;
  final String title="";
   CourseVideoScreen({
    Key? key,
    required this.courseVideoLink,

  }) : super(key: key);

  @override
  State<CourseVideoScreen> createState() => _CourseVideoScreenState();
}

class _CourseVideoScreenState extends State<CourseVideoScreen> {
   late VideoPlayerController _controller;
   late YoutubePlayerController _controllerYoutube;
   late Future<void> _video;
   void runYoutubePlayer(){
   
  }
  @override
  void initState(){
    super.initState();
    _controller=VideoPlayerController.network(
      widget.courseVideoLink
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_controller.value.isPlaying){
            setState(() {
              _controller.pause();
            });
          }else{
            setState(() {
              _controller.play();
            });
          }
        },
        child:  Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow),
      ),
    );
  }
}
