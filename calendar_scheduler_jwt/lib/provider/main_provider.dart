import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:calendar_scheduler/repository/auth_repository.dart';

class MainProvider extends ChangeNotifier {
  final ScheduleRepository scheduleRepository; // API 요청 로직을 담은 클래스
  final AuthRepository authRepository;

  String? accessToken;
  String? refreshToken;

  DateTime selectedDate = DateTime.utc(// 선택한 날짜
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {}; // ➌ 일정 정보를 저장해둘 변수

  MainProvider({
    required this.scheduleRepository,
    required this.authRepository,
  }) : super();

  /// 토큰을 새로 발급했을 때 토큰값 업데이트 함수
  updateTokens({
    String? refreshToken,
    String? accessToken
  }) {
    if (refreshToken != null) {//refreshToken이 입력됐을 경우 업뎃
      this.refreshToken = refreshToken;
    }

    if (accessToken != null) {//accessToken이 입력됐을 경우 업뎃
      this.accessToken = accessToken;
    }

    notifyListeners();
  }

  /// 회원가입 함수
  Future<void> register({
    required String email,
    required String password
  }) async {
    final resp = await authRepository.register(email: email, password: password);

    updateTokens(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken
    );
  }

  ///로그인 함수
  Future<void> login({
    required String email,
    required String password
  }) async {
    final resp = await authRepository.login(
      email: email,
      password: password
    );

    updateTokens(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken
    );
  }

  /// 로그아웃 함수
  logout() {
    refreshToken = null;
    accessToken = null;
    cache = {};

    notifyListeners();
  }

  /// 토큰 재발급 함수
  rotateToken({
    required String refAccessToken,
    required bool isRefreshToken
  }) async {
    if (isRefreshToken) {// 리프레시 토큰
      final token = await authRepository.rotateToken(token: refAccessToken, type: 'refresh');

      this.refreshToken = token;
    } else {// 액세스 토큰
      final token = await authRepository.rotateToken(token: refAccessToken, type: 'access');

      accessToken = token;
    }

    notifyListeners();    
  }

  /// 일정 가져오기
  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await scheduleRepository.getSchedules(
      date: date,
      accessToken: accessToken!,
    ); // GET 메서드 보내기

    cache.update(date, (value) => resp, ifAbsent: () => resp); // 선택한 날짜의 일정들 업데이트하기

    notifyListeners(); // Listening 하는 위젯들 업데이트하기
  }

  /// 일정 생성
  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;
    final uuid = Uuid();

    final tempId = uuid.v4(); // 유일무이한 ID값을 생성합니다.
    final newSchedule = schedule.copyWith(
      id: tempId,
    );

    cache.update(
      targetDate,
      (value) => [
        ...value,
        newSchedule,
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [newSchedule],
    );

    notifyListeners(); // 캐시업데이트 반영하기

    try {
      final savedSchedule = await scheduleRepository.createSchedule(
        schedule: schedule,
        accessToken: accessToken!
      ); // API 요청을 합니다.

      cache.update(// 서버 응답 기반으로 캐시 업데이트
        targetDate,
        (value) => value.map(
          (e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e
        ).toList(),
      );
    } catch (e) {
      cache.update(// 삭제 실패시 캐시 롤백하기
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }
  }

  /// 일정 삭제
  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final targetSchedule = cache[date]!.firstWhere(
      (e) => e.id == id,
    ); // 삭제할 일정 기억

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    ); // 긍정적 응답 (응답 전에 캐시 먼저 업데이트)

    notifyListeners(); // 캐시업데이트 반영하기

    try {
      await scheduleRepository.deleteSchedule(
        id: id,
        accessToken: accessToken!
      ); // 삭제 함수 실행
    } catch (e) {
      cache.update(
        // 삭제 실패시 캐시 롤백하기
        date,
        (value) => [...value, targetSchedule]..sort(
            (a, b) => a.startTime.compareTo(
              b.startTime,
            ),
          ),
      );
    }

    notifyListeners();
  }

  /// 선택한 날짜 변경
  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date; // 현재 선택된 날짜를 매개변수로 입력받은 날짜로 변경
    notifyListeners();
  }
}
