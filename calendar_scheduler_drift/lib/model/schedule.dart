import 'package:drift/drift.dart';

/// Drift 로 테이블 선언
class Schedule extends Table {
  IntColumn get id => integer().autoIncrement()(); //primary key
  TextColumn get content => text()(); //내용
  DateTimeColumn get date => dateTime()(); //일정 날짜
  IntColumn get startTime => integer()(); //시작 시간
  IntColumn get endTime => integer()(); //종료 시간
}