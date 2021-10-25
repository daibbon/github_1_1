import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_1/bench_add.dart';
import 'package:github_1/workout_set.dart';



// リスト一覧画面用Widget
class BenchPressPage extends StatefulWidget {
  @override
  _BenchPressPageState createState() => _BenchPressPageState();
}

class _BenchPressPageState extends State<BenchPressPage> {
  // Todoリストのデータ
  List<String> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ベンチプレス',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_list[index]),
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChestPage()));
              // },
            ),
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('セットを追加'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0.5,
        onPressed: () async {
          // "push"で新規画面に遷移
          // メニュー追加画面から渡される値を受け取る
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてメニュー追加画面を指定
              return BenchAddPage();
            }),
          );
          if (newListText != null) {
            // キャンセルした場合は newListText が null となるので注意
            setState(() {
              // リスト追加
              _list.add(newListText);
            });
          }
        },
        // child: Icon(
        //     Icons.add, size: 36),
      ),
    );
  }
}

