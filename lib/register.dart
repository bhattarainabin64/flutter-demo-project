import 'package:flutter/material.dart';
import 'package:tech/FirebaseService.dart';
import 'package:tech/tost.dart';
import 'package:tech/userModel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isSigningUp = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void register() async {
    setState(() {
      isSigningUp = true;
    });

    UserModel? user = await _auth.signUpWithEmailAndPassword(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _passwordController.text.trim());

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "Registration successful");
      Navigator.pushNamed(context, "/login");
    } else {
      print("faild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register'),
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
                    aspectRatio: 15 / 10,
                    child: Image.asset(
                      "assets/images/register.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Full Name",
                        hintText: "Enter your full name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Full Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildInputForm(
                    _emailController,
                    "Email",
                    "Enter your email",
                  ),
                  _buildInputForm(
                    _phoneController,
                    "Phone",
                    "Enter your phone number",
                  ),
                  _buildInputForm(
                    _passwordController,
                    "Password",
                    "Enter your password",
                    obscureText: true,
                  ),
                  _buildInputForm(
                    _confirmPasswordController,
                    "Confirm Password",
                    "Confirm your password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: Color.fromARGB(255, 68, 54, 218),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      child: isSigningUp
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
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

  Padding _buildInputForm(
    TextEditingController controller,
    String label,
    String hint, {
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
      ),
    );
  }
}
