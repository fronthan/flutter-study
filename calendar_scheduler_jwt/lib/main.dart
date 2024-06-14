import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/provider/main_provider.dart';
import 'package:calendar_scheduler/repository/auth_repository.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:calendar_scheduler/screen/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//플러터 프레임워크가 준비될 때까지 대기

  await initializeDateFormatting();

  //상태 관리
  final scheduleRepository = ScheduleRepository();
  final authRepository = AuthRepository();
  final mainProvider = MainProvider(
    scheduleRepository: scheduleRepository,
    authRepository: authRepository
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => mainProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
      ),
    )
  );
}