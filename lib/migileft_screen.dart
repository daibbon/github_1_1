import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:github_1/chest_page.dart';


class MigileftScreen extends StatefulWidget {
  @override
  _MigileftState createState() => _MigileftState();
}

class _MigileftState extends State<MigileftScreen> {

  // データ取得先の指定
  final Stream<QuerySnapshot> _makingStream = FirebaseFirestore.instance
      .collection('users')
      .doc('user_1')
      .collection('areas')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 100, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('トレーニング',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 30),)
                    ],
                  ),
                ),
                Expanded(
                  child: MakingList('name'),
                ),
              ]
          )
      ),
    );
  }

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

  Widget MakingList(String fieldName) {
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChestPage('${document[fieldName]}')));
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}



