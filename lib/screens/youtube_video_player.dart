import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String youtubeLink;
   const YoutubeVideoPlayer({
    Key? key,
    required this.youtubeLink,
  }) : super(key: key);

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController youtubePlayerController;
  @override
  void initState(){
    super.initState();
    final url= widget.youtubeLink ;
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!);
  }
  @override
  void deactivate(){
    youtubePlayerController.pause();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: youtubePlayerController),
      builder :(context,player)=>Scaffold(
      appBar: AppBar(
        title: const Text("Happy Learning",style: TextStyle(color: Colors.red),)
        ,),
        body: ListView(
          children: [
             player
          ],
        ),
      ),
      
    );
  }
}
