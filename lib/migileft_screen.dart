import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//遷移先
import 'package:github_1/chest_page.dart';
import 'package:github_1/method2.dart';

class MigileftScreen extends StatefulWidget {

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
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid).delete();
              FirebaseAuth.instance.signOut();
              // FirebaseAuth.instance.currentUser!.delete();
            },
            // child: Icon(
            //   Icons.add, size: 36),
          ),
        ),
      ),
    );
  }

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

}
