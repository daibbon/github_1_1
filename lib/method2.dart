import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return InkWell(
                onTap: (){
                  function(document[fieldName],document.id);
                },
              child: Container(
                margin: EdgeInsets.fromLTRB(18, 6, 18, 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFbdbdbd)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("${document[fieldName]}"),
                      // subtitle: Text(document.id),
                ),
              ),
            );

          }).toList(),
        ),
      );

    },
  );
}







