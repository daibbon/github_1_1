import 'package:flutter/material.dart';
import 'package:github_1/nickname.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Formのkeyを指定する場合は<FormState>としてGlobalKeyを定義する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Welcome to TRECA
              Container(
                margin: EdgeInsets.fromLTRB(10, 150, 10, 30),
                child: Text(
                  'Welcome to TRECA!',
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0),
                  ),
                ),
              ),

              //画像
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Image(
                  width: 411,
                  image: AssetImage('images/training-home-concept_52683-37092.jpg'),
                ),
              ),

              //ログインボタン
              Container(
                margin: EdgeInsets.fromLTRB(10, 80, 10, 20),
                child: SizedBox(
                    width: 317,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                      ),
                      // ログインボタンをタップしたときの処理
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>nickname()));
                      },
                      //ログインボタン詳細
                      child: Text('はじめる',
                        style: GoogleFonts.notoSans(
                          textStyle: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ),
                    )
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

