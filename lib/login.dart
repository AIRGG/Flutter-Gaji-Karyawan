import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextStyle style = TextStyle(fontFamily: "roboto", fontSize: 20.0);
  TextEditingController txtusername = new TextEditingController();
  TextEditingController txtpassword = new TextEditingController();
  Map<String, String> dt = {};

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitThreeBounce(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            // color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );

    void _showPesanAlert() {
      Alert(
        context: context,
        type: AlertType.error,
        title: "GAGAL LOGIN",
        desc: "Username atau Password Salah!!!",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }

    void _showPesanAlertErrServer() {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Kesalahan SERVER",
        desc: "Harap Hubungi Developer Anda!!",
        buttons: [
          DialogButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }

    void _showLoading() {
      Alert(
          context: context,
          title: "Tunggu Bentar Boyy..",
          content: spinkit,
          buttons: [
            DialogButton(
              child: Text("Loading..", style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Navigator.pop(context);
              },
            )
          ]).show();
    }

    Future cekLogin() async {
      _showLoading();
      var isi = (txtusername.text != "") ? txtusername.text : "1";
      var url = "https://ggapis.herokuapp.com/angga/login";
      // var url = "http://192.168.43.59:3000/angga/login";
      // http.Response response = await http.get(url);
      http.post(url, body: {
        "username": txtusername.text,
        "password": txtpassword.text,
        "aksi": "login"
      }).then((response) {
        Navigator.pop(context);
        print(response.statusCode);
        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, "/dashboard",
              arguments: jsonDecode(response.body));
        } else if (response.statusCode == 503) {
          _showPesanAlert();
        } else {
          _showPesanAlertErrServer();
        }
      }).timeout(const Duration(seconds: 15));
    }

    final fldusername = TextField(
      controller: txtusername,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final fldpassword = TextField(
      controller: txtpassword,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(50.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          cekLogin();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final myBody = ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                  child: SizedBox(
                    height: 150.0,
                    child: Image.asset(
                      "assets/images/money.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: Text("Ayoo Cek Gaji Kamu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.deepOrange)),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: fldusername),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: fldpassword),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0), child: loginButon),
            Padding(
                // DateFormat.y().format(DateTime.now())
                padding: EdgeInsets.all(45),
                child: Text(String.fromCharCodes(Runes(
                    '${DateTime.now().year} \u00a9 Author\'s Mr. GG \u{1f60e}')))),
          ],
        )
      ],
    );

    return Container(
      child: Scaffold(
        body: myBody,
      ),
    );
  }
}
