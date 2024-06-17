import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

/** 로그인 화면 - 파이어베이스로 소셜 로그인 */
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
        'email',
        'uid'
      ]
    );

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();//로그인 진행

      final GoogleSignInAuthentication? googleAuth = await account?.authentication;//AccessToken과 idToken을 가져올 수 있는 객체 불러오기

      final credential = GoogleAuthProvider.credential(//AuthCredential 객체를 상속받는 객체 생성
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken
      );

      await FirebaseAuth.instance.signInWithCredential(credential);//파이어베이스 인증 시작

      Navigator.of(ctx).push(
        MaterialPageRoute(
          builder: (_) => HomeScreen()
        )
      );
    } on PlatformException catch(e) {
      if (e.code == 'sign_in_failed') {
        print(e.toString());
      } else {
        throw e;
      }
    } catch(e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('로그인 실패'))
      );
    }
  }
}