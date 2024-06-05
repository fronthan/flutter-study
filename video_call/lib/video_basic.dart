/// 카메라 실행할 수 있는 기본 로직
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();//Flutter 앱이 실행될 준비가 됐는지 확인. 메인 함수의 첫 실행값이 runApp이 아니면 작성해줘야 함.

  _cameras = await availableCameras(); //핸드폰에 있는 카메라들 가져오기
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;//카메라를 제어할 수 있는 컨트롤러 선언

  @override
  void initState() {
    super.initState();

    initializeCamera();
  }

  initializeCamera() async {
    try {
      controller = CameraController(_cameras[0], ResolutionPreset.max);//첫 번째 카메라로 카메라 설정, 카메라 해상도 최대로 설정

      await controller.initialize(); //카메라 초기화

      setState(() { });
    } catch(e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied' :
            print('카메라 권한 거절'); break;
          default:
            print('기타 에러'); break;
        }
      }
    }
  }

  @override 
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {//카메라 초기화 상태 확인
      return Container();
    }

    return MaterialApp(
      home: CameraPreview(controller),//카메라 보여줌
    );
  }
}