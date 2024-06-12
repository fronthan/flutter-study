import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//플러터 프레임워크가 준비될 때까지 대기

  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => scheduleProvider,
      child:  MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}