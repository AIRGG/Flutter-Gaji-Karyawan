import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class LengkapGaji extends StatelessWidget {
  final Map<String, dynamic> isii;
  const LengkapGaji({Key key, this.isii}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> isi = isii;
    String toCurrencyFormat(String isi) {
      return (FlutterMoneyFormatter(amount: double.parse(isi))
              .output
              .withoutFractionDigits)
          .toString();
    }

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

    final String jabatan =
        "${toCurrencyFormat(isi["karyawan"]["jabatan"]["jml_gaji_pokok"].toString())} (${isi["karyawan"]["jabatan"]["nama_jabatan"].toString()})";
    final String upahLembur =
        "${toCurrencyFormat(isi["karyawan"]["jabatan"]["upah_lembur"].toString())} x (${isi["jml_lembur"]})";
    final String statusnya =
        isi["karyawan"]["status"].toString() == "M" ? "Menikah" : "Lajang";
    final int jmlTunjangan = int.parse(isi["jml_tunjangan"].toString());
    final int gajiPokok =
        int.parse(isi["karyawan"]["jabatan"]["jml_gaji_pokok"].toString());
    final String tunjanganIstri = isi["karyawan"]["status"].toString() == "M"
        ? toCurrencyFormat((gajiPokok * 0.20).toString())
        : "0";
    final String tunjanganAnak = isi["karyawan"]["status"].toString() == "M"
        ? toCurrencyFormat((jmlTunjangan - (gajiPokok * 0.20)).toString())
        : "0";
    final String gajiKotor = toCurrencyFormat(isi["gajiKotor"].toString());
    final String pajak = toCurrencyFormat(isi["pajak"].toString());
    final String lembur = toCurrencyFormat(
        (int.parse(isi["karyawan"]["jabatan"]["upah_lembur"].toString()) *
                int.parse(isi["jml_lembur"].toString()))
            .toString());
    final String gajiBersih =
        "Rp. ${toCurrencyFormat(isi["gajiBersih"].toString())}";
    final String blnTahun =
        "${namaBulan[int.parse(isi["bulan"]) - 1]} ${isi["tahun"]}";

    final isiAtas = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.blue,
      title: Text("Details Salary"),
      actions: <Widget>[
        // IconButton(
        //   // icon: Icon(Icons.list),
        //   onPressed: () {},
        // )
      ],
    );
    final isiBody = Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Container(
                  height: 320,
                  width: 300,
                  padding: EdgeInsets.all(17),
                  decoration: BoxDecoration(color: Colors.white10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "DETAILS SALARY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Text("Tambahan Lembur"),
                                Text("Gaji Kotor"),
                                Text("Pajak 10%"),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Gaji Bersih",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 24.0),
                                  child: Text(blnTahun),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  jabatan,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  upahLembur,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  statusnya,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  tunjanganIstri,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  tunjanganAnak,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  toCurrencyFormat(jmlTunjangan.toString()),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  lembur,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  gajiKotor,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(pajak),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    gajiBersih,
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 24.0),
                                  child: Text(""),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: 150.0,
                  child: Image.asset(
                    "assets/images/bank.png",
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: isiAtas,
      body: isiBody,
    );
  }
}
