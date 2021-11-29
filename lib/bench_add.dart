import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


class BenchAddPage extends StatefulWidget {
  final String areaId, menuId, menunName;

  BenchAddPage(this.areaId, this.menuId, this.menunName);

  @override
  _BenchAddPageState createState() => _BenchAddPageState();
}

class _BenchAddPageState extends State<BenchAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 入力されたテキストをデータとして持つ
  List<Item> items = [];
  String yyyy = DateTime.now().year.toString();
  String MM = DateTime.now().month.toString().padLeft(2);
  String dd = DateTime.now().day.toString().padLeft(2);

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
    Future.delayed(const Duration(seconds: 1)).then((value) {
      removedItem.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        //閉じるボタン
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(child: const Icon(Icons.close))),
        //保存ボタン
        actions: <Widget>[
          Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 24, 0),
              child:
              ElevatedButton(
                onPressed: () {
                  List<Map<String, dynamic>> post = [];

                  for (int i = 0; i < items.length; i++) {
                    var e = items[i];
                    if (e.weightController.text != '' ||
                        e.timesController.text != '') {
                      post.add({
                        'weight': e.weightController.text,
                        'times': e.timesController.text,
                      });
                    }
                    // else{
                    //   continue;
                    // }
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
                  primary: const Color(0xFFffe0b2),
                  elevation: 0,
                ),
                child: Text('保存',
                    style: GoogleFonts.notoSans(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0,color: Color(0xFFf57c00)),
                    )),

              )
          ),
      ],
    ),


      body: SingleChildScrollView(
        reverse: true,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            margin: const EdgeInsets.fromLTRB(22, 8, 22, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // メニュー名
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                  child: Text(
                    widget.menunName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.notoSans(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                ),

                //日付
                Container(
                  margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                      Container(
                        child: Text('$yyyy/$MM/$dd',
                            style: GoogleFonts.notoSans(
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),

                //項目
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
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
                  margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
      ),
    );
  }

  Widget itemNameUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 100,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'セット',
            style: GoogleFonts.notoSans(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
        ),
        Container(
          width: 40,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'kg',
            style: GoogleFonts.notoSans(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
        ),
        Container(
          width: 60,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            '回数',
            style: GoogleFonts.notoSans(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
        ),

      ],
    );
  }


  Widget textFieldUI(Item item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        width: 360,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //セット
            Container(
              width: 100,
              margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                item.id.toString(),
                style: GoogleFonts.notoSans(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            //kgの入力
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: GoogleFonts.notoSans(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 21.0,),
                  ),
                  controller: item.weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFF9e9e9e))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8)
                        ),
                        borderSide: BorderSide(
                            color: Color(0xFFffffff),
                            width: 0
                        )
                    ),// 外枠付きデザイン
                    filled: true,
                    fillColor: Color(0xFFeceff1),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .allow(RegExp(r'[0-9]+(\.)?[0-9]*')),
                    FilteringTextInputFormatter.singleLineFormatter,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
              ),
            ),
            //回数の入力
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 21.0,),
                  ),
                  controller: item.timesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFF9e9e9e))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8)
                        ),
                        borderSide: BorderSide(
                            color: Color(0xFFffffff),
                            width: 0
                        )
                    ),// 外枠付きデザイン
                    filled: true,
                    fillColor: Color(0xFFeceff1),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .allow(RegExp(r'[0-9]+(\.)?[0-9]*')),
                    FilteringTextInputFormatter.singleLineFormatter,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
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
      height: 32,
      child: ElevatedButton.icon(
        onPressed: () {
          add();
        },
        icon: const Icon(Icons.add),
        label: Text('メニューを追加',
          style: GoogleFonts.notoSans(
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFFbbdefb),
          elevation: 0,
          onPrimary: const Color(0xFF42a5f5),
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
