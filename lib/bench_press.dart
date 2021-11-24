import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:github_1/bench_add.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// リスト一覧画面用Widget
class BenchPressPage extends StatefulWidget {
  final String areaId, menuName, menuId;
  BenchPressPage(this.areaId, this.menuName, this.menuId);

  @override
  _BenchPressPageState createState() => _BenchPressPageState();
}

class Record {
  final String set, weight, times;

  Record({
    required this.set, required this.weight, required this.times,
  });
}

class _BenchPressPageState extends State<BenchPressPage> {
  late String areaId, menuName, menuId;
  late Stream<QuerySnapshot> _makingStream;


  //superクラスから変数を引き継ぐ処理
  void initState() {
    areaId = widget.areaId;
    menuName = widget.menuName;
    menuId = widget.menuId;
    super.initState();

    // データ取得先の指定
    _makingStream = FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('areas').doc(areaId)
        .collection('menus').doc(menuId)
        .collection('posts').orderBy('createdAt', descending: true)
        .snapshots();
  }

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
            //メニュー名
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 56),
              child: Text(menuName,
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ),
            ),
            //セット一覧
            Container(child: postList(_makingStream)),
          ],
        ),
      ),

      //セット追加ボタン
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFffad42),
        foregroundColor: const Color(0xFFffffff),
        // foregroundColor: const Color(0xFFFFCC80),
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>SetAdd2()));
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => BenchAddPage(areaId, menuId),
          );
        },
        child: const Icon(
          Icons.add,
          size: 44,
        ),
      ),
    );
  }

//body本体
  Widget postList(Stream<QuerySnapshot> _makingStream) {
    return StreamBuilder<QuerySnapshot>(
        stream: _makingStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // データ読込エラーが発生した場合
          if (snapshot.hasError) {
            return const Text('エラーが発生しました');
          }
          // データ読込中の場合
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("ロード中");
          }
          //　データの取得
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: const BoxDecoration(color: Color(0xFFffffff)),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                DateTime createdAt = document["createdAt"].toDate();
                List<Record> records = [];
                List<dynamic> recordMap = document['set'];

                for (int i = 0; i < recordMap.length; i++) {
                  var element = recordMap[i];
                  records.add(Record(
                    set: (i + 1).toString(),
                    weight: element['weight'],
                    times: element['times'],
                  ));
                }
                return InkWell(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFbdbdbd)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: headUI(createdAt),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ...records.map((record) => setListUI(record)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }

// 日付,セット,重量,回数のUI
  Widget headUI(DateTime createdAt) {
    String yyyy = createdAt.year.toString();
    String MM = createdAt.month.toString().padLeft(2);
    String dd = createdAt.day.toString().padLeft(2);
    String HH = createdAt.hour.toString().padLeft(2);
    String mm = createdAt.minute.toString().padLeft(2, '0');

    return Container(
      margin: EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //日付
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      size: 18,
                    ),
                  ),
                  Container(
                    child: Text('$yyyy/$MM/$dd   $HH:$mm',
                        style: GoogleFonts.notoSans(
                          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                        )
                    ),
                  ),
                ],
              ),

              //削除ボタン
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    // isScrollControlled: true,
                    shape: RoundedRectangleBorder( // <= 追加
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    //削除POP
                    builder: (context) => DraggableScrollableSheet(
                      builder: (context, scrollController) =>
                      //テキスト
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            //モーダル自体の色
                            color: Colors.white,
                          ),
                          child: Text("削除する")),
                    ),
                  );
                },
                //アイコン
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Icon(
                      Icons.more_horiz,
                      color: Colors.black// アイコンの色を設定できる
                  ),
                ),
              ),
            ],
          ),

          //セット/重量/回数
          Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              // セット
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text('セット',
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: [
                    //重量
                    Container(
                      margin: EdgeInsets.fromLTRB(24, 0, 16, 0),
                      child: Text('重量',
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                          )),
                    ),
                    //回数
                    Container(
                      margin: EdgeInsets.fromLTRB(24, 0, 28, 0),
                      child: Text('回数',
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0,),
                          )),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],),
    );
  }

//実際のセットのUI
  Widget setListUI(Record record) {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //セット
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(record.set,
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),
                )),
          ),

          Row(
            children: [
              //重量
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 8, 0),
                child: Text(record.weight,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                    )),
              ),
              //kg
              Container(
                margin: EdgeInsets.fromLTRB(0, 4, 16, 0),
                child: Text('kg',
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0,color: Color(0xFFbdbdbd)),
                    )),
              ),
              //回数
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 8, 0),
                child: Text(record.times,
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                    )),
              ),
              //回
              Container(
                margin: EdgeInsets.fromLTRB(0, 4, 12, 0),
                child: Text('回',
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0,
                          color: Color(0xFFbdbdbd)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//テスト用
// @override
// String toString() {
//   return text;
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(menuName,
//           style: const TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: Colors.black),
//         backgroundColor: CupertinoColors.white,
//       ),
//         body: Container(
//             margin: EdgeInsets.fromLTRB(0, 24, 0, 6),
//             decoration: BoxDecoration(color: Color(0xFFffffff)),
//               child: ListView.builder(
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     // onTap: (){
//                     //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Setmanege()));
//                     // },
//                     child: Container(
//                       margin: EdgeInsets.fromLTRB(18, 6, 18, 6),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Color(0xFFbdbdbd)),
//                         borderRadius: BorderRadius.circular(12),
//                         // color: Color(0xFF424242).withOpacity(1),
//                       ),
//                       // color: Color(value),
//                       child: Padding(
//                         child: Text(
//                             '${widget.sampleList[index]}',
//                             style: GoogleFonts.notoSans(
//                               textStyle: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16.0,color: Color(0xFF000000).withOpacity(0.7)),
//                             )
//                         ),
//                         padding: EdgeInsets.all(20.0),
//                       ),
//                     ),
//                   );
//                 },
//                 itemCount: widget.sampleList.length,
//               ),
//             ),
//
//         floatingActionButton:
//         FloatingActionButton(
//           backgroundColor: const Color(0xFFffffff),
//           foregroundColor: Color(0xFFFFCC80),
//           onPressed: () {
//             // Navigator.push(context, MaterialPageRoute(builder: (context)=>SetAdd2()));
//             showMaterialModalBottomSheet(
//               context: context,
//               builder: (context) => BenchAddPage(),
//             );
//           },
//           child: Icon(Icons.add,size: 44,),
//         )
//     );
//   }

