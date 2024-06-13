import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/colors.dart';

/** 스케줄카드 위젯 */
class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(8.0)
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(// 높이를 내부 외젯들의 최대 높이로 설정
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(startTime: startTime, endTime: endTime),
              SizedBox(width: 16.0),
              _Content(content: content),
              SizedBox(width: 16.0)
            ],
          ),

        ),
      ),
    );
  }
}

/** _Time 위젯 - 시작시간, 종료시간 */
class _Time extends StatelessWidget {
  final int startTime; //시작 시간
  final int endTime; //종료 시간

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600, fontSize: 16.0, color: PRIMARY_COLOR
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(fontSize: 10.0)
        ),
      ],
    );
  }
}

/** _Content 위젯 - 내용 부분 */
class _Content extends StatelessWidget {
  final String content; //내용

  const _Content({
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}