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
      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Card(
            child:ListTile(
                leading: Icon(Icons.people),
                title: Text("${document[fieldName]}"),
                subtitle: Text(document.id),
                onTap: (){
                  function(document[fieldName],document.id);
                }
            ),
          );
        }).toList(),
      );
    },
  );
}







