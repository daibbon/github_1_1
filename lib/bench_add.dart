import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';


class BenchAddPage extends StatefulWidget {
  const BenchAddPage({Key? key}) : super(key: key);

  @override
  _BenchAddPageState createState() => _BenchAddPageState();
}

class _BenchAddPageState extends State<BenchAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 入力されたテキストをデータとして持つ
  String _text = '';
  List _list = [
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(0, 6, 24, 0),
              child:
              SizedBox(
                width: 50,
                height:40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BenchAddPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF90CAF9),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                  ),
                  child: Text('保存',
                      style: GoogleFonts.notoSans(
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                      )),

                ),
              )
          ),
        ],
        automaticallyImplyLeading: false,
        // title: Text('ベンチプレス',
        //   style: TextStyle(color: Colors.black),
        // ),
        // centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: CupertinoColors.white,
      ),
      body: Form(
        // Formのkeyに指定する
        key: _formKey,

        child: Container(
          margin: EdgeInsets.fromLTRB(32, 32, 32, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text('セット',
                          style: GoogleFonts.notoSans(
                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                          )
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 42, 0),
                          child: Text('重さ',
                              style: GoogleFonts.notoSans(
                                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text('回数',
                              style: GoogleFonts.notoSans(
                                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _list[index];
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SizedBox(
                  width: 360,
                  height: 40,
                  child:ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _list.add(
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: SizedBox(
                                width: 360,
                                height: 40,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Text(_list.length.toString(),
                                          style: GoogleFonts.notoSans(
                                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                          )
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
                                                  width: 30,
                                                  child: TextField(
                                                    // autofocus: true,
                                                    // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
                                                    // onChanged: (String value) {
                                                    //   // データが変更したことを知らせる（画面を更新する）
                                                    //   setState(() {
                                                    //     // データを変更
                                                    //     _text = value;
                                                    //   });
                                                    // },
                                                  ),
                                                ),
                                                Text('kg',
                                                    style: GoogleFonts.notoSans(
                                                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  child: TextField(
                                                    // autofocus: true,
                                                    // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
                                                    // onChanged: (String value) {
                                                    //   // データが変更したことを知らせる（画面を更新する）
                                                    //   setState(() {
                                                    //     // データを変更
                                                    //     _text = value;
                                                    //   });
                                                    // },
                                                  ),
                                                ),
                                                Text('回',
                                                    style: GoogleFonts.notoSans(
                                                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                                    )
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
                            )
                        );
                      });
                    },
                    label: Text('セットを追加',
                        style: GoogleFonts.notoSans(
                          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                        )
                    ),
                    icon: Icon(Icons.add,
                      color: Color(0xFF0FFCC80),),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFffffff),
                      onPrimary: Color(0xFF000000).withOpacity(0.7),
                      elevation: 0,
                      // shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:github_1/workout_set.dart';
//
//
// class BenchAddPage extends StatefulWidget {
//   @override
//   _BenchAddPageState createState() => _BenchAddPageState();
// }
//
// class _BenchAddPageState extends State<BenchAddPage> {
//   // 入力されたテキストをデータとして持つ
//   String _text = '';
//   List _list = [
//     WorkoutSet(),
//   ];
//
//   // データを元に表示するWidget
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ベンチプレス'),
//         elevation: 0.5,
//         centerTitle: true,
//         backgroundColor: CupertinoColors.white,
//       ),
//         body:Container(
//           margin: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   SizedBox(
//                     width: 350,
//                     height: 30,
//                     child: ElevatedButton(
//                       child: Text('セット追加',
//                         style: TextStyle(fontWeight: FontWeight.bold),),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.orange,
//                         onPrimary: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _list.add(
//                             WorkoutSet(),
//                           );
//                         });
//                       },
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.remove),
//                     onPressed: () {
//                       if (_list.length == 1) {
//                         Fluttertoast.showToast(msg: "これ以上減らせません！！");
//                       } else {
//                         setState(() {
//                           _list.removeAt(_list.length - 1);
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               Flexible(
//                 child: ListView.builder(
//                   itemCount: _list.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return _list[index];
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//       // body: Container(
//       //
//       //   child: Padding(
//       //     padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
//       //     child: ListView.builder(
//       //       itemCount: 1,
//       //       itemBuilder: (context, index) {
//       //         return
//       //
//       //           Card(
//       //           child: TextField(
//       //             decoration: InputDecoration(
//       //               border: InputBorder.none,
//       //             ),
//       //               // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
//       //               onChanged: (String value) {
//       //                 // データが変更したことを知らせる（画面を更新する）
//       //                 setState(() {
//       //                   // データを変更
//       //                   _text = value;
//       //                 });
//       //               },
//       //             ),
//       //           );
//       //       },
//       //     ),
//       //   ),
//       // ),
//
//         floatingActionButton:
//         SizedBox(
//           width: 360,
//           height: 50,
//           child:ElevatedButton(
//             child: const Text('入力完了',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               primary: Colors.orange,
//               onPrimary: Colors.white,
//               shape: const StadiumBorder(),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop(_text);
//             },
//           ),
//         )
//     );
//   }
// }
//
//
