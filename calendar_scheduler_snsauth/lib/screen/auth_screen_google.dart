import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/** 로그인 화면 - 구글 프로바이더로 소셜 로그인 */
class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset('asset/img/logo.png')
              ),
            ),
            SizedBox(height: 16.0),

            ElevatedButton(//구글로 로그인 버튼
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: SECONDARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
              ),
              child: Text('구글로 로그인'),
              onPressed: () => onGoogleLoginPress(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 구글로 로그인 버튼 함수
  onGoogleLoginPress(BuildContext ctx) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [//반환받을 값을 입력한다.
        'email'
      ]
    );

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();//로그인 진행

      print(account);
    } catch(e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('로그인 실패'))
      );
    }
  }
}