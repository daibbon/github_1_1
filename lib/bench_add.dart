import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_1/workout_set.dart';


class BenchAddPage extends StatefulWidget {
  @override
  _BenchAddPageState createState() => _BenchAddPageState();
}

class _BenchAddPageState extends State<BenchAddPage> {
  // 入力されたテキストをデータとして持つ
  String _text = '';
  List _list = [
    WorkoutSet(),
  ];

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ベンチプレス'),
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: CupertinoColors.white,
      ),
        body:Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 350,
                    height: 30,
                    child: ElevatedButton(
                      child: Text('セット追加',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _list.add(
                            WorkoutSet(),
                          );
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (_list.length == 1) {
                        Fluttertoast.showToast(msg: "これ以上減らせません！！");
                      } else {
                        setState(() {
                          _list.removeAt(_list.length - 1);
                        });
                      }
                    },
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _list[index];
                  },
                ),
              ),
            ],
          ),
        ),

      // body: Container(
      //
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      //     child: ListView.builder(
      //       itemCount: 1,
      //       itemBuilder: (context, index) {
      //         return
      //
      //           Card(
      //           child: TextField(
      //             decoration: InputDecoration(
      //               border: InputBorder.none,
      //             ),
      //               // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
      //               onChanged: (String value) {
      //                 // データが変更したことを知らせる（画面を更新する）
      //                 setState(() {
      //                   // データを変更
      //                   _text = value;
      //                 });
      //               },
      //             ),
      //           );
      //       },
      //     ),
      //   ),
      // ),

        floatingActionButton:
        SizedBox(
          width: 360,
          height: 50,
          child:ElevatedButton(
            child: const Text('入力完了',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Navigator.of(context).pop(_text);
            },
          ),
        )
    );
  }
}


