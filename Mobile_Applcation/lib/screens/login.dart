import 'package:flutter/material.dart';
import 'package:ev_logger/screens/home_screen.dart';
import 'package:ev_logger/screens/registration_one.dart';
import 'package:ev_logger/widgets/textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import SoHScreen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscureText = true; // Manage visibility of the password

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1515),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      // CurvedContainer(),
                      Lottie.asset(
                        'images/animations/Animation - 1741912638500.json',
                      ),
                      const Positioned(
                        bottom: 0.0,
                        left: 25.0,
                        child: Center(
                          child: Text(
                            'Battery Logger',
                            style: TextStyle(
                              color: Color(0xFF01D5A2),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sign in to check out your battery health',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 99, 98, 98),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: MyTextField(
                      icon: Icons.email,
                      text: 'Email',
                      obscure: false, // Email field should not be obscured
                      val: 'Enter your e-mail',
                      mycontroller: email,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password TextField with Toggle Visibility
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF01D5A2).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: pass,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter a password',
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: const Color(0xFF01D5A2).withOpacity(0.4),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye_rounded,
                              color: const Color(0xFF01D5A2).withOpacity(0.4),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(
                                255,
                                229,
                                229,
                                229,
                              ).withOpacity(0.5),
                              width: 1,
                            ), // Border styling
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: 1,
                            ), // Border styling
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                              width: 1,
                            ), // Border styling
                          ),
                        ),
                        validator: (val) => val == "" ? "Required field" : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        try {
                          // Sign in with Supabase
                          final response = await supabase.auth
                              .signInWithPassword(
                                email: email.text,
                                password: pass.text,
                              );

                          final user = response.user;
                          if (user == null) {
                            throw 'Login failed. Please try again.';
                          }

                          // Navigate to SoHScreen after successful login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'An error occurred: $e',
                          ).show();
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(25),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.09,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Login now',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF01D5A2),
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'If you have not signed in,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 99, 98, 98),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registration(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign in..',
                          style: TextStyle(color: Color(0xFF01D5A2)),
                        ),
                      ),
                    ],
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
