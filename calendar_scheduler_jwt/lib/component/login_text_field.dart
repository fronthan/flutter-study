import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final FormFieldSetter<String?> onSaved;
  final FormFieldValidator<String?> validator;
  final String? hintText;
  final bool obscureText;

  const LoginTextField({
    required this.onSaved,
    required this.validator,
    this.obscureText = false,
    this.hintText,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      cursorColor: SECONDARY_COLOR,
      obscureText: obscureText,//텍스트 필드에 입력된 값이 true일 경우 보이지 않도록 설정 (비밀번호에서 유용)
      decoration: InputDecoration(//아무 것도 입력하지 않았을 때
        hintText: hintText,
        enabledBorder: OutlineInputBorder(//활성화된 상태의 선
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: TEXT_FIELD_FILL),
        ),
        focusedBorder: OutlineInputBorder(//포커스된 상태의 선
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: SECONDARY_COLOR),
        ),
        errorBorder: OutlineInputBorder(//에러 상태의 선
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: ERROR_COLOR),
        ),
        focusedErrorBorder: OutlineInputBorder(//포커스된 상태에서 에러가 났을 때 선
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: ERROR_COLOR),
        )
      ),
    );
  }
}