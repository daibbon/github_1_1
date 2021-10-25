
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  List<Widget> widgetList = [
    Column(
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

        Card(
          child: ListTile(
            leading: Icon(Icons.people),
            title: Text("胸"),
            trailing: Icon(Icons.more_vert),
            // onTap: (){
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) {
            //         return ChestPage();
            //       },
            //     ),
            //   );
            // },
          ),
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 100, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('設定',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 30),)
            ],
          ),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'トレーニング',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '設定',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
