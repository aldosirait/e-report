
import 'package:e_report_unika/model/user.model.dart';
import 'package:e_report_unika/screen/loginscreen.dart';
import 'package:e_report_unika/screen/splashscreen.dart';
import 'package:e_report_unika/widgets/buttomnavuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      theme: ThemeData(


        primaryColor: const Color.fromARGB(255, 167, 19, 19),
      ),
       home:  const KeyboardVisibilityProvider(child: AuthCheck())
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({ Key? key }) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable=false;
 
  late SharedPreferences sharedPreferences;
  @override
  
  void initState() {
    super.initState();
    _getCurrentUser();
 
  }
  
  void _getCurrentUser() async{
    sharedPreferences = await SharedPreferences.getInstance();
    try{
      if(sharedPreferences.getString("np") != null){
        setState(() {
         UserAuth.np=  sharedPreferences.getString("np")!;
          userAvailable =true;
        });
      } 
    }catch(e){
         setState(() {
          userAvailable =false;
        });
    }
  }


  Widget build(BuildContext context) {
  return  userAvailable ? const ButtomControler() : const SplashScreen() ;

  }
}

