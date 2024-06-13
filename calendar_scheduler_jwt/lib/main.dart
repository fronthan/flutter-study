import 'package:calendar_scheduler/firebase_options.dart';
import 'package:calendar_scheduler/screen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//플러터 프레임워크가 준비될 때까지 대기

  //firebase 설정 추가
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform //firebase_options.dart 파일에 설정된 프로젝트 설정으로 설정
  );

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      home: AuthScreen(),
    )
  );
}