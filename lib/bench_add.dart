import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class BenchAddPage extends StatefulWidget {
  final String areaId, menuId;

  BenchAddPage(this.areaId, this.menuId);

  @override
  _BenchAddPageState createState() => _BenchAddPageState();
}

class _BenchAddPageState extends State<BenchAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 入力されたテキストをデータとして持つ
  List<Item> items = [];

  void initState() {
    items.add(Item.create(0, "", ""));
  }

  @override
  void dispose() {
    items.forEach((element) {
      element.dispose();
    });

    super.dispose();
  }

  void add() {
    setState(() {
      items.add(Item.create(items.last.id, "", ""));
    });
  }

  void remove() {
    final removedItem = items.last;
    setState(() {
      items.removeLast();
    });
    // itemのcontrollerをすぐdisposeすると怒られるので
    // 少し時間をおいてからdipose()
    Future.delayed(Duration(seconds: 1)).then((value) {
      removedItem.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        //閉じるボタン
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(child: Icon(Icons.close))),
        //保存ボタン
        actions: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(0, 15, 24, 0),
              child:
              ElevatedButton(
                onPressed: () {
                  List<Map<String, dynamic>> post = [];

                  for (int i = 0; i < items.length; i++) {
                    var e = items[i];
                    if (e.timesController != '') {
                      post.add({
                        'weight': e.weightController.text,
                        'times': e.timesController.text,
                      });
                    }
                  }
                  FirebaseFirestore.instance.collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('areas').doc(widget.areaId)
                      .collection('menus').doc(widget.menuId)
                      .collection('posts').add({
                    // 'set': FieldValue.arrayUnion([post]),
                    'set': post,
                    'createdAt' : Timestamp.fromDate(DateTime.now()),
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFffad42),
                  elevation: 0,
                ),
                child: Text('保存',
                    style: GoogleFonts.notoSans(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    )),

              )
          ),
      ],
    ),


      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          margin: EdgeInsets.fromLTRB(22, 8, 22, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // メニュー名
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 32),
                child: Text(
                  // menuName,←反映させたいです。。
                  'メニュー名',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ),
              ),

              //日付
              Container(
                margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                    // Container(
                    //   child: Text(
                    //       '${createdAt.year}/${createdAt.month}/${createdAt.day}'
                    //           '  ${createdAt.hour}:${createdAt.minute}',
                    //       style: GoogleFonts.notoSans(
                    //         textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                    //       )
                    //   ),
                    // ),
                  ],
                ),
              ),

              //項目
              Container(
                margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
                child: itemNameUI(),
              ),
              //入力リスト
              Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...items.map((item) => textFieldUI(item)),
                  ],
                ),
              ),
              //セット追加
              Container(
                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: setAddUI(),
              ),
              //セット削除（テスト用）
              // Container(
              //   margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              //   child: setDeleteUI(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemNameUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: Text(
            'セット',
            style: GoogleFonts.notoSans(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 80, 0),
              child: Text(
                '重量',
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 34, 0),
              child: Text(
                '回数',
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget textFieldUI(Item item) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        width: 360,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                item.id.toString(),
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: SizedBox(
                            width: 60,
                            child: TextField(
                              autofocus: true,
                              style: GoogleFonts.notoSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22.0,),
                              ),
                              controller: item.weightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(), // 外枠付きデザイン
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.singleLineFormatter,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text(
                            'kg',
                            style: GoogleFonts.notoSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: SizedBox(
                            width: 60,
                            child: TextField(
                              style: GoogleFonts.notoSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22.0,),
                              ),
                              controller: item.timesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(), // 外枠付きデザイン
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.singleLineFormatter,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text(
                            '回',
                            style: GoogleFonts.notoSans(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setAddUI() {
    return SizedBox(
      width: 360,
      height: 36,
      child: ElevatedButton.icon(
        onPressed: () {
          add();
        },
        icon: const Icon(Icons.add),
        label: Text('メニューを追加',
          style: GoogleFonts.notoSans(
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF90CAF9),
          elevation: 0,
          onPrimary: Color(0xFFffffff),
        ),
      ),
    );
  }

//test用セット削除UI
//   Widget setDeleteUI() {
//     return SizedBox(
//       width: 360,
//       height: 40,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           remove();
//         },
//         label: Text('セットを削除',
//             style: GoogleFonts.notoSans(
//               textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
//             )),
//         icon: const Icon(
//           Icons.add,
//           color: Color(0xFF0FFCC80),
//         ),
//         style: ElevatedButton.styleFrom(
//           primary: Color(0xFFffffff),
//           onPrimary: Color(0xFF000000).withOpacity(0.7),
//           elevation: 0,
//           // shape: const StadiumBorder(),
//         ),
//       ),
//     );
//   }
}

class Item {
  final int id;
  final TextEditingController weightController;
  final TextEditingController timesController;

  Item({
    required this.id,
    required this.weightController,
    required this.timesController,
  });

  factory Item.create(int id, String weight, String times) {
    return Item(
      id: id + 1,
      weightController: TextEditingController(text: weight),
      timesController: TextEditingController(text: times),
    );
  }

  void dispose() {
    weightController.dispose();
    timesController.dispose();
  }
}

class Set {
  final String weight, times;

  Set({
    required this.weight, required this.times
  });
}
