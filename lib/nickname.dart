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
        key: _formKey,
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

            //  サインアップ
            Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              'サインアップ',
              textAlign: TextAlign.left,
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ),
          ),

            //ニックネーム入力
            Container(
              margin: EdgeInsets.fromLTRB(0, 36, 0, 20),
              child: Column(
                children: [
                  //ニックネーム
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
                  //入力フォーム
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      //デコ
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // 外枠付きデザイン
                        hintText: 'トレ太郎', // 入力ヒント
                      ),
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

          //サインアップボタン
          Container(
            margin: EdgeInsets.fromLTRB(0, 64, 0, 0),
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

          //利用規約
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                //利用規約説明文
                Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  width: double.infinity,
                  child: Text(
                    'サインアップすることで、あなたは以下に同意したことになり\nます。',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(
                          color: Color(0xFF9e9e9e),
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                  ),

                ),

                //→利用規約
                InkWell(
                  // onTap: _launchURL,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
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

  //利用規約リンク
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

}


