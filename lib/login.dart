import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tech/FirebaseService.dart';
import 'package:tech/tost.dart';
import 'package:tech/userModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //make login fuction
  void login() async {
    setState(() {
      isLoading = true;
    });
    User? user = (await _auth.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    ));

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      Navigator.pushNamed(context, "/home");
    } else {
      print("faild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Login Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.asset(
                      "assets/images/login.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        // validate email using regular expression
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your email",
                        labelText: "Email",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }

                        return null;
                      },
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your password",
                        labelText: "Password",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  // Add forget password
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Color.fromARGB(255, 68, 54, 218),
                          animationDuration: const Duration(seconds: 2),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .zero, // Set the border radius to zero
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.green,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
