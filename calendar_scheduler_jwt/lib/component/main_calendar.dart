import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';

/** 메인 달력 */
class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; //날짜 선택 함수
  final DateTime selectedDate; //선택된 날짜

  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      firstDay: DateTime(2024, 1, 1),//첫째날
      lastDay: DateTime(2030, 12, 31),//마지막 날
      focusedDay: DateTime.now(), //화면에 보여지는 날

      onDaySelected: onDaySelected,//날짜가 탭될 때마다 실행
      selectedDayPredicate: (date) =>//선택된 날짜를 구분할 로직, true가 반환되면 선택된 날짜 표시
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day,

      ///달력 최상단 스타일
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false, //달력 크기 선택 옵션 없애기
        titleTextStyle: TextStyle(//제목 글꼴
          fontWeight: FontWeight.w700, fontSize: 16.0
        ),
      ),

      ///바디 스타일
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,

        defaultDecoration: BoxDecoration(// 날짜 기본 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY
        ),
        defaultTextStyle: TextStyle(// 기본 글꼴
          fontWeight: FontWeight.w600, color: DARK_GREY
        ),

        weekendDecoration: BoxDecoration(// 주말 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY
        ),
        weekendTextStyle: TextStyle(// 주말 글꼴
          fontWeight: FontWeight.w600, color: DARK_GREY
        ),

        selectedDecoration: BoxDecoration(// 선택된 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            width: 1.0,
            color: PRIMARY_COLOR,
          )
        ),
        selectedTextStyle: TextStyle(// 선택된 날짜 글꼴
          fontWeight: FontWeight.w600, color: PRIMARY_COLOR
        ),

      ),
    );
  }
}