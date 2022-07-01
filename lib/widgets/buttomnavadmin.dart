
import 'package:e_report_unika/screen/allpostadminpage.dart';

import 'package:e_report_unika/screen/alluserspage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ControlerNavAdmin extends StatefulWidget {
  const ControlerNavAdmin({ Key? key }) : super(key: key);

  @override
  State<ControlerNavAdmin> createState() => _ControlerNavAdminState();
}

class _ControlerNavAdminState extends State<ControlerNavAdmin> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  final List<Widget> _screens = [PostPage(),AllUserPage()];

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
                  icon: Icon(FontAwesomeIcons.list, color: Colors.white),
                  label: "Laporan",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.userGroup, color: Colors.white),
                  label: "User",
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

  void onTabClick(int index) {
    _pageController.jumpToPage(index);
  }
}
