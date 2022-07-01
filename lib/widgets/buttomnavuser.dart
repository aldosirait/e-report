import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_report_unika/screen/addlaporan.dart';
import 'package:e_report_unika/screen/allpostuserpage.dart';

import 'package:e_report_unika/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/user.model.dart';

class ButtomControler extends StatefulWidget {
  const ButtomControler({Key? key}) : super(key: key);

  @override
  State<ButtomControler> createState() => _ButtomControlerState();
}

class _ButtomControlerState extends State<ButtomControler> {
  late PageController _pageController;
  late String nama;
  late String np;
  late String role;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  final List<Widget> _screens = [PostUser(), Profile()];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 167, 19, 19),

      bottomNavigationBar: Container(
          child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 99, 3, 3),
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          currentIndex: _currentIndex,
          onTap: onTabClick,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.houseChimney, color: Colors.white),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 37,
              ),
              label: "Profile",
            ),
          ],
        ),
      )),
      // BottomNavigationBar(

      //     items: const [

      //     ]),
      body: PageView(
        children: _screens,
        controller: _pageController,
        onPageChanged: pageChanged,
      ),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabClick(int index) async {
    _pageController.jumpToPage(index);
  }
}
