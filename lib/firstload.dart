import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class FirstLoad extends StatefulWidget {
  FirstLoad({Key key}) : super(key: key);

  @override
  _FirstLoadState createState() => _FirstLoadState();
}

class _FirstLoadState extends State<FirstLoad> {
  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushNamed(
      context,
      "/login",
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // onDoneLoading() async {
    //   Navigator.pushNamed(
    //     context,
    //     "/login",
    //   );
    // }

    return Container(
        child: Scaffold(
            body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 90),
            child: Image.asset(
              "assets/images/anggaprintlogo.jpeg",
              height: 140,
              fit: BoxFit.fitWidth,
            ),
          ),
        ]),
      ],
    )));
  }
}
