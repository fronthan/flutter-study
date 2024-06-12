import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:calendar_scheduler/db/drift_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//플러터 프레임워크가 준비될 때까지 대기

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  final db = LocalDatabase(); //db 생성
  
  GetIt.I.registerSingleton<LocalDatabase>(db);//GetIt에 데이터베이스 변수 주입

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}