import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:uuid/uuid.dart';



/** 하단 일정 생성 위젯 */
class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; //상위 위젯에서 선택된 날짜 입력 받기

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key
  }) : super(key: key);

  @override 
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();    
}

/** 하단 일정 생성 스테이트 */
class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();// form key 생성

  int? startTime; //시작 시간 저장 변수
  int? endTime; //종료 시간 저장 변수
  String? content; //일정 내용 저장 변수

  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom; //키보드 높이 가져오기

    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + keyboardSize,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, keyboardSize),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: '시작 시간', isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(label: '종료 시간', isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(label: '내용', isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  )
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('저장'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR
                    ),
                    onPressed: () => onSavePressed(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///시간값 검증
  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요.';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요.';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요.';
    }

    return null;
  }

  ///내용값 검증
  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요.';
    }

    return null;
  }

  /// 저장 버튼
  void onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {//폼 검증하기. 모든 validator의 함수가 null을 반환하면 true. 어느 하나라도 String을 반환하면 false

      formKey.currentState!.save(); //폼 저장. 모든 onSaved의 함수 실행

      final schedule = ScheduleModel(
        id: Uuid().v4(),
        content: content!,
        date: widget.selectedDate,
        startTime: startTime!,
        endTime: endTime!,
      );

      final user = FirebaseAuth.instance.currentUser;//로그인한 사용자의 정보 가져오기

      if (user == null) {//로그인한 사용자의 정보를 못 가져오면
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('다시 로그인을 해주세요.'))
        );
        Navigator.of(context).pop(); //일정 생성 후 화면 뒤로

        return;
      }

      await FirebaseFirestore.instance.collection('schedule')
        .doc(schedule.id).set(
          {
            ...schedule.toJson(),
            'author': user.email
          }
      );

      Navigator.of(context).pop();
    }
  }
}