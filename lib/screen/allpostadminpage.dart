import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/post.model.dart';
import 'package:e_report_unika/repository/posts.repo.dart';
import 'package:e_report_unika/screen/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/user.model.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String desc = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 167, 19, 19),
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 167, 19, 19),
            centerTitle: true,
            title: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 40,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 235, 165, 165),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      desc = val;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Cari laporan...',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 88, 88, 88),
                        letterSpacing: 1,
                        fontFamily: 'Poppins',
                        fontSize: 17,
                      ),
                      border: InputBorder.none),
                ),
              ),
            )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Posts')
              .orderBy('dataPublished', descending: true)
              .snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      final DateTime time =
                          DateTime.parse(data['dataPublished']);
                      timeago.setLocaleMessages('id', timeago.IdMessages());
                      final formatted = timeago.format(time, locale: 'id');
                      var _selectedoption2 = data['status'];
                      if (desc.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                        ),
                                        backgroundColor: Colors.white,
                                        radius: 24, // Image radius
                                        backgroundImage: NetworkImage(
                                          data['imagePic'],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['name'],
                                              style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              formatted,
                                              style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                data['desc'],
                                style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Center(child: Image.network(data['url'])),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 208, 208, 208),
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedoption2,
                                      items: <String>[
                                        'Terkirim',
                                        'Diproses',
                                        'Selesai'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            margin: const EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                value,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
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
                                          final post = Post(
                                            
                                            id: data['id'],
                                            dataPublished:
                                                data['dataPublished'],
                                            desc: data['desc'],
                                            imagePic: data['imagePic'],
                                            name: data['name'],
                                            status: _selectedoption2,
                                            url: data['url'],
                                                      np:  data['np'],
                                          );
                                          updatePost(post);
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topRight,
                                      width: MediaQuery.of(context).size.width /
                                          4.1,
                                      child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder:
                                              (BuildContext context) =>
                                                  <PopupMenuEntry>[
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                          title: TextButton(
                                                              onPressed: () {
                                                                  Navigator.pop(context, "Tidak");
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                              title: Text('Kamu Yakin Ingin Menghapus Laporan ini?' ,style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),),
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
                                                                                  onPressed: () {
                                                                                    deletePost(data['id']);
                                                                                    Navigator.pop(context, "Ya");
                                                                                  },
                                                                                  child: Text("Ya",
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ));
                                                              },
                                                              child: Text(
                                                                "Hapus",
                                                                style: GoogleFonts.poppins(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    fontSize:
                                                                        16),
                                                              ))),
                                                    ),
                                                  ]))
                                ],
                              )
                            ],
                          ),
                        );
                      }
                      if (data['desc']
                              .toString()
                              .toLowerCase()
                              .startsWith(desc.toLowerCase()) ||
                          data['nama']
                              .toString()
                              .toLowerCase()
                              .startsWith(desc.toLowerCase()) ||
                          data['np']
                              .toString()
                              .toLowerCase()
                              .startsWith(desc.toLowerCase()) ||
                          data['role']
                              .toString()
                              .toLowerCase()
                              .startsWith(desc.toLowerCase())) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                        ),
                                        backgroundColor: Colors.white,
                                        radius: 24, // Image radius
                                        backgroundImage: NetworkImage(
                                          data['imagePic'],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['name'],
                                              style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              formatted,
                                              style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                data['desc'],
                                style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Center(child: Image.network(data['url'])),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 235, 165, 165),
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedoption2,
                                      items: <String>[
                                        'Terkirim',
                                        'Diproses',
                                        'Selesai'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.6,
                                            margin: const EdgeInsets.all(10),
                                            child: Center(
                                              child: Text(
                                                value,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val2)  {
                                          
                                        setState(() {
                                          _selectedoption2 = val2!;
                                          final post = Post(
                                            
                                            id: data['id'],
                                            np:data['np'],
                                            dataPublished:
                                            data['dataPublished'],
                                            desc: data['desc'],
                                            imagePic: data['imagePic'],
                                            name: data['name'],
                                            status: _selectedoption2,
                                            url: data['url'],
                                          );
                                          updatePost(post);
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topRight,
                                      width: MediaQuery.of(context).size.width /
                                          4.1,
                                      child: PopupMenuButton(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder:
                                              (BuildContext context) =>
                                                  <PopupMenuEntry>[
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                          title: TextButton(
                                                              onPressed: () {
                                                                 Navigator.pop(context, "Ya");
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                              title: Text('Kamu Yakin Ingin Menghapus Laporan ini?', style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),),
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
                                                                                  onPressed: () {
                                                                                    deletePost(data['id']);
                                                                                    Navigator.pop(context, "Ya");
                                                                                  },
                                                                                  child: Text("Ya",
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ));
                                                              },
                                                              child: Text(
                                                                "Hapus",
                                                                style: GoogleFonts.poppins(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    fontSize:
                                                                        14),
                                                              ))),
                                                    ),
                                                  ]))
                                ],
                              )
                            ],
                          ),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
