import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:calendar_scheduler/model/schedule.dart';

part 'drift_database.g.dart'; //part 파일 지정, 코드 생성 시 파일 생성됨. part 파일은 해당 파일의 값들을 현재 파일에서 사용할 수 있다. (private값까지)

///사용할 테이블 등록
@DriftDatabase(
  tables: [
    Schedule,
  ],
)

/** LocalDatabase */
class LocalDatabase extends _$LocalDatabase {//code generation으로 생성할 클래스 상속
  LocalDatabase() : super(_openConnection());

  ///데이터를 조회하고, 변화 감지 (watch)
  Stream<List<ScheduleData>> watchSchedules(DateTime date) => (select(schedule)..where((tbl) => tbl.date.equals(date))).watch(); 
  //Drift로 필터링할 때는 다트 언어 비교 연산자를 사용하지 않고, 객체에서 제공하는 함수로 비교해야 한다.

  ///입력
  Future<int> createSchedule(ScheduleCompanion data) => into(schedule).insert(data);

  Future<int> removeSchedule(int id) => (delete(schedule)..where((tbl) => tbl.id.equals(id))).go();

  @override
  int get schemaVersion => 1; //필수값. 테이블 변화가 있을 때마다 1씩 올려줘서 테이블 구조가 변경된다는 걸 드리프트에 알려줌. 기본 1부터 시작    
}

/** 레이지 데이터베이스 객체 */
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite')); //db 파일 저장할 폴더
    return NativeDatabase(file);
  });
}


/// 파일 작성 후 터미널에서 dart run build_runner build 실행하면 지정한 part 파일이 생성된다.