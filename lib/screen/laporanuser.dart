import 'package:e_report_unika/screen/addlaporan.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 99, 3, 3),
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddLaporan()));
        },
      ),
      backgroundColor: Color.fromARGB(255, 167, 19, 19),
      body: Center(child: Text("data")),
    );
  }
}
