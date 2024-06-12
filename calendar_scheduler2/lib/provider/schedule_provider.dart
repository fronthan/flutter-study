import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository; //API 요청 로직을 담은 클래스

  /// 선택한 날짜
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );

  Map<DateTime, List<ScheduleModel>> cache = {}; //일정 정보를 저장해둘 변수

  ScheduleProvider({
    required this.repository
  }) : super() {
    getSchedules(date: selectedDate);
  }

  /// 일정 가져오기 함수
  void getSchedules({
    required DateTime date
  }) async {
    final resp = await repository.getSchedules(date: date); //get 메서드 보내기

    cache.update(date, (value) => resp, ifAbsent: () => resp);//선택한 날짜 일정 업데이트
    //isAbsent는 date에 해당되는 key값이 존재하지 않을 때 실행하는 함수

    notifyListeners(); //리슨하는 위젯들 업데이트
  }

  /// 일정 생성하기 함수
  void createSchedule({
    required ScheduleModel schedule
  }) async {
    final targetDate = schedule.date;

    final uuid = Uuid();

    final tempId = uuid.v4(); //유일한 ID값 생성
    final newSchedule = schedule.copyWith(
      id: tempId
    );

    /// 긍정적 응답 구간
    cache.update(
      targetDate,
      (val) => [
        ...val, newSchedule //현재 캐시 목록 끝에 새로운 일정 추가
      ]..sort((a, b) => a.startTime.compareTo(b.startTime)),//일정 시작 시간 기준으로 정렬
      ifAbsent: () => [newSchedule]// 날짜에 해당되는 값이 없다면 새로운 목록에 새로운 일정 하나 추가
    );

    notifyListeners();//캐시 업뎃

    try {
      final savedSchedule = await repository.createSchedule(schedule: schedule);

      //서버 응답 기반으로 캐시 업뎃
      cache.update(
        targetDate,
        (val) => val.map(
          (e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e
        ).toList()
      );
    } catch(e) {
      cache.update(//추가 실패 시 캐시 되돌리기
        targetDate,
        (val) => val.where((e) => e.id != tempId).toList()
      );
    }

    notifyListeners();
  }

  /// 일정 삭제하기 함수
  void deleteSchedule({
    required DateTime date,
    required String id
  }) async {
    final targetSchedule = cache[date]!.firstWhere(
      (e) => e.id == id
    );//삭제할 일정 기억

    cache.update(//캐시에서 데이터 삭제 긍정적 응답
      date,
      (val) => val.where((e) => e.id != id).toList(),
      ifAbsent: () => []
    );

    notifyListeners();

    try {//서버로 삭제 함수 실행
      await repository.deleteSchedule(id: id);
    } catch(e) {//삭제 실패 시 되돌리기
      cache.update(
        date, 
        (val) => [...val, targetSchedule]..sort(
          (a, b) => a.startTime.compareTo(b.startTime)
        )
      );
    }

    notifyListeners();
  }

  /// 선택한 날짜 변경 함수
  void changeSelectedDate({
    required DateTime date
  }) {
    selectedDate = date;
    notifyListeners();
  }
}