import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/post.model.dart';
import 'package:e_report_unika/repository/posts.repo.dart';
import 'package:e_report_unika/repository/user.repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.model.dart';

class UploadPic extends StatefulWidget {
  final id;
  final nama;
  final np;
  final password;
  final role;
  final prodi;
  final idp;
  final namep;
  final descp;
  final urlp;
  final dataPublishedp;
  final imagePicp;
  final statusp;

  final imagePic;
  const UploadPic({
    Key? key,
    this.id,
    this.nama,
    this.np,
    this.imagePic,
    this.password,
    this.role,
    this.prodi,
    this.idp,
    this.namep,
    this.descp,
    this.urlp,
    this.dataPublishedp,
    this.imagePicp,
    this.statusp,
  }) : super(key: key);

  @override
  State<UploadPic> createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {
  PlatformFile? pickedFile;
  bool imagepic = false;

  UploadTask? uploadTask;
  Future uploadFile() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    final DateTime now = DateTime.now();

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    String urlDownload = await snapshot.ref.getDownloadURL();

    final user = User(
        id: widget.id.toString(),
        np: widget.np.toString(),
        nama: widget.nama.toString(),
        password: widget.password.toString(),
        role: widget.role.toString(),
        prodi: widget.prodi.toString(),
        imagePic: urlDownload);
    updateUser(user);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text('Foto Profile berhasil diubah', style: GoogleFonts.poppins()),
    ));
    final QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Posts")
        .where('np', isEqualTo: widget.np.toString())
        .get();

    if (widget.idp == snap.docs[0]['id']) {
      final post = Post(
          np: widget.np.toString(),
          id: widget.idp.toString(),
          name: widget.namep.toString(),
          desc: widget.descp.toString(),
          dataPublished: widget.dataPublishedp.toString(),
          url: widget.urlp.toString(),
          status: widget.statusp.toString(),
          imagePic: urlDownload);
      updatePost(post);
    }

    setState(() {
      uploadTask = null;
    });
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
      backgroundColor: Color.fromARGB(200, 167, 19, 19),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 167, 19, 19),
        title: Text(
          'Ganti Foto Profile',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: selectFile,
              child: Container(
                  child: imagepic
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              child: Center(
                                child: Image.file(
                                  File(pickedFile!.path!),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: deletFile,
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 99, 3, 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Batal',
                                        style: GoogleFonts.poppins(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                                height: 200,
                                width: 200,
                                child: Center(
                                    child: Image.network(widget.imagePic))),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 99, 3, 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Galeri',
                                      style: GoogleFonts.poppins(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        )),
            ),
            SizedBox(
              height: 27,
            ),
            imagepic
                ? GestureDetector(
                    onTap: uploadFile,
                    child: Container(
                      alignment: Alignment.center,
                      height: 48,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Text('Ganti',
                          style: GoogleFonts.poppins(
                              color: Color.fromARGB(255, 12, 12, 12),
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : SizedBox(
                    height: 30,
                  ),
          ],
        ),
      ),
    );
  }
}
