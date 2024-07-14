import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tech/bottomnav.dart';
import 'package:tech/chnage_password.dart';
import 'package:tech/editprofile.dart';
import 'package:tech/firebase_options.dart';
import 'package:tech/login.dart';
import 'package:tech/navbar.dart';
import 'package:tech/profile.dart';
import 'package:tech/register.dart';
import 'package:tech/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // for statful widgets stful, stless for stateless
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: "/splash", // thsi screen is build frist time
        routes: {
          "/login": (context) => const LoginPage(),
          "/register": (context) => const RegisterPage(),
          "/home": (context) => const NavBar(),
          "/profile": (context) => const Profile(),
          "/splash": (context) => const SplashScreen(),
          "/change_password": (context) => const ChangePasswordPage(),
          "/edit_profile": (context) => const EditProfile(),
        });
  }
}
