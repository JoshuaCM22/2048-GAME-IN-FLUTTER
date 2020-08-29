import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('2048: About'),
        ),
        body: body);
  }
}

final descriptionText = Padding(
  padding: EdgeInsets.all(0),
  child: Text(
    'Hi, I am Joshua C. Magoliman. The developer of this game.',
    style: TextStyle(fontSize: 17.0, color: Colors.black),
  ),
);

final body = Container(
  padding: EdgeInsets.all(45.0),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [
      Colors.white,
      Colors.white,
    ]),
  ),
  child: Column(
    children: <Widget>[
      Center(
        child: Container(
          height: 230,
          width: 240,
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 72.0,
            backgroundImage: AssetImage('assets/images/me.jpg'),
          ),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      descriptionText,
    ],
  ),
);
