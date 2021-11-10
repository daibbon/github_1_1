import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_1/sign_in.dart';


Future<void> main() async {
  //Firebase利用時に追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRECA',
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFCC80),
        ),
      ),
      // アプリ起動時にログイン画面を表示
      home: SignInScreen(),
    );
  }
}
