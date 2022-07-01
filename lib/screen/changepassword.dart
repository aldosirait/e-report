import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/user.model.dart';
import 'package:e_report_unika/repository/user.repo.dart';
import 'package:e_report_unika/widgets/buttomnavuser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  final String id;
  final String nama;

  final String imagePic;

  final String np;
  final String password;
  final String role;
  final String prodi;

  const ChangePassword(
      {Key? key,
      required this.id,
      required this.nama,
      required this.imagePic,
      required this.np,
      required this.role,
      required this.prodi,
      required this.password})
      : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController pasLama = TextEditingController();
  TextEditingController pasBaru = TextEditingController();
  TextEditingController confPas = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 167, 19, 19),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 19, 19),
        title: Text(
          'Ganti Password',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 20, right: 20, top: 70),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 235, 165, 165),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: pasLama,
                maxLines: 1,
                enableSuggestions: false,
                obscureText: true,
                autocorrect: false,
                cursorColor: Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                    hintText: 'Password Lama',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 235, 165, 165),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: pasBaru,
                maxLines: 1,
                enableSuggestions: false,
                obscureText: true,
                autocorrect: false,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                    hintText: 'Password Baru',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 235, 165, 165),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: confPas,
                maxLines: 1,
                enableSuggestions: false,
                obscureText: true,
                autocorrect: false,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                    hintText: 'Konfirmasi Password Baru',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                String pl = pasLama.text.trim();
                String pb = pasBaru.text.trim();
                String cpb = confPas.text.trim();
                if (pl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text('Mohon isi password lama',style: GoogleFonts.poppins()),
                  ));
                } else if (pb.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text('Mohon isi password baru',style: GoogleFonts.poppins()),
                  ));
                } else if (cpb.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text('Mohon isi Konfirmasi paswword',style: GoogleFonts.poppins()),
                  ));
                } else if (pb != cpb) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text('Password tidak sama',style: GoogleFonts.poppins()),
                  ));
                } else {
                  QuerySnapshot snap = await FirebaseFirestore.instance
                      .collection("Users")
                      .where('password', isEqualTo: pl)
                      .get();
                  try {
                    if (pl != snap.docs[0]['password']) {
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text('Password salah',style: GoogleFonts.poppins()),
                      ));
                    } else if (pl == snap.docs[0]['password']) {
                      final user = User(
                          id: widget.id,
                          np: widget.np,
                          nama: widget.nama,
                          password: pb,
                          role: widget.role,
                          prodi: widget.prodi,
                          imagePic: widget.imagePic);
                      updateUser(user);
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text('Password Berhasil Diganti',style: GoogleFonts.poppins()),
                      ));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ButtomControler()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("Password Kamu Salah!",style: GoogleFonts.poppins()),
                      ));
                    }
                  } catch (e) {
                    String error = " ";
                    print(e.toString());
                    if (e.toString() ==
                        "Invalid value: Valid value range is empty: 0") {
                      setState(() {
                        error = "Password Kamu Salah!";
                      });
                    } else {
                      setState(() {
                        error = "Password Kamu Salah!";
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error),
                    ));
                  }
                }
              },
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 2,
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: Center(
                  child: Text(
                    "Ganti Password",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 0, 0),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
