import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:calendar_scheduler/screen/auth_screen.dart';
import 'package:calendar_scheduler/firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:calendar_scheduler/screen/auth_screen_google.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();//광고 기능 초기화

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      home: AuthScreen()
      // home: AuthScreenGoogle()
    )
  );
}