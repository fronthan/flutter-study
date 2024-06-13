import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';

class AuthRepository {
  final _dio = Dio(); //dio 인스턴스 생성

  final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/auth';

  ///회원가입 로직
  Future<({String refreshToken, String accessToken})> register({
    required String email,
    required String password
  }) async {
    //회원가입 URL에 이메일과 비밀번호를 post 로 보낸다.
    final result = await _dio.post(
      '$_targetUrl/register/email',
      data: {
        'email': email,
        'password': password
      }
    );

    //record 타입으로 토큰 반환
    return (refreshToken: result.data['refreshToken'] as String, accessToken:result.data['accessToken'] as String);
  }

  /// 로그인 로직
  Future<({String refreshToken, String accessToken})> login({
    required String email,
    required String password
  }) async {
    final emailAndPassword = '$email:$password';//이메일, 비밀번호를 문자열 타입으로 구성

    Codec<String, String> stringToBase64 = utf8.fuse(base64);// utf8 인코딩으로부터 base64로 변환할 수 있는 코덱 생성

    final encoded = stringToBase64.encode(emailAndPassword);//base64로 인코딩

    final result = await _dio.post(//인코딩된 문자열을 헤더에 담아 post 요청 보냄
      '$_targetUrl/login/email',
      options: Options(
        headers: {
          'authorization': 'Basic $encoded',
        },
      )
    );

    //record 타입으로 토큰 반환
    return (refreshToken: result.data['refreshToken'] as String, accessToken: result.data['accessToken'] as String);
  }

  /// 토큰 재발급 함수
  Future<String> rotateToken({
    required String token,
    required String type
  }) async {
    final key = type == 'access' ? 'accessToken' : 'refreshToken';

    final result = await _dio.post(
      '$_targetUrl/token/$type',
      options: Options(
        headers: {
          'authorization': 'Bearer $key'
        }
      ),
    );

    return result.data[key] as String;
  }
}