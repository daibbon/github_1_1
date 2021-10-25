import 'package:flutter/material.dart';
import 'package:github_1/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRECA',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // アプリ起動時にログイン画面を表示
      home: SignInScreen(),
    );
  }
}


