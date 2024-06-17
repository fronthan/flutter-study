import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/screen/auth_screen.dart';
// import 'package:calendar_scheduler/screen/auth_screen_google.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//플러터 프레임워크가 준비될 때까지 대기

  await initializeDateFormatting();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
      // home: AuthScreenGoogle()
    )
  );
}