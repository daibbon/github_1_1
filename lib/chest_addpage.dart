import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ChestAddPage extends StatefulWidget {
  ChestAddPage(this.areaId);
  final String areaId ;

  @override
  _ChestAddPageState createState() => _ChestAddPageState();
}

class _ChestAddPageState extends State<ChestAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 入力されたテキストをデータとして持つ
  String _text = '';

  void _onSignIn() {
    // 入力内容を確認する
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        //戻るボタン
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(child: Icon(Icons.close))),

        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
        actions: <Widget>[
          //保存ボタン
          Container(
              margin: EdgeInsets.fromLTRB(0, 15, 24, 0),
              child:
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc('user_1')
                      .collection('areas')
                      .doc(widget.areaId)
                      .collection('menus')
                      .add({'name': _text}); // データ
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF90CAF9),
                  elevation: 0,
                ),
                child: Text('保存',
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    )),

              )
          ),
        ],
      ),

      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //メニューを追加
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 24, 0, 56),
                child: Text(
                  'メニューを追加',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 26.0),
                  ),
                ),
              ),

              //ニックネーム入力
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    onChanged: (String value) {
                      // データが変更したことを知らせる（画面を更新する）
                      setState(() {
                        // データを変更
                        _text = value;
                      });
                    },
                    //デコレーション
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(), // 外枠付きデザイン
                      // hintText: 'ベンチプレス', // 入力ヒント
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}
