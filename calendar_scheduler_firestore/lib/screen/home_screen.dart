import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';

/** HomeScreen 메인 */
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //선택된 날짜를 관리할 변수
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
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(//BottomSheet 열기 함수 (아래에서 위로 화면을 덮는 위젯)
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
          ///달력
          MainCalendar(
            selectedDate: selectedDate,//선택된 날짜 전달
            onDaySelected: (selectedDate, focusedDate) => onDaySelected(selectedDate, focusedDate, context), //날짜 선택 시
          ),

          SizedBox(height: 10.0),
          
          /// 오늘 날짜랑 일정 갯수 배너
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('schedule')
              .where('date', isEqualTo: '${selectedDate.year}${selectedDate.month}${selectedDate.day}').snapshots(),
            builder: (ctx, snst) {
              return TodayBanner(
                selectedDate: selectedDate,
                count: snst.data?.docs.length ?? 0
              );
            }
          ),

          SizedBox(height: 8.0),

          /// 선택된 날짜의 상세 목록
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('schedule')
                .where('date', isEqualTo: '${selectedDate.year}${selectedDate.month}${selectedDate.day}').snapshots(),
              
              builder: (context, snapshot) {
                //steam을 가져오는 동안 에러가 났을 때
                if (snapshot.hasError) {
                  return Center(
                    child: Text('일정 정보를 가져오지 못했습니다.'),
                  );
                }

                // 로딩 중일 때 보여줄 화면
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                //ScheduleModel 데이터 매핑
                final schedules = snapshot.data!.docs.map(
                  (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                    json: (e.data() as Map<String, dynamic>)
                  ),
                ).toList();

                return ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (ctx, idx) {
                    final schedule = schedules[idx];
                    
                    return Dismissible(
                      key: ObjectKey(schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        //파이어스토어 특정 문서 삭제
                        FirebaseFirestore.instance.collection('schedule')
                          .doc(schedule.id)
                          .delete();
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
            )
          )
        ], 
      )),
    );
  }

  /// 달력에서 날짜 선택될 때마다 실행하는 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate, BuildContext context) {//찍어보니 selectedDate와 focusedDate는 같다.
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}