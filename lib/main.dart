import 'package:flutter/material.dart';
import 'logins_page.dart'; // 변경: 로그인 페이지를 별도 파일로 분할
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart'; // 카카오 플러터 SDK 임포트
import 'login_platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: 'a78c48eebbf010d065fb9e01e9fa75e5'); // 카카오 SDK 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: const LogInPage(),
    );
  }
}