# flutter Study
## 도서 <코드팩토리의 플러터 프로그래밍 2판>
프론트엔드 개발자 한의 개인 공부 - 플러터편
<br/>

### video_call (영상 통화)
- setState( )
#### agora_rtc_engine 패키지
- RtcEngine
  - createAgoraRtcEngine( )
  - initialize( )
  - registerEventHandler( )
  - setClientRole( )
  - enableVideo( )
  - startPreview( )
  - joinChannel( )
- RtcEngineContext 위젯
- RtcEngineEventHandler 위젯
  - onJoinChannelSuccess( )
  - onLeaveChannel( )
  - onUserJoined( )
  - onUserOffline( )
- AgoraVideoView 위젯
  - VideoViewController 위젯 (.remote 생성자)
    - VideoCanvas 위젯
    - RtcConnection 위젯
#### permission_handler 패키지 (권한)
- Permission request( )
- PermissionStatus
#### camera 패키지
#### 위젯
- MaterialApp
  - Navigator
  - MaterialPageRoute
- AppBar
- FutureBuilder
- Padding
- Column (end, stretch)
- ElevatedButton

<br/>

### vid_player (비디오 재생기)
#### 라이프 사이클
- initState
- didUpdateWidget
- dispose
#### image_picker 패키지
- pickVideo
#### video_player 패키지
- VideoPlayer 위젯
- CustomVideoPlayer
  - XFile
- VideoPlayerController
  - addListener
  - removeListener
  - seekTo( )
#### 클래스, 함수 관련
- Duration 클래스
- async await
#### 위젯 
- File 위젯
- BoxDecoration 위젯
  - LinearGradient 위젯
- GestureDetector 위젯
  - GestureTapCallback 함수
- Text 위젯
  - copyWith 함수
- 아이콘을 컴포넌트화 
  - IconData
- GestureDetector 위젯
- AspectRatio 위젯
- Stack 위젯, Align 위젯
- Positioned 위젯
- Slider 위젯
    
<br/>

### random_dice (무작위 주사위)
- 테마 : SliderThemeData, BottomNavigationBarThemeData
  - BottomNavigationBar 위젯
  - BottomNavigationBarItem 위젯
- 탭 : TickerProviderStateMixin 클래스, TabBarView 위젯
- shake 패키지(폰 흔들기) : ShakeDetector
- Random 함수
- dispose()
- Padding 위젯
- Slider 위젯

<br/>

### u_and_i (디데이)
- 폰트
- 테마
- StatefulWidget State 
- showCupertinoDialog 함수
- Align 위젯
- CupertinoDatePicker 위젯
- GestureTapCallback

<br/>

### image_carousel (전자 액자)
- 이미지 스와이프 기능
- StatefulWidget
- PageView 위젯
- pageController
- Timer
- SystemChrome
- Image 위젯
- 2024.05.30

<br/>

### flutter_webview
- 2024.05.28

<br/>

### splash_screen
- Scaffold
- Container, BoxDecoration
- Row, Column
- CircularProgressIndicator 로딩바
- 2024.05.28