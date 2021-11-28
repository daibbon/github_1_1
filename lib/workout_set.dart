import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkoutSet extends StatefulWidget {
  @override
  _WorkoutSetState createState() => _WorkoutSetState();
}

class _WorkoutSetState extends State<WorkoutSet> {
  // 入力されたテキストをデータとして持つ
  String _text = '';

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text('1',
              style: TextStyle(fontSize: 18)),
          const SizedBox(
            width:150,
            height: 150,
          ),
          Flexible(child: TextField(
            decoration: const InputDecoration(labelText: '0'),
            onChanged: (String value) {
              // データが変更したことを知らせる（画面を更新する）
              setState(() {
                // データを変更
                _text = value;
              });
            },
          )),
          const Text('kg',
              style: TextStyle(fontSize: 18)),
          const SizedBox(
            width:20,
          ),
          const Flexible(child: TextField(
            decoration: InputDecoration(labelText: '0'),
          )),
          const Text('回',
              style: TextStyle(fontSize: 18)),
        ],
      ),
    );

      Scaffold(
      body: Container(
        // 余白を付ける
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 入力されたテキストを表示
            Text(_text, style: TextStyle(color: Colors.blue)),
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
                onPressed: () {
                  Navigator.of(context).pop(_text);
                },
                child: Text('完了', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}