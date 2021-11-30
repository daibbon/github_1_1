import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_1/migileft_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
const _url = 'https://pub.dev/packages/url_launcher';

class nickname extends StatefulWidget {
  const nickname({Key? key}) : super(key: key);

  @override
  _nicknameState createState() => _nicknameState();
}

class _nicknameState extends State<nickname> {
  // Formのkeyを指定する場合は<FormState>としてGlobalKeyを定義する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //DB、ログイン回りの設定
  final auth = FirebaseAuth.instance;
  Future<UserCredential> signInWithAnonymously() => auth.signInAnonymously();
  //入力フォームの制御用
  final myController = TextEditingController();
  final List<String> areaList = ['胸','肩','腕','背中','腹筋','脚'];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),

      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

              //  サインアップ
              Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'サインアップ',
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ),
            ),

              //ニックネーム入力
              Container(
                margin: const EdgeInsets.fromLTRB(0, 36, 0, 20),
                child: Column(
                  children: [
                    //ニックネーム
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: double.infinity,
                      child: Text(
                        'ニックネーム',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSans(
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ),
                    ),
                    //入力フォーム
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: TextFormField(
                        controller: myController,
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        //デコ
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(), // 外枠付きデザイン
                          hintText: 'トレ太郎', // 入力ヒント
                        ),
                        // ニックネームのバリデーション
                        validator: (_) {
                          // ニックネームが入力されていない場合
                          if (myController.text.isEmpty == true) {
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
              margin: const EdgeInsets.fromLTRB(0, 64, 0, 0),
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
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  //利用規約説明文
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    width: double.infinity,
                    child: Text(
                      'サインアップすることで、あなたは以下に同意したことになり\nます。',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.notoSans(
                        textStyle: const TextStyle(
                            color: Color(0xFF9e9e9e),
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                    ),
                  ),
                  //→利用規約
                  InkWell(
                    // onTap: _launchURL,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
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
      ),
    );
  }

  void _onSignIn() async {
    // 入力内容を確認する
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }
    //ユーザー登録処理
    signInWithAnonymously();
    //ローディング画面表示
    showProgressDialog();
    await Future.delayed(const Duration(seconds: 2));
    //DB登録処理
    String uid = auth.currentUser!.uid.toString();
    addUser(uid);
    Navigator.of(context).pop();
    myController.clear();
    // 画像一覧画面に切り替え
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MigileftScreen(),
      ),
    );
  }

  Future<void> addUser(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference areas = users.doc(uid).collection('areas');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    users.doc(uid).set({'name' : myController.text});

    for (int i = 0; i < areaList.length; i++) {
      String areaID = 'area_' + i.toString();
      String e = areaList[i];
      batch.set(areas.doc(areaID), {
        'name' : e,
        'createdAt' : Timestamp.now(),
      });
    }
    batch.commit();
  }
  //DB登録時間を稼ぐローディング画面
  void showProgressDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  //利用規約リンク
  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

}


