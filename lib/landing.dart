import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:pwpb_gaji_karyawan/details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LandingPage extends StatefulWidget {
  // final List<Map<String, dynamic>> isi;
  final Map<String, dynamic> isi;
  LandingPage({Key key, this.isi}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  List<String> titlenya = ["Dashboard", "Salary", "Profile"];
  List<String> namaBulan = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<Map<String, String>> jsn = widget.isi;
    Map<String, dynamic> jsn = widget.isi["data"][0]["karyawan"];
    List<dynamic> listGaji = widget.isi["data"];
    String tgllahir =
        "${jsn["tanggal_lahir"].substring(0, 2)} ${namaBulan[int.parse(jsn["tanggal_lahir"].substring(2, 4)) - 1]} ${jsn["tanggal_lahir"].substring(4, 8)}";

    String getTglGaji(Map<String, dynamic> pesan) {
      String bln = namaBulan[int.parse(pesan["bulan"]) - 1];
      return "$bln ${pesan["tahun"]}";
    }

    final isiCard = (pesan) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
          leading: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 92,
              minHeight: 92,
              maxWidth: 300,
              maxHeight: 300,
            ),
            child:
                Image.asset("assets/images/moneygold.png", fit: BoxFit.cover),
          ),
          title: Text(getTglGaji(pesan)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/detailgaji', arguments: pesan);
          },
        );
    final cardNya = (pesan) => Card(
          elevation: 5.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white10),
            child: isiCard(pesan),
          ),
        );
    final isiBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return cardNya(index);
        },
      ),
    );
    final gajiNya = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listGaji.length,
        itemBuilder: (BuildContext context, int index) {
          return (listGaji[index]["id_gaji"] == "")
              ? Text("")
              : cardNya(listGaji[index]);
          // return Text("Haii");
        },
      ),
    );
    final dashboard = Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(40),
          // padding: EdgeInsets.fromLTRB(15, 40, 15, 15),
          // child: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     // SizedBox(width: 20.0, height: 100.0),
          //     // Text(
          //     //   "Be",
          //     //   style: TextStyle(fontSize: 20.0),
          //     // ),
          //     // SizedBox(width: 20.0, height: 100.0),
          //     RotateAnimatedTextKit(
          //         totalRepeatCount: -1,
          //         onTap: () {
          //           print("Tap Event");
          //         },
          //         text: ["Hi", "I'm Cortana", "Have Fun"],
          //         textStyle: TextStyle(
          //             fontSize: 45.0, fontFamily: "Baloo", color: Colors.red),
          //         textAlign: TextAlign.start,
          //         alignment:
          //             AlignmentDirectional.topStart // or Alignment.topLeft
          //         ),
          //   ],
          // ),
          child: SizedBox(
            height: 220.0,
            child: Image.asset(
              "assets/images/list.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          child: Card(
            elevation: 10.0,
            color: Colors.blue,
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Hi, ${jsn["nama_karyawan"]} Welcome to Dashboard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 200,
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.orange,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    "/login",
                  );
                },
                child: Text(
                  "Logout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontFamily: "roboto", color: Colors.white),
                ),
              )),
        )
      ],
    ));
    final profile = Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Image.asset(
            "assets/images/profile.png",
            height: 170,
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Text(
            jsn["nama_karyawan"],
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            jsn["jabatan"]["nama_jabatan"],
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.date_range,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("Tanggal Lahir :")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.bubble_chart,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("Tempat Lahir :")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.people,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("Jenis Kelamin :"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.contact_phone,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("No HP :"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.home,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("Alamat :"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("Status :"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.child_care,
                          color: Colors.pink,
                          size: 20.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ),
                      Text("Jumlah Anak :"),
                    ],
                  ),
                  // Text("Tempat Lahir :"),
                  // Text("Jenis Kelamin :"),
                  // Text("No HP :"),
                  // Text("Alamat :"),
                  // Text("Status :"),
                  // Text("Jumlah Anak :"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(tgllahir),
                  Text(jsn["tempat_lahir"]),
                  Text((jsn["jenis_kelamin"] == "L")
                      ? "Laki-Laki"
                      : "Perempuan"),
                  Text(jsn["no_hp"].toString()),
                  Text(
                    jsn["alamat"],
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text((jsn["status"] == "M") ? "Menikah" : "Lajang"),
                  Text(jsn["jml_anak"].toString()),
                ],
              )
            ],
          ),
        )
      ],
    );
    // final profile = Container(
    //     child: Row(
    //   children: <Widget>[
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Column(
    //           children: <Widget>[
    //             Container(
    //               margin: EdgeInsets.only(top: 30),
    //               child: Image.asset(
    //                 "assets/images/anggaprintlogo.jpeg",
    //                 height: 140,
    //                 fit: BoxFit.fitWidth,
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.only(top: 30),
    //               child: Text(
    //                 jsn[0]["nama_karyawan"],
    //                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.only(top: 30),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Text("Tanggal Lahir"),
    //                   Text("Nama"),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ],
    // ));

    final isiAtas = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.blue,
      title: Text(titlenya[_currentIndex]),
      actions: <Widget>[
        // IconButton(
        //   // icon: Icon(Icons.list),
        //   onPressed: () {},
        // )
      ],
      automaticallyImplyLeading: false,
    );

    final isiBodyNya = SizedBox.expand(
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: <Widget>[dashboard, gajiNya, profile],
      ),
    );

    final isiBawah = BottomNavyBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index) {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(title: Text('Home'), icon: Icon(Icons.home)),
        BottomNavyBarItem(
            title: Text('Salary'), icon: Icon(Icons.attach_money)),
        BottomNavyBarItem(
            title: Text('Profile'), icon: Icon(Icons.account_circle)),
      ],
    );

    // final isiBawah = Container(
    //   height: 55.0,
    //   child: BottomAppBar(
    //     color: Colors.black87,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.home, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.account_circle, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.attach_money, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: isiAtas,
      // body: isiBody,
      body: isiBodyNya,
      bottomNavigationBar: isiBawah,
    );
  }
}
