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
        .collection('users').doc('user_1')
        .collection('areas').doc(areaId)
        .collection('menus').doc(menuId)
        .collection('posts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuName,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),
      body: postList(_makingStream),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFffffff),
        foregroundColor: const Color(0xFFFFCC80),
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
            margin: const EdgeInsets.fromLTRB(0, 24, 0, 6),
            decoration: const BoxDecoration(color: Color(0xFFffffff)),
            child: ListView(
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
                    margin: EdgeInsets.fromLTRB(18, 6, 18, 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFbdbdbd)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(2),
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
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(2),
          child: Text(
              '${createdAt.year}/${createdAt.month}/${createdAt.day}'
                  '  ${createdAt.hour}:${createdAt.minute}'),
        ),
        Row(children: const <Widget>[
          Text('セット'),
          Text('重量'),
          Text('回数'),
        ]),
      ],);
  }

//実際のセットのUI
  Widget setListUI(Record record) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(2),
          child: Text(record.set),
        ),
        Container(
          margin: EdgeInsets.all(2),
          child: Text(record.weight),
        ),
        Container(
          margin: EdgeInsets.all(2),
          child: Text('kg'),
        ),
        Container(
          margin: EdgeInsets.all(2),
          child: Text(record.times),
        ),
        Container(
          margin: EdgeInsets.all(2),
          child: Text('回'),
        ),
      ],
    );
  }
}

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

