import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pwpb_gaji_karyawan/details.dart';
import 'package:pwpb_gaji_karyawan/firstload.dart';
import 'package:pwpb_gaji_karyawan/landing.dart';
import 'package:pwpb_gaji_karyawan/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;
// import "landing.dart";
// import "details.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home: LengkapGaji(isi: {"aaa": "qqqq"}),
      home: MyLoginPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return PageTransition(
                child: MyLoginPage(),
                type: PageTransitionType.upToDown,
                settings: settings);
            break;
          case '/dashboard':
            return PageTransition(
                child: LandingPage(isi: settings.arguments),
                type: PageTransitionType.scale,
                settings: settings);
            break;
          case '/detailgaji':
            return PageTransition(
                child: LengkapGaji(isii: settings.arguments),
                type: PageTransitionType.rightToLeft,
                settings: settings);
            break;
          default:
            return null;
        }
      },
      // home: MyHomePage(title: 'Ayo Cek Gajian Kamu'),
      // home: DetailsGaji(isi: {"employee_age": "222"}),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: "roboto", fontSize: 20.0);
  TextEditingController txtusername = new TextEditingController();
  TextEditingController txtpassword = new TextEditingController();
  Map<String, String> dt = {};

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

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.green,
          // color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  List<Map<String, String>> parseHTTP(List<dynamic> a) {
    List<Map<String, String>> isi = [];
    for (var i = 0; i < a.length; i++) {
      isi.add(jsonDecode(a[i]));
    }
    return isi;
  }

  Future cekLogin() async {
    _showLoading();
    var isi = (txtusername.text != "") ? txtusername.text : "1";
    var url = "https://myapisgg.000webhostapp.com/gajikaryawanapis.php";
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
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       // builder: (context) => DetailsGaji(isi: jsonDecode(response.body)),
        //       builder: (context) =>
        //           LandingPage(isi: jsonDecode(response.body)),
        //     ));
      } else if (response.statusCode == 503) {
        _showPesanAlert();
      } else {
        _showPesanAlertErrServer();
        // dt = jsonDecode(response.body);
      }
    }).timeout(const Duration(seconds: 15));
  }

  @override
  Widget build(BuildContext context) {
    FocusNode afterUsername = new FocusNode();

    final fldusername = TextField(
      controller: txtusername,
      onSubmitted: (String value) {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(afterUsername);
      },
      // obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final fldpassword = TextField(
      controller: txtpassword,
      focusNode: afterUsername,
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
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          // _showPesanAlert();
          spinkit;
          cekLogin();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => DetailsGaji(
          //           isi: {"satu": "ini pesan satu", "dua": "ini pesan dua"}),
          //     ));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => DetailsGaji(),
          //         settings: RouteSettings(arguments: )));
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 170.0,
                  child: Image.asset(
                    "assets/images/moneygold.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text("Ayoo Cek Gaji Kamu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.deepOrange)),
                SizedBox(
                  height: 45.0,
                ),
                fldusername,
                SizedBox(
                  height: 25.0,
                ),
                fldpassword,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class DetailsGaji extends StatelessWidget {
  final Map<String, dynamic> isi;
  const DetailsGaji({Key key, this.isi}) : super(key: key);
  String toCurrencyFormat(String isi) {
    return (FlutterMoneyFormatter(amount: double.parse(isi))
            .output
            .withoutFractionDigits)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final String jabatan =
        "(${isi["nama_jabatan"].toString()}) ${toCurrencyFormat(isi["jml_gaji_pokok"].toString())}";
    final String upahLembur =
        "${toCurrencyFormat(isi["upah_lembur"].toString())} x (${isi["jml_lembur"]})";
    final String statusnya =
        isi["status"].toString() == "M" ? "Menikah" : "Lajang";
    final int jmlTunjangan = int.parse(isi["jml_tunjangan"].toString());
    final int gajiPokok = int.parse(isi["jml_gaji_pokok"].toString());
    final String tunjanganIstri = isi["status"].toString() == "M"
        ? toCurrencyFormat((gajiPokok * 0.20).toString())
        : "0";
    final String tunjanganAnak = isi["status"].toString() == "M"
        ? toCurrencyFormat((jmlTunjangan - (gajiPokok * 0.20)).toString())
        : "0";
    final String gajiKotor = toCurrencyFormat(isi["gajiKotor"].toString());
    final String pajak = toCurrencyFormat(isi["pajak"].toString());
    final String lembur = toCurrencyFormat(
        (int.parse(isi["upah_lembur"].toString()) *
                int.parse(isi["jml_lembur"].toString()))
            .toString());
    final String gajiBersih =
        "Rp. ${toCurrencyFormat(isi["gajiBersih"].toString())}";

    // final isi = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Gaji'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              child: Text(
                "MR. GG",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Jabatan"),
                    Text("Upah Lembur"),
                    Text("Status"),
                    Text("Tunjangan Istri"),
                    Text("Tunjangan Anak"),
                    Text("Jumlah Tunjangan"),
                    Text("Gaji Kotor"),
                    Text("Pajak 10%"),
                    Text("Tambahan Lembur"),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Gaji Bersih",
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text("Desember 2019"),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(jabatan),
                    Text(upahLembur),
                    Text(statusnya),
                    Text(tunjanganIstri),
                    Text(tunjanganAnak),
                    Text(
                      toCurrencyFormat(jmlTunjangan.toString()),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(gajiKotor),
                    Text(pajak),
                    Text(lembur),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        gajiBersih,
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text(""),
                    ),
                  ],
                )
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 10.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       SizedBox(
            //         height: 120.0,
            //         child: Image.asset(
            //           "assets/images/anggaprintlogo.jpeg",
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: SizedBox(
                height: 180.0,
                child: Image.asset(
                  "assets/images/bank.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Material(
                  //   elevation: 2.0,
                  //   borderRadius: BorderRadius.circular(30.0),
                  //   color: Colors.green,
                  //   child: MaterialButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: Container(
                  //         width: 180.0,
                  //         child: Text(
                  //           "Kembali",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       )),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
