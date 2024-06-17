import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calendar_scheduler/const/colors.dart';

/** 오늘의 일정 배너 */
class TodayBanner extends StatelessWidget {
  final DateTime selectedDate; //선택 날짜
  final int count; //일정 갯수

  TodayBanner({
    required this.selectedDate,
    required this.count,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.white);//기본으로 사용할 글꼴

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일', style: textStyle
              ),
            ),
            
            Text(//일정 갯수
              '$count개', style: textStyle
            ),
            const SizedBox(width: 8.0),

            GestureDetector(
              onTap: () async {
                await GoogleSignIn().signOut();//구글 로그아웃 (이것을 같이 해줘야 다른 계정으로 로그인 시도를 할 수 있다.)
                await FirebaseAuth.instance.signOut(); //파이어베이스 인증 로그아웃

                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 16.0
              ),
            )
          ]
        ),
      ),
    );
  }
}