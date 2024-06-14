import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/main_provider.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';

/** HomeScreen 메인 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/** HomeScreen 스테이트 */
class _HomeScreenState extends State<HomeScreen> {

  //선택된 날짜를 관리할 변수
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );

  @override
  void initState() {
    super.initState();

    final provider = context.read<MainProvider>(); // 프로바이더 변경이 있을 때마다 build() 함수 재실행
    provider.getSchedules(date: selectedDate); //이 부분이 실행되고 나면 캐시에 날짜와 일정이 업데이트된다.
  }

  /// 메인 위젯
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>(); // 프로바이더 변경이 있을 때마다 build() 함수 재실행
    final selectedDate = provider.selectedDate; // 선택된 날짜 가져오기
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(//새 일정 추가 버튼
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(//BottomSheet 열기 함수 (아래에서 위로 호하면을 덮는 위젯)
            context: context,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isDismissible: true, //배경 탭하면 BottomSheet 닫기
            isScrollControlled: true, //BottomSheet의 높이를 화면의 최대 높이로 정의하고, 스크롤 가능하게
          );
        },
      ),

      body: SafeArea(child: Column(
        children: [
          MainCalendar(
            selectedDate: selectedDate,//선택된 날짜 전달
            onDaySelected: (selectedDate, focusedDate) => onDaySelected(selectedDate, focusedDate, context), //날짜 선택 시
          ),

          SizedBox(height: 8.0),
                    
          TodayBanner(
            selectedDate: selectedDate,
            count: schedules.length,
          ),

          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (ctx, idx) {
                final schedule = schedules[idx];
                
                return Dismissible(
                  key: ObjectKey(schedule.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    provider.deleteSchedule(date: selectedDate, id: schedule.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                    child: ScheduleCard(
                      startTime: schedule.startTime,
                      endTime: schedule.endTime,
                      content: schedule.content
                    ),
                  ),
                );
              }
            )
          )
        ], 
      )),
    );
  }

  /// 달력에서 날짜 선택될 때마다 실행하는 함수
  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context
  ) {
    final provider = context.read<MainProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
  }
}