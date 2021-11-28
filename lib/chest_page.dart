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
  late CollectionReference usingCollection;

  //superクラスから変数を引き継ぐ処理
  void initState() {
    areaName = widget.areaName;
    areaId = widget.areaId;
    super.initState();

    usingCollection = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('areas').doc(areaId)
        .collection('menus');

    // データ取得先の指定
    _makingStream = usingCollection
        .orderBy('createdAt', descending: false)
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

  //削除ボタンあり
  Widget makingList(Stream<QuerySnapshot> _makingStream, String fieldName, Function function) {
    return StreamBuilder<QuerySnapshot>(
      stream: _makingStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // データ読込エラーが発生した場合
        if (snapshot.hasError) {
          return Text('エラーが発生しました');
        }
        // データ読込中の場合
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("ロード中");
        }
        //　データの取得
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return InkWell(
                  onTap: (){
                    function(document[fieldName],document.id);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //コンテナ設定
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFCFCFCF)),)
                    ),

                    //リストUI
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //テキスト
                          Text("${document[fieldName]}",
                            style: GoogleFonts.notoSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0,color: Color(0xFF000000).withOpacity(0.7)),), // subtitle: Text(document.id),
                          ),

                          //削除ボタン
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                // isScrollControlled: true,
                                shape: RoundedRectangleBorder( // <= 追加
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                ),
                                builder: (BuildContext context) {
                                  return
                                    //テキスト
                                    Container(
                                        margin: EdgeInsets.only(top: 30),
                                        // height: 50,
                                        decoration: BoxDecoration(
                                          //モーダル自体の色
                                          color: Colors.white,
                                        ),
                                        child: InkWell(
                                          onTap: (){
                                            usingCollection.doc(document.id).delete();
                                            Navigator.of(context).pop();
                                            },
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(20, 0, 0, 30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.delete,
                                                        size: 26,
                                                        color: Colors.grey// アイコンの色を設定できる
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                                      child: Text("削除する",
                                                          style: GoogleFonts.notoSans(
                                                            textStyle: TextStyle(
                                                                fontWeight: FontWeight.normal, fontSize: 18.0,color: Color(0xFF000000).withOpacity(0.7)),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                },
                              );
                            },
                            //アイコン
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.black// アイコンの色を設定できる
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              );

            }).toList(),
          ),
        );

      },
    );
  }
}
