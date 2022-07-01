import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/main.dart';
import 'package:e_report_unika/model/user.model.dart';
import 'package:e_report_unika/repository/user.repo.dart';
import 'package:e_report_unika/screen/adduser.dart';
import 'package:e_report_unika/screen/loginscreen.dart';
import 'package:e_report_unika/screen/updateuser.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AllUserPage extends StatefulWidget {
  const AllUserPage({Key? key}) : super(key: key);

  @override
  State<AllUserPage> createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {
  String nama = "";
  @override
  Widget build(BuildContext context) {
    List<User> allusers = [];

    return Scaffold(
        appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 14),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Kamu Yakin Ingin Logout?', style: GoogleFonts.poppins(
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
                                      Navigator.pop(context, "Ya");
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
                    icon: Icon(
                      Icons.logout_outlined,
                      size: 35,
                    )),
              )
            ],
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
                      nama = val;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Cari user...',
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 99, 3, 3),
          child: Icon(
            FontAwesomeIcons.plus,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddUser()));
          },
        ),
        backgroundColor: Color.fromARGB(255, 167, 19, 19),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .orderBy('np')
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

                      if (nama.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                    ),
                                    backgroundColor: Colors.white,
                                    radius: 38, // Image radius
                                    backgroundImage:
                                        NetworkImage(data['imagePic']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['nama'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          data['np'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          data['role'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateUser(
                                                      id: data['id'],
                                                      nama: data['nama'],
                                                      imagePic: data['imagePic'],
                                                    )));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        size: 25,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      'Kamu Yakin Ingin Menghapus ${data['nama']}?',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing:
                                                                  1)),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Color.fromARGB(
                                                            255, 99, 3, 3),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, "Tidak");
                                                      },
                                                      child: Text("Tidak",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Color.fromARGB(
                                                            255, 99, 3, 3),
                                                      ),
                                                      onPressed: () {
                                                        deleteUser(data['id']);
                                                        Navigator.pop(
                                                            context, "Ya");
                                                      },
                                                      child: Text("Ya",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                    ),
                                                  ],
                                                ));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.trash,
                                        size: 24,
                                      )),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                      if (data['nama']
                              .toString()
                              .toLowerCase()
                              .startsWith(nama.toLowerCase()) ||
                          data['np']
                              .toString()
                              .toLowerCase()
                              .startsWith(nama.toLowerCase()) ||
                          data['role']
                              .toString()
                              .toLowerCase()
                              .startsWith(nama.toLowerCase())) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                    ),
                                    backgroundColor: Colors.white,
                                    radius: 38, // Image radius
                                    backgroundImage:
                                        NetworkImage(data['imagePic']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['nama'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          data['np'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          data['role'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateUser(
                                                      id: data['id'],
                                                      nama: data['nama'],
                                                       imagePic: data['imagePic'],
                                                    )));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        size: 25,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      'Kamu Yakin Ingin Menghapus ${data['nama']}?', style: GoogleFonts.poppins(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, "Tidak");
                                                      },
                                                      child: Text("Tidak"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        deleteUser(data['id']);
                                                        Navigator.pop(
                                                            context, "Ya");
                                                      },
                                                      child: Text("Ya"),
                                                    ),
                                                  ],
                                                ));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.trash,
                                        size: 24,
                                      )),
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

        // stream: FirebaseFirestore.instance
        //     .collection('Users')
        //     .orderBy('nama')
        //     .snapshots(),
        // builder: (context, snp) {
        //   if (snp.hasError) {
        //     return Center(
        //       child: Text('Error'),
        //     );
        //   }
        //   if (snp.hasData) {
        //     allusers = snp.data!.docs
        //         .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
        //         .toList();
        //     return  ListView.builder(
        //   itemCount: allusers.length,
        //   itemBuilder: (context, index) {
        

        //     return Container(
        //       padding: EdgeInsets.all(10),
        //       margin: EdgeInsets.only(left: 12, right: 12,top: 10,),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //           color: Color.fromARGB(255, 255, 255, 255),
        //           ),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Row(
        //             children: [
        //               CircleAvatar(

        //                child: Container(
                      
        //                  alignment: Alignment.bottomRight,
        //                 ),
        //               backgroundColor: Colors.white,
        //               radius: 38, // Image radius
        //               backgroundImage: NetworkImage( allusers[index].imagePic),
        //         ),
        //               Padding(
        //                 padding: const EdgeInsets.only(left: 16.0),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
                            
        //                       allusers[index].nama,
        //                       style: GoogleFonts.poppins(
        //                           fontSize: 20,
        //                           fontWeight: FontWeight.w600,
                                   
        //                           ),
        //                     ),
        //                     Text(
        //                       allusers[index].np,
        //                       style: GoogleFonts.poppins(
        //                           fontSize: 16,
        //                           fontWeight: FontWeight.normal, 
        //                           ),
        //                     ),
        //                     Text(
        //                       allusers[index].role,
        //                       style: GoogleFonts.poppins(
        //                           fontSize: 13,
        //                           fontWeight: FontWeight.normal, 
        //                           ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               IconButton(
        //                   onPressed: () {
                          
        //                          Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => UpdateUser(id:allusers[index].id,nama:allusers[index].nama ,)
        //               )
        //                          );
        //                   },
        //                   icon: Icon(
        //                     FontAwesomeIcons.penToSquare,
        //                     size: 25,
        //                   )),
        //               IconButton(
        //                   onPressed: () {
        //                     showDialog(
        //                         context: context,
        //                         builder: (context) => AlertDialog(
        //                               title: Text(
        //                                   'Kamu Yakin Ingin Menghapus ${allusers[index].nama}?'),
        //                               actions: [
        //                                 ElevatedButton(
        //                                   onPressed: () {
        //                                     Navigator.pop(context, "Tidak");
        //                                   },
        //                                   child: Text("Tidak"),
        //                                 ),
        //                                 ElevatedButton(
        //                                   onPressed: () {
        //                                     deleteUser(allusers[index].id);
        //                                     Navigator.pop(context, "Ya");
        //                                   },
        //                                   child: Text("Ya"),
        //                                 ),
        //                               ],
        //                             ));
        //                   },
        //                   icon: Icon(
        //                     FontAwesomeIcons.trash,
        //                     size: 24,
        //                   )),
        //             ],
        //           )
        //         ],
        //       ),
        //     );

          // });
          // } else {
          //   return Center(
          //       child: CircularProgressIndicator(
          //     color: Colors.white,
          //   ));
          // }
