import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:github_1/bench_add.dart';
import 'package:github_1/workout_set.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';



// リスト一覧画面用Widget
class BenchPressPage extends StatefulWidget {
  final String areaId ;
  final String menuName ;
  final String menuId ;
  BenchPressPage(this.areaId,this.menuName,this.menuId);

  // リストのデータ
  final List<String> sampleList = <String>[
    '11/1',
    '10/30',
    '11/29',
  ];

  @override
  _BenchPressPageState createState() => _BenchPressPageState();
}

class _BenchPressPageState extends State<BenchPressPage> {

  late String areaId;
  late String menuName;
  late String menuId ;
  late Stream<QuerySnapshot> _makingStream;

  //superクラスから変数を引き継ぐ処理
  void initState() {

    areaId = widget.areaId;
    menuName = widget.menuName;
    menuId = widget.menuId;
    super.initState();

    // データ取得先の指定
    _makingStream = FirebaseFirestore.instance
        .collection('users')
        .doc('user_1')
        .collection('areas')
        .doc(areaId)
        .collection('menus')
        .doc(menuId)
        .collection('posts')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuName,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),
        body: Container(
            margin: EdgeInsets.fromLTRB(0, 24, 0, 6),
            decoration: BoxDecoration(color: Color(0xFFffffff)),
            child: Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    // onTap: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Setmanege()));
                    // },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(18, 6, 18, 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFbdbdbd)),
                        borderRadius: BorderRadius.circular(12),
                        // color: Color(0xFF424242).withOpacity(1),
                      ),
                      // color: Color(value),
                      child: Padding(
                        child: Text(
                            '${widget.sampleList[index]}',
                            style: GoogleFonts.notoSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0,color: Color(0xFF000000).withOpacity(0.7)),
                            )
                        ),
                        padding: EdgeInsets.all(20.0),
                      ),
                    ),
                  );
                },
                itemCount: widget.sampleList.length,
              ),
            )),

        floatingActionButton:
        FloatingActionButton(
          backgroundColor: const Color(0xFFffffff),
          foregroundColor: Color(0xFFFFCC80),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>SetAdd2()));
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => BenchAddPage(),
            );
          },
          child: Icon(Icons.add,size: 44,),
        )
    );
  }
}

