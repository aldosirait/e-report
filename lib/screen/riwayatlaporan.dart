import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/model/user.model.dart';
import 'package:e_report_unika/repository/posts.repo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class Riwayatlaporan extends StatefulWidget {
  final nama;

  const Riwayatlaporan({
    Key? key,
    this.nama,
  }) : super(key: key);

  @override
  State<Riwayatlaporan> createState() => _RiwayatlaporanState();
}

class _RiwayatlaporanState extends State<Riwayatlaporan> {
  bool like = false;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Laporan',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 167, 19, 19),
      ),
      backgroundColor: Color.fromARGB(255, 167, 19, 19),
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
                    final DateTime time = DateTime.parse(data['dataPublished']);
                    timeago.setLocaleMessages('id', timeago.IdMessages());
                    final formatted = timeago.format(time, locale: 'id');
                    var _selectedoption2 = data['status'];
                    String nm = widget.nama.toString();
                    if (data['name']
                        .toString()
                        .toLowerCase()
                        .startsWith(nm.toLowerCase())) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  CircleAvatar(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                    ),
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 28, // Image radius
                                                    backgroundImage:
                                                        NetworkImage(
                                                      data['imagePic'],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data['name'],
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        18)),
                                                        Text(
                                                          formatted,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                          ],
                                        )
                                      ],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              StreamBuilder(
                                                  stream: _firestore
                                                      .collection('Posts')
                                                      .doc(data['id'])
                                                      .collection('Likes')
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          snapshot) {
                                                    return MaterialButton(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.thumb_up,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    56,
                                                                    127,
                                                                    235),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          snapshot.hasData
                                                              ? Text(snapshot
                                                                  .data!
                                                                  .docs
                                                                  .length
                                                                  .toString())
                                                              : Container(),
                                                        ],
                                                      ),
                                                      onPressed: () async {
                                                        QuerySnapshot snaps =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Users')
                                                                .where('np',
                                                                    isEqualTo:
                                                                        UserAuth
                                                                            .np)
                                                                .get();

                                                        var name = snaps.docs[0]
                                                            ['nama'];
                                                        if (like == false) {
                                                          setState(() {
                                                            like = true;
                                                          });
                                                          await _firestore
                                                              .collection(
                                                                  'Posts')
                                                              .doc(data['id'])
                                                              .collection(
                                                                  'Likes')
                                                              .doc(name)
                                                              .set({
                                                            'name': name
                                                          });
                                                        } else {
                                                          setState(() {
                                                            like = false;
                                                          });
                                                          await _firestore
                                                              .collection(
                                                                  'Posts')
                                                              .doc(data['id'])
                                                              .collection(
                                                                  'Likes')
                                                              .doc(name)
                                                              .delete();
                                                        }
                                                      },
                                                    );
                                                  }),
                                              StreamBuilder(
                                                  stream: _firestore
                                                      .collection('Posts')
                                                      .doc(data['id'])
                                                      .collection('Comments')
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          snapshot) {
                                                    return MaterialButton(
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.comment),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          snapshot.hasData
                                                              ? Text(snapshot
                                                                  .data!
                                                                  .docs
                                                                  .length
                                                                  .toString())
                                                              : Container()
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        final commentDecoration = InputDecoration(
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255, 99, 3, 3),
                                                            filled: true,
                                                            hintText:
                                                                'Tulis Komentar.....',
                                                            hintStyle:
                                                                GoogleFonts.poppins(
                                                                    color: Color.fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255)),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)));
                                                        final comment =
                                                            TextEditingController();
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Scaffold(
                                                                appBar: AppBar(
                                                                  title: Text(
                                                                      "Komentar"),
                                                                  centerTitle:
                                                                      true,
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          167,
                                                                          19,
                                                                          19),
                                                                ),
                                                                backgroundColor:
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            167,
                                                                            19,
                                                                            19),
                                                                body: SafeArea(
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(20),
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              bottom: 10,
                                                                              left: 10,
                                                                              right: 10),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      CircleAvatar(
                                                                                        child: Container(
                                                                                          alignment: Alignment.bottomRight,
                                                                                        ),
                                                                                        backgroundColor: Colors.white,
                                                                                        radius: 28, // Image radius
                                                                                        backgroundImage: NetworkImage(
                                                                                          data['imagePic'],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 16.0),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              data['name'],
                                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
                                                                                            ),
                                                                                            Text(
                                                                                              formatted,
                                                                                              style: GoogleFonts.poppins(color: Colors.blueAccent, fontSize: 13),
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
                                                                                style: GoogleFonts.poppins(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
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
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                            StreamBuilder(
                                                                                                stream: _firestore.collection('Posts').doc(data['id']).collection('Likes').snapshots(),
                                                                                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                                  return MaterialButton(
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Icon(
                                                                                                          Icons.thumb_up_alt_rounded,
                                                                                                          color: Color.fromARGB(255, 56, 127, 235),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 10,
                                                                                                        ),
                                                                                                        snapshot.hasData ? Text(snapshot.data!.docs.length.toString()) : Container(),
                                                                                                      ],
                                                                                                    ),
                                                                                                    onPressed: () async {
                                                                                                      QuerySnapshot snaps = await FirebaseFirestore.instance.collection('Users').where('np', isEqualTo: UserAuth.np).get();

                                                                                                      var name = snaps.docs[0]['nama'];
                                                                                                      if (like == false) {
                                                                                                        setState(() {
                                                                                                          like = true;
                                                                                                        });
                                                                                                        await _firestore.collection('Posts').doc(data['id']).collection('Likes').doc(name).set({'name': name});
                                                                                                      } else {
                                                                                                        setState(() {
                                                                                                          like = false;
                                                                                                        });
                                                                                                        await _firestore.collection('Posts').doc(data['id']).collection('Likes').doc(name).delete();
                                                                                                      }
                                                                                                    },
                                                                                                  );
                                                                                                }),
                                                                                            StreamBuilder(
                                                                                                stream: _firestore.collection('Posts').doc(data['id']).collection('Comments').snapshots(),
                                                                                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                                  return Row(
                                                                                                    children: [
                                                                                                      const Icon(Icons.comment),
                                                                                                      SizedBox(
                                                                                                        width: 10,
                                                                                                      ),
                                                                                                      snapshot.hasData
                                                                                                          ? Text(
                                                                                                              snapshot.data!.docs.length.toString(),
                                                                                                              style: GoogleFonts.poppins(),
                                                                                                            )
                                                                                                          : Container()
                                                                                                    ],
                                                                                                  );
                                                                                                }),
                                                                                          ]),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        data['status'],
                                                                                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              TextField(
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              color: Colors.white,
                                                                            ),
                                                                            cursorColor:
                                                                                Colors.white,
                                                                            onSubmitted:
                                                                                (a) async {
                                                                              String commen = comment.text.trim();
                                                                              if (commen.isEmpty) {
                                                                                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                                                                  content: Text('Komentar masih kosong',style: GoogleFonts.poppins()),
                                                                                ));
                                                                              } else {
                                                                                QuerySnapshot snaps = await FirebaseFirestore.instance.collection('Users').where('np', isEqualTo: UserAuth.np).get();

                                                                                var name = snaps.docs[0]['nama'];
                                                                                var imagePic = snaps.docs[0]['imagePic'];
                                                                                await _firestore.collection('Posts').doc(data['id']).collection('Comments').add({
                                                                                  'Uploader': name,
                                                                                  'imagePic': imagePic,
                                                                                  'Comment': a,
                                                                                });
                                                                              }
                                                                            },
                                                                            controller:
                                                                                comment,
                                                                            decoration:
                                                                                commentDecoration,
                                                                          ),
                                                                        ),
                                                                        StreamBuilder(
                                                                            stream:
                                                                                _firestore.collection('Posts').doc(data['id']).collection('Comments').snapshots(),
                                                                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                              List<Widget> cards = [];
                                                                              if (snapshot.hasData) {
                                                                                snapshot.data!.docs.forEach((element) {
                                                                                  cards.add(Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                                                    margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              CircleAvatar(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.bottomRight,
                                                                                                ),
                                                                                                backgroundColor: Colors.white,
                                                                                                radius: 28, // Image radius
                                                                                                backgroundImage: NetworkImage(
                                                                                                  element['imagePic'],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left: 13),
                                                                                                child: Text(element['Uploader'],
                                                                                                    style: GoogleFonts.poppins(
                                                                                                      fontSize: 18,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    )),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Align(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(15.0),
                                                                                            child: Text(element['Comment'],
                                                                                                style: GoogleFonts.poppins(
                                                                                                  fontSize: 20,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                )),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ));
                                                                                });
                                                                              }
                                                                              return Column(
                                                                                children: cards,
                                                                              );
                                                                            }),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ));
                                                      },
                                                    );
                                                  }),
                                            ]),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data['status'],
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                    Container(
                                        alignment: Alignment.topRight,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        child: PopupMenuButton(
                                            icon: Icon(Icons.more_vert),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                                      PopupMenuItem(
                                                        child: ListTile(
                                                            title: TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      "tidak");
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
                                                    ])),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                    return Container();
                  });
        },
      ),
    );
  }
}
