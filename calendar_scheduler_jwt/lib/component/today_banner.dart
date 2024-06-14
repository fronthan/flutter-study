import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/main_provider.dart';

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
    final provider = context.watch<MainProvider>();
    final textStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.white);//기본으로 사용할 글꼴

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일', style: textStyle
            ),
            Row(
              children: [
                Text(//일정 갯수
                  '$count개', style: textStyle
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    provider.logout();

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
          ],
        ),
      ),
    );
  }
}