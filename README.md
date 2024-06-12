# flutter Study
## 도서 <코드팩토리의 플러터 프로그래밍 2판>
프론트엔드 개발자 한의 개인 공부 - 플러터편
<p> 2024.05.28 ~ </p>
<br/>

### calendar_scheduler 2 (일정 관리 - nest.js & Provider)
- 모델
- cache with 긍정적 응답
#### dio (http)
- Dio
  - get( ), post( ), delete( )
#### provider (글로벌 상태 관리)
- ChangeNotifierProvider
#### uuid
- uuid.v4( )

<br/>

### calendar_scheduler 1 (일정 관리 - 로컬 DB)
- ListView 위젯
- TextFormField 위젯
  - cursorColor, expands, keyboardType, inputFormatters
  - InputDecoration 위젯
    - suffixText, filled, fillColor
- FloatingActionButton 위젯
  - showModalBottomSheet( )
  - isScrollControlled
- MediaQuery 키보드 크기 가져오기
- Dismissible 위젯 (밀어서 삭제하기)
- Form
  - FormState
  - FormFieldSetter, FormFieldValidator
  - validate( ), save( )
#### table_calendar (달력)
- TableCalendar
- CalendarStyle
#### intl (다국어)
- initializeDateFormatting( )
#### drift (SQLite DB 쿼리 code generation)
- Table : 테이블 선언
- LocalDatabase( )
- part
- Stream
- LazyDatabase
- NativeDatabase
#### dart:io
- File
#### sqlite3_flutter_libs (SQLite DB, 파일 기반 로컬 데이터베이스)
#### path_provider (경로)
- getApplicationDocumentsDirectory( )
#### path (경로)
#### get_it (프로젝트 전역 의존성 주입)
- registerSingleton( )
#### drift_dev (Drift 코드 생성 기능)
#### build_runner (code generation 을 실행)
- dart run build_runner build

<br/>

### cf_tube (유튜브 재생기)
- RefreshIndicator 위젯
- BouncingScrollPhysics 위젯
- Future 위젯, FutureBuilder 인터페이스
#### youtube_player_flutter (유튜브 API)
- YoutubePlayer
- YoutubePlayerController
- YoutubePlayerFlags
#### dio (http 요청)
- get( )

<br />

### image_editor (이미지 편집기)
- Model 선언, 사용
#### image_picker
- pickImage( )
#### image_gallery_saver
- saveImage( )
#### uuid
- v4( )
#### dart
- io
- ui
  - VoidCallback
  - ImageByteFormat
- typed_data
#### 위젯
- Transform
  - Matrix4
- GestureDetector
  - onTap( )
  - onScaleUpdate( )
  - onScaleEnd( )
- SingleChildScrollView
- List
- RepaintBoundary
  - findRenderObject( )
  - toImage( )
  - toByteData( )
- InteractiveViewer
- ScaffoldMessenger
  - SnackBar

<br />

### chool_check (위치 기반 출석 체크)
- AlertDialog 위젯
- Navigator
- AppBar 위젯
#### google_maps_flutter
- 설정
  - App.Delegate.swift 수정
  - ios/Podfile ios 버전 수정
- FutureBuilder
  - snapshot
- GoogleMap
  - CameraPosition
  - LatLng
  - Marker
  - Circle
#### geolocator (위치 서비스 플러그인)
- Geolocator
  - getCurrentPosition( )
  - distanceBetween( )
  - isLocationServiceEnabled( )
  - checkPermission( )
    - LocationPermission : denied / deniedForever
  - requestPermission( )

<br />

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
- video_basic.dart 파일
  - CameraDescription
  - availableCameras( )
  - CameraController
  - CameraPreview 위젯
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

<br/>

### flutter_webview

<br/>

### splash_screen
- Scaffold
- Container, BoxDecoration
- Row, Column
- CircularProgressIndicator 로딩바