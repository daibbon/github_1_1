import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:github_1/bench_press.dart';
import 'package:github_1/chest_addpage.dart';
import 'package:github_1/method2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
        elevation: 0,
        iconTheme:const IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),

      body: Container(
        margin: EdgeInsets.fromLTRB(22, 0, 22, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //部位名
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 56),
              child: Text(areaName,
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ),
            ),

            //一番上の線
            const Divider(
              color: Color(0xFFCFCFCF),
              indent: 0,
              endIndent: 0,
              thickness: 1,
              height: 0,
            ),

            //メニュー一覧
            Container(
              child: makingList(_makingStream,'name', _onTap),
            ),
          ],
        ),
      ),

      floatingActionButton:
      Container(
        margin: EdgeInsets.fromLTRB(0, 24, 0, 20),
        child: SizedBox(
          width: 360,
          height: 40,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text('メニューを追加',
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF90CAF9),
              elevation: 0,
              onPrimary: Color(0xFFffffff),
            ),
            onPressed: () async {
              showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => ChestAddPage(areaId));
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
        ),
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
