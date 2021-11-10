import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_1/home_page2.dart';
import 'package:google_fonts/google_fonts.dart';


class nickname extends StatefulWidget {
  const nickname({Key? key}) : super(key: key);

  @override
  _nicknameState createState() => _nicknameState();
}

class _nicknameState extends State<nickname> {
  // Formのkeyを指定する場合は<FormState>としてGlobalKeyを定義する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サインアップ',
          style: TextStyle(color: Colors.black),
        ),
        // centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),
      body: Form(
        // Formのkeyに指定する
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 60, 10, 30),
              child: Text(
                'ニックネームを\n入力してください',
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
            ),

            SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'ニックネーム',

              ),
              keyboardType: TextInputType.name,
              // ニックネームのバリデーション
              validator: (String? value) {
                // ニックネームが入力されていない場合
                if (value?.isEmpty == true) {
                  // 問題があるときはメッセージを返す
                  return 'ニックネームを入力して下さい';
                }
                // 問題ないときはnullを返す
                return null;
              },
            ),

            // SizedBox(height: 16),
            Container(
              margin: EdgeInsets.fromLTRB(10, 60, 10, 30),
              child: SizedBox(
                width: 317,
                height: 40,

                child: ElevatedButton(
                  // ログインボタンをタップしたときの処理
                  onPressed: () => _onSignIn(),
                  child: Text('トレーニングをはじめる',
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSignIn() {
    // 入力内容を確認する
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }
    // 画像一覧画面に切り替え
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Migileft(),
      ),
    );
  }
}


