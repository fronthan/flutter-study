import 'package:flutter/material.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/component/login_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset('asset/img/logo.png',
                width: MediaQuery.of(context).size.width * 0.5,//화면 너비의 절반만큼
              ),
            ),

            const SizedBox(height: 16.0),
            LoginTextField(
              onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '이메일',
            ),

            const SizedBox(height: 8.0),
            LoginTextField(
              onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '비밀번호',
              obscureText: true,//비밀번호 특수문자로 가리기
            ),

            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: SECONDARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                )
              ),
              onPressed: () {

              },
              child: Text('회원가입'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: SECONDARY_COLOR,
                shape: RoundedRectangleBorder(//사각형으로
                  borderRadius: BorderRadius.circular(5.0)
                )
              ),
              onPressed: () async {

              },
              child: Text('로그인'),
            ),
            
          ],
        ),
      ),
    );
  }
}