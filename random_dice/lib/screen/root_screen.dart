import 'dart:math';
import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  // TickerProviderStateMixin 사용하기
  TabController? controller; //TabController 선언
  double threshold = 2.7; //민감도 기본값
  int rice_num = 1; //주사위 숫자
  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this); //컨트롤러 초기화

    controller!.addListener(tabListener); //컨트롤러 속성이 변경될 때마다 실행할 함수

    shakeDetector = ShakeDetector.autoStart(//흔들기 감지 즉시 시작
      onPhoneShake: onPhoneShake,
      shakeSlopTimeMS: 100, //감지 주기
      shakeThresholdGravity: threshold //감지 민감도
    );
  }

  tabListener() {
    setState(() {});
  }

  void onPhoneShake() {
    final rand = new Random();

    setState(() {
      rice_num = rand.nextInt(5) + 1;//생성될 최대 정수
    });
  }

  @override
  dispose() {
    controller!.removeListener(tabListener); //리스터 함수 등록 취소
    shakeDetector!.stopListening(); //흔들기 감지 중지
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller, //컨트롤러 등록
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: rice_num),
      SettingsScreen(threshold: threshold, onThresholdChange: onThresholdChange),
    ];
  }

  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.edgesensor_high_outlined), label: '주사위'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
      ],
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
    );
  }
}
