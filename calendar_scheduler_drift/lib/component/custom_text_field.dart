import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/** 커스텀 텍스트 필드 위젯 */
class CustomTextField extends StatelessWidget {
  final String label; //텍스트필드 제목
  final bool isTime; //시간 선택하는 텍스트 필드인지 여부
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR, fontWeight: FontWeight.w600
          ),
        ),
        Expanded(
          flex: isTime ? 0 : 1,
          child:  TextFormField(//폼 안에서 텍스트필드를 쓸 때 사용. TextField 위젯과 상이,
            cursorColor: Colors.grey,
            maxLines: isTime ? 1 : null, //시간 관련 텍스트 필드가 아니면 한 줄 이상
            expands: !isTime, //시간 관련 필드는 부모 위젯만큼 공간 최대 차지
            keyboardType: isTime ? TextInputType.number : TextInputType.multiline, //시간 관련 필드는 기본 숫자 키보드 (폰 내장 키보드에만 제한할 수 있음)
            inputFormatters: isTime ? [
              FilteringTextInputFormatter.digitsOnly,
            ] : [],//시간 관련 필드는 숫자만 입력 가능
            decoration: InputDecoration(
              border: InputBorder.none, //테두리 삭제
              filled: true, //배경색 지정할래
              fillColor: Colors.grey[300], //배경색
              suffixText: isTime ? '시' : null, //시간 관련은 접미사 추가
            ),
            onSaved: onSaved,//폼 저장시 실행 함수
            validator: validator,// 폼 검증시 실행 함수
          ), 
        ),       
      ],
    );   
  }
}