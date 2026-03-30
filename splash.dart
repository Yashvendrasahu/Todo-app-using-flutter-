import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:myapp/main.dart';
import 'package:myapp/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade100,
        child: const Center(
          child: Icon(Icons.message, color: Colors.blue, size: 45),
        ),
      ),
    );
  }

  void _whereToGo() async {
    var prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.getBool('KEYLOGIN') ?? false;

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if (isLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NotePage()), // Corrected class name
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>const NotePage()),
          );
        }
      }
    });
  }
}
