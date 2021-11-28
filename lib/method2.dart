import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// ★　データベースのデータをもとにリストを作成するウィジェット　★
// 【利用時の注意】
//　 ・フィールド名（データ名）、遷移ページ（クラス名）を引数として渡すこと
// 　・データ取得先は各ページで指定すること。
// 　　以下、データ取得先指定の例
// 　　　final Stream<QuerySnapshot> _areasStream = FirebaseFirestore.instance
//     　　　　　.collection('users')
//    　　　　　 .doc('user_1')
//    　　　　　 .collection('areas')
//    　　　　　 .snapshots();

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
                                        //  削除処理お願いします。
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


//削除ボタンなし
Widget makingList2(Stream<QuerySnapshot> _makingStream, String fieldName, Function function) {
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
                        Text("${document[fieldName]}",
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0,color: Color(0xFF000000).withOpacity(0.7)),), // subtitle: Text(document.id),
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




