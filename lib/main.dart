import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:github_1/migileft_screen.dart';
import 'package:github_1/sign_in.dart';

Future<void> main() async {
  //Firebase利用時に追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRECA',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF424242),
        ),
      ),
      // アプリ起動時にログイン画面を表示
      home: loginCheck(),
    );
  }

  Widget loginCheck(){
    if (auth.currentUser != null) {
      return MigileftScreen();
    }
    return SignInScreen();
  }
}
