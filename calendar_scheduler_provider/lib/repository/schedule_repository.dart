import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:calendar_scheduler/model/schedule.dart';

/** API 요청 로직을 위한 클래스. 컨트롤러 */
class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  /// 일정 가져오기 함수
  Future<List<ScheduleModel>> getSchedules({
    required DateTime date
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date': '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}', //YYYYMMDD 형식으로 변환
      },
    );

    /// 모델 인스턴스로 데이터 매핑
    return resp.data.map<ScheduleModel>(
      (x) => ScheduleModel.fromJson(json: x)
    ).toList();
  }

  /// 일정 생성 함수
  Future<String> createSchedule({
    required ScheduleModel schedule
  }) async {
    final json = schedule.toJson();//http 요청의 body에는 json Map 형태로 입력해야 한다.
    final resp = await _dio.post(_targetUrl, data: json);

    return resp.data?['id'];
  }

  /// 일정 삭제 함수
  Future<String> deleteSchedule({
    required String id
  }) async {
    final resp = await _dio.delete(_targetUrl, data: {
      'id': id
    });

    return resp.data?['id'];
  }
}