import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/widgets/buttomnavadmin.dart';
import 'package:e_report_unika/widgets/buttomnavuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 167, 19, 19),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              isKeyboardVisible
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        height: 165,
                        width: 145,
                        child: Image.asset("assets/app_logo.png"),
                      ),
                    ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'E-REPORT UNIKA',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 219, 219, 219)),
                  )),
              const SizedBox(
                height: 35,
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
                  textAlign: TextAlign.center,
                  controller: idController,
                  maxLines: 1,
                  enableSuggestions: false,
                  obscureText: false,
                  autocorrect: false,
                  cursorColor: Color.fromARGB(255, 0, 0, 0),
                  decoration: InputDecoration(
                      // icon: Icon(
                      //   FontAwesomeIcons.user,
                      //   color: Color.fromARGB(255, 255, 255, 255),
                      // ),
                      hintText: 'Username',
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
                  textAlign: TextAlign.center,
                  controller: passController,
                  maxLines: 1,
                  enableSuggestions: false,
                  obscureText: true,
                  autocorrect: false,
                  cursorColor: const Color.fromARGB(255, 0, 0, 0),
                  decoration: const InputDecoration(
                      // icon: Icon(
                      //   FontAwesomeIcons.lock,
                      //   color: Color.fromARGB(255, 255, 255, 255),
                      // ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  String np = idController.text.trim();
                  String password = passController.text.trim();
                  String role = "Admin";
                  if (np.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      content: Text('ID Masih kosong!',style: GoogleFonts.poppins()),
                    ));
                  } else if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      content: Text('Password Masih kosong!!',style: GoogleFonts.poppins()),
                    ));
                  } else {
                    QuerySnapshot snap = await FirebaseFirestore.instance
                        .collection("Users")
                        .where('np', isEqualTo: np)
                        .get();

                    try {
                      if (password == snap.docs[0]['password'] &&
                          role != snap.docs[0]['role']) {
                        sharedPreferences =
                            await SharedPreferences.getInstance();
                        final SharedPreferences prefs = await _prefs;
                        prefs.setBool("isLoggedIn", true);
                        sharedPreferences
                            .setString(
                          "np",
                          np,
                        )
                            .then((_) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ButtomControler()));
                        });
                      } else if (password == snap.docs[0]['password'] &&
                          role == snap.docs[0]['role']) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ControlerNavAdmin()));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar( SnackBar(
                          content: Text("ID atau Password Kamu Salah!",style: GoogleFonts.poppins()),
                        ));
                      }
                    } catch (e) {
                      String error = " ";
                      print(e.toString());
                      if (e.toString() ==
                          "Invalid value: Valid value range is empty: 0") {
                        setState(() {
                          error = "ID atau Password Kamu Salah!";
                        });
                      } else {
                        setState(() {
                          error = "ID atau Password Kamu Salah!";
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error),
                      ));
                    }
                  }
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ButtomControler()));
                },
                child: Container(
                  height: 50,
                  width: 20,
                  margin: const EdgeInsets.only(
                      bottom: 20, left: 20, right: 20, top: 20),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      )),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
