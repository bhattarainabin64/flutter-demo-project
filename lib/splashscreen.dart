import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // super class properties
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  
  

 


  Future<void> _checkLoginStatus() async {
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if the user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
