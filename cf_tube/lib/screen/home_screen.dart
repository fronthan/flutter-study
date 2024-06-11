import 'package:cf_tube/component/custom_youtube_player.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:cf_tube/repository/youtube_repository.dart';
import 'package:flutter/material.dart';

/** 홈스크린 위젯 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/** 홈스크린 스테이트 */
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text('코팩튜브',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
      body: FutureBuilder<List<VideoModel>>(
        future: YoutubeRepository.getVideos(),//유튜브 영상 가져오기
        builder: (ctx, snapshot) {//에러가 있으면
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {//로딩 중이면
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(//새로고침 기능이 있는 위젯
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data!.map((e) => 
                CustomYoutubePlayer(videoModel: e)
              ).toList(),
            ),
          );
        },
      ),
    );   
  } 
}