import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChestAddPage extends StatefulWidget {
  ChestAddPage(this.areaId);
  final String areaId ;

  @override
  _ChestAddPageState createState() => _ChestAddPageState();
}

class _ChestAddPageState extends State<ChestAddPage> {
  // 入力されたテキストをデータとして持つ
  String _text = '';
  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('メニュー追加'),
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: CupertinoColors.white,
      ),
      body: Container(
        // 余白を付ける
        padding:const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 入力されたテキストを表示
            // Text(_text, style: TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            // テキスト入力
            TextField(
              autofocus: true,
              // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
              onChanged: (String value) {
                // データが変更したことを知らせる（画面を更新する）
                setState(() {
                  // データを変更
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: ElevatedButton(
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
                child: const Text('完了', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // キャンセルボタン
              child: TextButton(
                // ボタンをクリックした時の処理
                onPressed: () {
                  // "pop"で前の画面に戻る
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
