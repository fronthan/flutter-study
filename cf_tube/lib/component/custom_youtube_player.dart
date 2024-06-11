import 'package:cf_tube/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/** 유튜브 영상 재생기 위젯 */
class CustomYoutubePlayer extends StatefulWidget {
  final VideoModel videoModel;

  const CustomYoutubePlayer({
    required this.videoModel,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomYoutubePlayerState();
}

/** 스테이트 */
class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  YoutubePlayerController? controller;

  ///스테이트 생성
  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.videoModel.id, //처음 실행할 영상 id
      flags: YoutubePlayerFlags(
        autoPlay: false,// - 버튼을 눌러야만 재생. // true - 위젯이 화면에 보이자마자 재생
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YoutubePlayer(//유튜브 재생기 위젯
          controller: controller!,//필수 매개변수
          showVideoProgressIndicator: true,
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(//영상 제목
            widget.videoModel.title,
            style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w700
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  ///스테이트 폐기
  @override
  void dispose() {
    super.dispose();
    controller!.dispose();//컨트롤러도 폐기
  }
}