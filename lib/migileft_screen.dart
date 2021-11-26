import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//遷移先
import 'package:github_1/chest_page.dart';
import 'package:github_1/method2.dart';
//サインアウト用に仮挿入

class MigileftScreen extends StatefulWidget {
  // final String uid ;
  // MigileftScreen(this.uid);

  @override
  _MigileftState createState() => _MigileftState();
}

class _MigileftState extends State<MigileftScreen> {

  // データ取得先の指定
  final Stream<QuerySnapshot> _makingStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
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
        appBar: AppBar(
          backgroundColor: CupertinoColors.white,
          elevation: 0,
        ),

        body:
        Container(
          margin: EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //トレーニング
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 24, 0, 56),
                  child: Text('トレーニング',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
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

                //部位一覧
                Container(
                    //引数にstream名/フィールド名/画面遷移のメソッドを代入する
                  child: makingList2(_makingStream, 'name', _onTap),
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
            label: Text('サインアウト',
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF90CAF9),
              elevation: 0,
              onPrimary: Color(0xFFffffff),
            ),
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            // child: Icon(
            //   Icons.add, size: 36),
          ),
        ),
      ),
    );
  }
}
