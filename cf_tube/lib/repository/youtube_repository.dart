import 'package:cf_tube/const/api.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:dio/dio.dart';

class YoutubeRepository {
  static Future<List<VideoModel>> getVideos() async {
    final resp = await Dio().get(
      YOUTUBE_API_BASE_URL,
      queryParameters: {
        'channelId': CHANNEL_ID,
        'maxResults': 50,
        'key': API_KEY,
        'part': 'snippet',
        'order': 'date',
      },
    );
    
    final listWithData = resp.data['items'].where(
      (item) => item?['id']['videoId'] != null && item?['snippet']?['title'] != null,
    );//videoID와 title이 null이 아닌 값들만 가져오기

    return listWithData.map<VideoModel>(
      (item) => VideoModel(id: item['id']['videoId'], title: item['snippet']['title']),
    ).toList(); //필터링된 값들로 VideoModel 생성
  }
}