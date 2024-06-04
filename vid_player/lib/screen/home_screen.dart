
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

/* HomeScreen 위젯 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/* _HomeScreenState 스테이트 */
class _HomeScreenState extends State<HomeScreen> {
  XFile? video; //동영상 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      //동영상 선택 전/후 다른 위젯을 보여준다.
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  //동영상 선택 전 보여줄 위젯
  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width, //너비를 최대로 늘이기
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ),
          SizedBox(height: 30.0),
          _AppName(),
        ],
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [
          Color(0xff2a3a7c),
          Color(0xff000118),
        ],
      ),
    );
  }

  //이미지 선택하는 기능을 구현한 함수
  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  //동영상 선택 후 보여줄 위젯
  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,//선택된 동영상 입력
        onNewVideoPressed: onNewVideoPressed,
      ),//동영상 재생기 위젯
    );
  }
}

/* _Logo 위젯
* 로고를 보여줄 위젯 */
class _Logo extends StatelessWidget {
  final GestureTapCallback onTap; //탭했을 때 실행할 함수

  const _Logo({
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset( 'asset/img/logo.png', ),
      onTap: onTap,
    );
  }
}

/* _AppName 위젯
* 앱 제목을 보여줄 위젯 */
class _AppName extends StatelessWidget {
  const _AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300
    );

    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('VIDEO', style: textStyle),
        Text('PLAYER', style: textStyle.copyWith(fontWeight: FontWeight.w700))
        //copyWith()는 현재 속성들을 유지한 채로 특정 속성만 변경하는 함수이다.
      ],
    );
  }
}