import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/db/drift_database.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

/** HomeScreen 메인 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/** HomeScreen 스테이트 */
class _HomeScreenState extends State<HomeScreen> {
  /// 선택된 날짜를 관리할 변수
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );

  /// 메인 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(//새 일정 추가 버튼
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add),
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
            onDaySelected: onDaySelected, //날짜 선택 시 실행할 함수
          ),
          SizedBox(height: 8.0),
          StreamBuilder<List<ScheduleData>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            builder: (ctx, snst) {
              return TodayBanner(
                selectedDate: selectedDate,
                count: snst.data?.length ?? 0
              );
            }
          ),
          SizedBox(height: 8.0),
          Expanded(
            //일정 정보가 Stream으로 제공되므로 StreamBuilder 사용
            child: StreamBuilder<List<ScheduleData>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (ctx, snapshot) {
                ///데이터가 없을 때
                if (!snapshot.hasData) {
                  return Container();
                }

                /// 화면에 보이는 값들만 렌더링하는 목록 위젯
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, idx) {
                    final schedule = snapshot.data![idx];
                    
                    return Dismissible(
                      key: ObjectKey(schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
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
                );
              }
            ),
          )
        ], 
      )),
    );
  }

  /// 날짜 선택될 때마다 실행하는 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}