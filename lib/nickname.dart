import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_1/migileft_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const _url = 'https://pub.dev/packages/url_launcher';

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
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),

      body: Form(
        // Formのkeyに指定する
        key: _formKey,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

            Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              'サインアップ',
              textAlign: TextAlign.left,
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
          ),

            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    child: Text(
                      'ニックネーム',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.notoSans(
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: TextFormField(
                      autofocus: true,
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
                  ),
                ],
              ),
            ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: SizedBox(
              width: 363,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                // ログインボタンをタップしたときの処理
                onPressed: () => _onSignIn(),
                child: Text('サインアップ',
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
                  width: double.infinity,
                  child: Text(
                    'サインアップすることで、あなたは以下に同意したことになり\nます',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
                    ),
                  ),
                ),

                InkWell(
                  onTap: _launchURL,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
                    child: Text(
                      '利用規約',
                      style: GoogleFonts.notoSans(
                        textStyle: TextStyle(
                            color: Colors.blue.withOpacity(0.8),
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

            ],
          ),
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
        builder: (_) => MigileftScreen(),
      ),
    );
  }
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

}


