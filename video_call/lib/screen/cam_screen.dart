import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  _CamScreenState createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> { 
  RtcEngine? engine; //아고라 엔진을 저장할 변수
  int? uid; //내 id
  int? otherUid; //상대 id

  Future<bool> init() async {//권한 관련 작업 실행. 권한 작업은 비동기로 해야 함.
    final resp = await [Permission.camera, Permission.microphone].request();
    
    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted || micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }

    if (engine == null) {
      //엔진이 정의되지 않았으면 새로 정의
      engine = createAgoraRtcEngine();

      //아고라 엔진 초기화
      await engine!.initialize(
        RtcEngineContext(
          appId: APP_ID,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      
      engine!.registerEventHandler(//아고라 엔진에서 받을 수 있는 이벤트 값들 등록
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {//connection : 영상 통화 정보에 관련된 값. elapsed : joinChannel을 실행한 후 콜백이 실행되기까지 걸린 시간
            print('채널에 입장했습니다. uid : ${connection.localUid}');

            setState(() {
              this.uid = connection.localUid;
            });
          },

          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print('채널 퇴장');

            setState(() {
              uid = null;
            });
          },

          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {//elapsed : 내가 채널을 들어왔을 때부터 상대가 들어올 때까지 걸린 시간
            print('상대가 채널에 입장했습니다. uid : $remoteUid');
            
            setState(() {
              otherUid = remoteUid;
            });
          },

          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {//reason : 방에서 나가게 된 이유 (직접 나가기 또는 네크워크 끊김 등)
            print('상대가 채널에서 나갔습니다. uid : $uid');

            setState(() {
              otherUid = null;
            });
          },
        ),
      );

      //엔진으로 영상을 송출하겠다고 설정
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo(); //동영상 기능 활성화
      await engine!.startPreview(); //카메라를 이용해 영상을 화면에 실행
      await engine!.joinChannel(
        //채널 입장하기
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,

        //여러 가지 설정. 현재 프로젝트에서는 불필요
        options: ChannelMediaOptions(),
        uid: 0,
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder(//FutureBuilder는 Future를 반환하는 함수의 결과에 따라 위젯을 렌더링할 때 사용
        future: init(), 
        builder: (BuildContext context, AsyncSnapshot snapshot) {//AsyncSnapshot에서 제공하는 값이 변경될 대마다 builder() 함수 재실행
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {// === (snapshot.connectionState == ConnectionState.waiting 은 로딩 중으로, build() 함수가 두 번 이상 실행될 때, 화면이 깜박거릴 수 있어서 사용하지 않는다.)
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text('채널 나가기'),
                ),
              )
            ],
          );
        }
      )
    );
  }

  /** 내 폰이 찍는 화면 렌더링 */
  Widget renderSubView() {
    if (uid != null) {
      return AgoraVideoView(//동영상을 화면에 보여주는 위젯
        controller: VideoViewController(//해당 컨트롤러가 제공하는 영상 정보를 AgoraVideoView 위젯을 통해 보여준다.
          rtcEngine: engine!,
          canvas: const VideoCanvas(uid: 0),//내 영상을 보여줌
        ),
      );
    } else {//아직 내가 채널에 접속하지 않았다면 로딩 화면
      return CircularProgressIndicator();
    }
  }

  /** 상대 폰이 찍는 화면 렌더링 */
  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(//~.remote 생성자는 상대방의 영상을 AgoraVideoView로 그려낸다.
          rtcEngine: engine!,
          
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    } else {
      //상대가 채널에 들어오지 않았다면 대기 메시지
      return Center(
        child: const Text(
          '다른 사용자가 입장할 때까지 대기해주세요.',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}