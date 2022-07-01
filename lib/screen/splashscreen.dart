import 'dart:async';

import 'package:e_report_unika/main.dart';
import 'package:e_report_unika/screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duracion = const Duration(seconds: 2);
    return Timer(duracion, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const KeyboardVisibilityProvider(child: LoginScreen())
    ));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(200, 167, 19, 19),
        body: Center(
          child: SizedBox(
            height: 120,
            width: 100,
            child: Image.asset("assets/app_logo.png"),
          ),
        ));
  }
}
