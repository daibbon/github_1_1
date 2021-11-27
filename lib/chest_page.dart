import 'package:firebase_auth/firebase_auth.dart';
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
    _makingStream = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('areas').doc(areaId)
        .collection('menus').orderBy('createdAt', descending: false)
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
              margin: EdgeInsets.fromLTRB(0, 16, 0, 56),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(areaName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
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
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 00),
                      child: const Icon(Icons.add_circle,
                      size:40, color: Color(0xFFffad42)),
                    ),
                  ),
                ],
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
