import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/post.model.dart';
import 'package:e_report_unika/model/user.model.dart';
import 'package:e_report_unika/repository/posts.repo.dart';
import 'package:e_report_unika/widgets/buttomnavuser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLaporan extends StatefulWidget {
  const AddLaporan({Key? key}) : super(key: key);

  @override
  State<AddLaporan> createState() => _AddLaporanState();
}

class _AddLaporanState extends State<AddLaporan> {
  final _ctrDesc = TextEditingController();
  PlatformFile? pickedFile;
  bool imagepic = false;

  UploadTask? uploadTask;

  String? nama;
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
      nama = snaps.docs[0]['nama'];
      imagePic = snaps.docs[0]['imagePic'];
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    final DateTime now = DateTime.now();

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    String urlDownload = await snapshot.ref.getDownloadURL();
    String desc = _ctrDesc.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mohon isi deskripsi laporan'),
      ));
    } else {
          final sharedPreferences = await SharedPreferences.getInstance();
      final post = Post(
        
          name: nama ?? '',
          np:  UserAuth.np = sharedPreferences.getString("np")!,
          desc: _ctrDesc.text,
          url: urlDownload,
          dataPublished: now.toString(),
          imagePic: imagePic ?? '',
          status: 'Terkirim');

      addPost(post);

      _ctrDesc.text = '';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Berhasil membuat laporan"),
      ));
      setState(() {
        uploadTask = null;
      });
      deletFile();
    }
  }

  Future selectFile() async {
    imagepic = true;
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future deletFile() async {
    imagepic = false;
    final result = await FilePicker.platform.clearTemporaryFiles();
    if (result == null) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Laporan',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 167, 19, 19),
      ),
      backgroundColor: const Color.fromARGB(255, 167, 19, 19),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width / 14),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: Color.fromARGB(255, 0, 0, 0),
                        controller: _ctrDesc,
                        maxLines: 9,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            hintText: 'Apa Yang Terjadi?',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 88, 88, 88),
                                letterSpacing: 1,
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontStyle: FontStyle.italic),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: selectFile,
                              child: imagepic
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.file(
                                          File(pickedFile!.path!),
                                          width: 70,
                                          height: 70,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: deletFile,
                                            child: const Icon(
                                              Icons.delete,
                                              size: 25,
                                            ))
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.squarePlus,
                                          size: 25,
                                        ),
                                        Text(
                                          "  Lampirkan Gambar",
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: 145,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 235, 165, 165),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Text('Batal',
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ButtomControler()));
                  },
                ),
                imagepic
                    ? GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: 150,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: Text('Kirim',
                                style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        onTap: () {
                          uploadFile();
                        },
                      )
                    : GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: 145,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: Text('Kirim',
                                style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        onTap: () async {
                          final sharedPreferences =
                              await SharedPreferences.getInstance();
                          String urlDownload =
                              'https://firebasestorage.googleapis.com/v0/b/eriportunika.appspot.com/o/images.png?alt=media&token=243a9843-c0f7-4b2e-a7b3-fc4cf95b78f9';
                          final DateTime now = DateTime.now();
                          String desc = _ctrDesc.text.trim();
                          if (desc.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar( SnackBar(
                              content: Text('Mohon isi deskripsi laporan',style: GoogleFonts.poppins()),
                            ));
                          } else {
                            final post = Post(
                                name: nama ?? '',
                          np:  UserAuth.np = sharedPreferences.getString("np")!,
                                desc: _ctrDesc.text,
                                url: urlDownload,
                                dataPublished: now.toString(),
                                imagePic: imagePic ?? '',
                                status: 'Terkirim');

                            addPost(post);

                            _ctrDesc.text = '';

                            ScaffoldMessenger.of(context)
                                .showSnackBar( SnackBar(
                              content: Text("Berhasil membuat laporan",style: GoogleFonts.poppins()),
                            ));
                          }
                        },
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
