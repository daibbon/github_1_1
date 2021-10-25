import 'package:flutter/material.dart';
import 'chest_page.dart';


Card buildCard(BuildContext context) {
  return Card(
    child: ListTile(
      leading: Icon(Icons.people),
      title: Text("胸"),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChestPage()));
      },
    ),
  );
}








