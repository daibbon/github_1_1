import 'package:flutter/material.dart';
import 'package:github_1/chest_page.dart';

import 'method.dart';


class MigileftScreen extends StatelessWidget {
  // Todoリストのデータ
  List<String> chestList = [];

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
                  buildCard(context),
                ]
            )
        ),
      );
  }
}



