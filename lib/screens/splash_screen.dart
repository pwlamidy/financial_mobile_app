import 'package:financial_mobile_app/screens/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      if (prefs.getString("uid") == null) {
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
