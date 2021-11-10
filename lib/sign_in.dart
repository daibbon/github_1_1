import 'package:flutter/material.dart';
import 'package:github_1/home_page2.dart';
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
        // Formのkeyに指定する
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                margin: EdgeInsets.fromLTRB(10, 150, 10, 30),
                child: Text(
                  'Welcome to TRECA!',
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.0),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Image(
                  width: 411,
                  image: AssetImage('images/training-home-concept_52683-37092.jpg'),
                ),
              ),



              Container(
                margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
                child: Text(
                  '利用規約に同意する',
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: SizedBox(
                    width: 317,
                    height: 40,
                    child: ElevatedButton(
                      // ログインボタンをタップしたときの処理
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>nickname()));
                      },
                      child: Text('サインアップ',
                        style: GoogleFonts.notoSans(
                          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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

