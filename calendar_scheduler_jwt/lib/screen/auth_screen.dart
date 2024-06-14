import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/main_provider.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:calendar_scheduler/component/login_text_field.dart';

/** 로그인, 회원가입 위젯 */
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

/** 로그인, 회원가입 스테이트 */
class _AuthScreenState extends State<AuthScreen> {
  //폼 제어를 위한. 제어하고 싶은 폼의 키 매개변수에 이 값을 입력해준다.
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';//폼을 저장했을 때 이메일을 저장할 프로퍼티
  String password = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
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
                onSaved: (String? val) {
                  email = val!;
                },
                validator: (String? val) {
                  if (val?.isEmpty ?? true) {//이메일이 입력되지 않으면
                    return '이메일을 입력해주세요.';
                  }

                  RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');//이메일 정규표현식

                  if (!reg.hasMatch(val!)) {
                    return '이메일 형식이 올바르지 않습니다.';
                  }

                  // 입력값에 문제가 없으면 null 반환
                  return null;
                },
                hintText: '이메일',
              ),

              const SizedBox(height: 8.0),
              LoginTextField(
                onSaved: (String? val) {
                  password = val!;
                },
                validator: (String? val) {
                  if (val?.isEmpty ?? true) {
                    return '비밀번호를 입력해주세요.';
                  }

                  if (val!.length < 4 || val.length > 8) {
                    return '비밀번호는 4~8자 사이로 입력해주세요!';
                  }

                  return null;
                },
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
                onPressed: () async {
                  onRegisterPress(provider);
                },
                child: const Text('회원가입'),
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
                  onLoginPress(provider);
                },
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //form을 검증 후 저장하는 함수
  bool saveAndValidateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    formKey.currentState!.save();

    return true;
  }

  /// 회원가입 로직
  onRegisterPress(MainProvider provider) async {
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;//에러가 있으면 여기에 저장

    try {
      await provider.register(
        email: email,
        password: password
      );
    } on DioError catch(e) {
      message = e.response?.data['message'] ?? '회원가입 중 알 수 없는 오류가 발생했습니다. DioError';//에러가 있을 경우 저장, 메시지가 없다면 기본값 입력
    } catch(e) {
      message = '회원가입 중 알 수 없는 오류가 발생했습니다.';
    } finally {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HomeScreen())
        );
      }
    }
  }

  /// 로그인 로직
  onLoginPress(MainProvider provider) async {
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      await provider.login(
        email: email,
        password: password
      );
    } on DioError catch(e) {
      message = e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다. DioError catch';
    } catch(e) {
      message = '알 수 없는 오류가 발생했습니다. catch';
    } finally {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HomeScreen()
          )
        );
      }
    }
  }
}