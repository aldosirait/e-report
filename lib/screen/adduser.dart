import 'dart:ui';

import 'package:e_report_unika/widgets/buttomnavadmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/user.model.dart';
import '../repository/user.repo.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _ctrNp = TextEditingController();
  final _ctrNama = TextEditingController();
  final _ctrpass = TextEditingController();
  var _selectedoption = 'Mahasiswa';
  var _selectedoption2 = 'Teknik Informatika';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 19, 19),
      appBar: AppBar(
        title: Text(
          'Tambah User',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 167, 19, 19),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 12),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 235, 165, 165),
            ),
            child: TextField(
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              controller: _ctrNama,
              maxLines: 1,
              enableSuggestions: false,
              textAlign: TextAlign.center,
              autocorrect: false,
              cursorColor: Color.fromARGB(255, 0, 0, 0),
              decoration: const InputDecoration(
                  hintText: 'Nama',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 88, 88, 88),
                    letterSpacing: 1,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 235, 165, 165),
            ),
            child: TextField(
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              textAlign: TextAlign.center,
              controller: _ctrNp,
              maxLines: 1,
              enableSuggestions: false,
              obscureText: false,
              autocorrect: false,
              cursorColor: const Color.fromARGB(255, 0, 0, 0),
              decoration: const InputDecoration(
                  hintText: 'NPM / NIDN',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 88, 88, 88),
                    letterSpacing: 1,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 235, 165, 165),
            ),
            child: TextField(
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(15)],
              textAlign: TextAlign.center,
              controller: _ctrpass,
              maxLines: 1,
              enableSuggestions: false,
              obscureText: false,
              autocorrect: false,
              cursorColor: Color.fromARGB(255, 0, 0, 0),
              decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 88, 88, 88),
                    letterSpacing: 1,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 235, 165, 165),
            ),
            child: DropdownButton<String>(
              value: _selectedoption,
              items: <String>['Mahasiswa', 'Dosen', 'Staff', 'Admin']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.5,
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedoption = val!;
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 235, 165, 165),
            ),
            child: DropdownButton<String>(
              value: _selectedoption2,
              items: <String>[
                'Teknik Informatika',
                'Sistem Informasi',
                'Ilmu Hukum',
                'Manejemen',
                'Akuntasi',
                'Agribisnis',
                'Agroteknologi',
                'THP',
                'Sastra Inggris',
                'Arsitektur',
                'Teknik Sipil',
                'PGSD',
                'P.Matematika',
                'P.Bahasa Inggris',
                'Sastra Indonesia',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.6,
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val2) {
                setState(() {
                  _selectedoption2 = val2!;
                });
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              String np = _ctrNp.text.trim();
              String nama = _ctrNama.text.trim();
              String password = _ctrpass.text.trim();
              if (np.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text('NPM/NIDN masih kosong!',style: GoogleFonts.poppins()),
                ));
              } else if (nama.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text('Nama masih kosong!!',style: GoogleFonts.poppins()),
                ));
              } else if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text('Password Masih kosong!!',style: GoogleFonts.poppins()),
                ));
              } else {
                final user = User(
                    np: _ctrNp.text,
                    nama: _ctrNama.text,
                    password: _ctrpass.text,
                    role: _selectedoption.toString(),
                    prodi: _selectedoption2.toString(),
                    imagePic:
                        'https://firebasestorage.googleapis.com/v0/b/eriportunika.appspot.com/o/user.png?alt=media&token=3b19fc14-40bd-4e9a-93aa-6597e804382b');

                addUser(user);
                _ctrNp.text = '';
                _ctrNama.text = '';
                _ctrpass.text = '';
                _selectedoption = 'Mahasiswa';
                _selectedoption2 = 'Teknik Informatika';

                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text('User berhasil dibuat',style: GoogleFonts.poppins()),
                ));
              }
            },
            child: Container(
              height: 48,
              width: MediaQuery.of(context).size.width / 1.8,
              // padding: const EdgeInsets.only(bottom: 7, top: 7, left: 7, right: 7),
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  )),
              child: Center(
                child: Text(
                  "Tambah",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
