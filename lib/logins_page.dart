import 'package:baro/sample_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_home_page.dart';
import 'signup_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        elevation: 0.0,
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed: () {})
        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 40.0), // 좌우 여백 추가
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: '이메일'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: '비밀번호'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      const SizedBox(height: 40.0),
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                              await _auth.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              print('사용자 로그인: ${userCredential.user!.uid}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                              // 로그인 성공 시 다음 페이지로 이동하거나 다른 작업 수행
                            } catch (e) {
                              print('로그인 실패: $e');
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('로그인 실패'),
                                  content: Text('잘못된 정보를 입력하셨습니다.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // 다이얼로그 닫기
                                      },
                                      child: Text('확인'),
                                    ),
                                  ],
                                ),
                              );
                              // 로그인 실패 시 사용자에게 메시지 표시 또는 다른 작업 수행
                            }
                          },
                          child: const Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0), // 회원가입 버튼과 로그인 버튼 사이에 간격 추가
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // 회원가입 버튼을 눌렀을 때 회원가입 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            '이메일 회원가입',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0), // 카카오톡 로그인 버튼 위 간격 추가
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // 회원가입 버튼을 눌렀을 때 회원가입 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SampleScreen(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/kakao_login_button.png',
                            height: 40.0,
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
}
