import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'logins_page.dart'; // 이 부분에 로그인 페이지의 파일 경로를 import 해주세요.

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int _timerCount = 180;
  bool _isButtonDisabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // 타이머 시작
    _startTimer();
  }

  @override
  void dispose() {
    // 페이지가 dispose 될 때 타이머를 정리합니다.
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        elevation: 0.0,
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 50)),
          Center(
            child: Image(
              image: AssetImage('assets/images/baro.png'),
              width: 170.0,
            ),
          ),
          Form(
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.grey,
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: '성함'),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: '이메일'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: '비밀번호'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      TextField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(labelText: '핸드폰 번호'),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: _smsCodeController,
                        decoration: const InputDecoration(labelText: '인증 코드'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 40.0),
                      ButtonTheme(
                        minWidth: 100.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: _isButtonDisabled ? null : () async {
                            await _verifyPhoneNumber();
                          },
                          child: Text(
                            _isButtonDisabled ? '인증번호 받기 ($_timerCount초)' : '인증번호 받기',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ButtonTheme(
                        minWidth: 100.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _signInWithPhoneNumber();
                          },
                          child: const Text(
                            '가입 완료',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 타이머 시작
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_timerCount < 1) {
          timer.cancel();
          _isButtonDisabled = false; // 버튼 활성화
        } else {
          _timerCount--;
        }
      });
    });
  }

  // 핸드폰 번호로 인증 코드를 요청합니다.
  Future<void> _verifyPhoneNumber() async {
    try {
      setState(() {
        _isButtonDisabled = true; // 버튼 비활성화
        _timerCount = 180; // 타이머 초기화
      });
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // 인증이 자동으로 완료된 경우 (예: 사용자가 이미 핸드폰에 로그인되어 있음)
          await _auth.signInWithCredential(credential);
          // 여기에서 회원가입 완료 처리를 수행할 수 있습니다.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogInPage(), // 로그인 페이지로 이동합니다.
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print('핸드폰 인증 실패: $e');
          // 핸드폰 인증 실패 시 사용자에게 메시지 표시 또는 다른 작업 수행
        },
        codeSent: (String verificationId, int? resendToken) {
          // 코드가 성공적으로 전송된 경우
          _verificationId = verificationId;
          print('인증 코드가 성공적으로 전송되었습니다: $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // 코드 자동 검색 시간이 만료된 경우
          _verificationId = verificationId;
          print('인증 코드를 자동으로 검색하는 시간이 만료되었습니다: $verificationId');
        },
        timeout: const Duration(seconds: 180), // 시간 초과: 60초
      );
    } catch (e) {
      print('핸드폰 번호 인증 요청 실패: $e');
      // 핸드폰 번호 인증 요청 실패 시 사용자에게 메시지 표시 또는 다른 작업 수행
    }
  }

  // 인증 코드를 사용하여 회원가입을 완료합니다.
  Future<void> _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCodeController.text,
      );
      await _auth.signInWithCredential(credential);
      // 여기에서 회원가입 완료 처리를 수행할 수 있습니다.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogInPage(), // 로그인 페이지로 이동합니다.
        ),
      );
    } catch (e) {
      print('핸드폰 번호로 로그인 실패: $e');
      // 핸드폰 번호로 로그인 실패 시 사용자에게 메시지 표시 또는 다른 작업 수행
    }
  }
}