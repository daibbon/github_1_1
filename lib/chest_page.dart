import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:github_1/bench_press.dart';
import 'package:github_1/chest_addpage.dart';
import 'package:github_1/method2.dart';

// リスト一覧画面用Widget
class ChestPage extends StatefulWidget {

  final String areaName ;
  final String areaId ;
  ChestPage(this.areaName, this.areaId);

  @override
  _ChestPageState createState() => _ChestPageState();
}

class _ChestPageState extends State<ChestPage> {

  late String areaName;
  late String areaId;
  late Stream<QuerySnapshot> _makingStream;

  //superクラスから変数を引き継ぐ処理
  void initState() {
    areaName = widget.areaName;
    areaId = widget.areaId;
    super.initState();

    // データ取得先の指定
    _makingStream = FirebaseFirestore.instance
        .collection('users')
        .doc('user_1')
        .collection('areas')
        .doc(areaId)
        .collection('menus')
        .snapshots();
  }

  // //画面遷移のメソッド
  void _onTap(String menuName, String menuId){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => BenchPressPage(areaId, menuName, menuId)));
  }

  // Todoリストのデータ
  List<String> chestList = [];

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(areaName,
          style:const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.5,
        iconTheme:const IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),

      body: makingList(_makingStream,'name', _onTap),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label:const Text('メニューを追加'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0.5,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ChestAddPage(areaId)));
          // // "push"で新規画面に遷移
          // // メニュー追加画面から渡される値を受け取る
          // final newListText = await Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) {
          //     // 遷移先の画面としてメニュー追加画面を指定
          //     return ChestAddPage();
          //   }),
          // );
          // if (newListText != null) {
          //   // キャンセルした場合は newListText が null となるので注意
          //   setState(() {
          //     // リスト追加
          //     chestList.add(newListText);
          //   });
          // }
        },
        // child: Icon(
        //   Icons.add, size: 36),
      ),
    );
  }
  // Widget makingList(String fieldName) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _makingStream,
  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       // データ読込エラーが発生した場合
  //       if (snapshot.hasError) {
  //         return Text('エラーが発生しました');
  //       }
  //       // データ読込中の場合
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Text("ロード中");
  //       }
  //       //　データの取得
  //       return ListView(
  //         children: snapshot.data!.docs.map((DocumentSnapshot document) {
  //           Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  //           return Card(
  //             child:ListTile(
  //               leading: Icon(Icons.people),
  //               title: Text("${document[fieldName]}"),
  //               subtitle: Text(document.id),
  //               onTap: () {
  //                 Navigator.push(context, MaterialPageRoute(
  //                     builder: (context) => BenchPressPage(areaName,document[fieldName],document.id)));
  //               },
  //             ),
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }
}
