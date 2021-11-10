import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:github_1/chest_page.dart';
import 'package:github_1/method2.dart';
import 'package:google_fonts/google_fonts.dart';


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

  // //画面遷移のメソッド
  void _onTap(String areaName, String areaId){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ChestPage(areaName,areaId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 100, 200, 20),
                      // padding: EdgeInsets.all(20.0),
                      child: Text(
                          "トレーニング",
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
                          )
                      )),

                  Container(
                    child: Expanded(
                      //引数にstream名/フィールド名/画面遷移のメソッドを代入する
                      child: makingList(_makingStream, 'name', _onTap),
                    ),
                  ),
                ]
            ),
          )

      );
  }
}
