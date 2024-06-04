import 'dart:io'; //파일 관련
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

/** 동영상 위젯 생성 */
class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  //선택한 동영상을 저장할 변수
  //XFile은 ImagePicker로 영상 또는 이미지를 선택했을 때 반환하는 타입

  final GestureTapCallback onNewVideoPressed; //새로운 영상이 선택되면 실행할 함수

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController; //동영상 조작 컨트롤러
  bool showControls = false; //영상 조작 아이콘 토글

  @override
  void initState() {
    super.initState();

    initializeController(); //컨트롤러 초기화
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    //covariant 키워드는 CustomVideoPlayer 클래스의 상속된 값을 허가해준다.
    super.didUpdateWidget(oldWidget);

    //새로 선택한 영상이 같은 영상인지 확인
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    } else {
      print('이전과 같은 파일입니다.');
    }
  }

  initializeController() async {
    //선택한 동영상으로 컨트롤러 초기화
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize(); //재생할 수 있도록 준비

    videoController.addListener(videoControllerListener); //컨트롤러 속성이 변경될 때마다 실행

    setState(() {
      this.videoController = videoController;
    });
  }

  //단순히 영상의 재생 상태가 변경될 때마다 setState 실행해서 build 재실행
  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    //State가 폐기될 때 같이 폐기할 함수
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        //위젯의 비율을 정할 수 있는 위젯
        aspectRatio: videoController!.value.aspectRatio, //너비/높이로 입력하거나 비율을 입력
        child: Stack(
          //Stack 위젯은 기본적으로 children 위젯들을 정중앙에 위치시킨다
          children: [
            VideoPlayer(videoController!),
            if (showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            
            Positioned(
              bottom: 0, right: 0,
              left: 0, //px 단위. right, left 동시에 0 으로 쓰면 좌우 끝까지 늘임
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(//영상의 현재 위치
                      videoController!.value.position, 
                    ),
                    Expanded(//Slider가 남는 공간을 모두 차지
                      child: Slider(
                        onChanged: (double val) {
                          //seekTo()는 현재 영상의 재생 위치를 변경
                          videoController!.seekTo(
                            Duration(seconds: val.toInt()),
                          );
                        },
                        value: videoController!.value.position.inSeconds.toDouble(),
                        //영상 재생 위치를 초 단위로 표현
                        min: 0,
                        max: videoController!.value.duration.inSeconds
                            .toDouble(), //max 매개변수는 double 값이어야 함.
                      )
                    ),
                    renderTimeTextFromDuration(//영상 총 길이
                      videoController!.value.duration
                    )
                  ],
                ),
              ),
            ),

            if (showControls)
              Align(
                //새 영상
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed, //카메라 아이콘을 선택하면 새로운 영상 선택 함수 실행
                  iconData: Icons.photo_camera_back
                ),
              ),
              
            if (showControls)
              //가운데에 컨트롤러 아이콘들 배치
              Align(
                alignment: Alignment.center,
                //여백 균등하게 배치
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //뒤로 가기 버튼
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    // 재생, 정지 버튼
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoController!.value.isPlaying 
                          ? Icons.pause
                          : Icons.play_arrow
                    ),
                    //앞으로 가기 버튼
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right
                    ),
                  ],
                ),
              )
          ],
        ),
      )
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    //Duration값을 보기 편한 형태로 변환
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(color: Colors.white)
    );
    //초는 분 단위값을 빼야 정확히 표현된다.
  }

  //뒤로 가기 버튼 함수
  void onReversePressed() {
    final currentPosition = videoController!.value.position; //현재 실행 중인 위치

    Duration position = Duration(); //실행 위치를 0초로 초기화

    if (currentPosition.inSeconds > 3) {
      //현재 실행 위치가 3초보다 길 때만 3초 빼기
      position = currentPosition - Duration(seconds: 3);
    } else {
      position = Duration();
    }

    videoController!.seekTo(position);
  }

  //앞으로 가기 버튼 함수
  void onForwardPressed() {
    final maxPosition = videoController!.value.duration; //영상의 최대 길이
    final currentPosition = videoController!.value.position; //현재 실행 중 위치

    Duration position = maxPosition; //영상 최대 길이로 실행 위치 초기화

    //영상 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  // 재생, 정지 버튼 함수
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
