import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/main.dart';

import 'package:e_report_unika/screen/RiwayatLaporan.dart';
import 'package:e_report_unika/screen/changepassword.dart';

import 'package:e_report_unika/screen/uploadpic.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.model.dart';
import '../repository/user.repo.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String id;

  late String password;

  String? nama;

  String? role;
  String? prodi;
  String? imagePic;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection('Users')
        .where('np',
            isEqualTo: UserAuth.np = sharedPreferences.getString("np")!)
        .get();
    setState(() {
      id = snaps.docs[0]['id'];
      nama = snaps.docs[0]['nama'];
      role = snaps.docs[0]['role'];
      prodi = snaps.docs[0]['prodi'];
      imagePic = snaps.docs[0]['imagePic'];
      password = snaps.docs[0]['password'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 19, 19),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 65,
              ),
              Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadPic(
                              id: id,
                              imagePic: imagePic ?? '',
                              nama: nama ?? '',
                              password: password,
                              np: UserAuth.np,
                              role: role ?? '',
                              prodi: prodi ?? '')));
                },
                child: CircleAvatar(
                  child: Container(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        FontAwesomeIcons.folderPlus,
                        size: 25,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )),
                  backgroundColor: Colors.white,
                  radius: 70, // Image radius
                  backgroundImage: NetworkImage(
                    imagePic ?? '',
                  ),
                ),
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      nama ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      UserAuth.np,
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 221, 221, 221)),
                    ),
                    Text(
                      prodi ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 221, 221, 221)),
                    ),
                    Text(
                      role ?? '',
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 221, 221, 221)),
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 99, 3, 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: Text('Ganti Password',
                              style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePassword(
                                      id: id,
                                      password: password,
                                      nama: nama ?? '',
                                      np: UserAuth.np,
                                      prodi: prodi ?? '',
                                      role: role ?? '',
                                      imagePic: imagePic ?? '',
                                    )));
                      },
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 99, 3, 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: Text('Riwayat Laporan',
                              style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Riwayatlaporan(nama: nama ?? '')));
                      },
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                          child: Text('Logout',
                              style: GoogleFonts.poppins(
                                  color: Color.fromARGB(255, 12, 12, 12),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Kamu Yakin Ingin Logout?'),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 99, 3, 3),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, "Tidak");
                                      },
                                      child: Text("Tidak",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromARGB(255, 99, 3, 3),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context, "Ya");
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.clear();

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthCheck()));
                                      },
                                      child: Text("Ya",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ],
                                ));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
