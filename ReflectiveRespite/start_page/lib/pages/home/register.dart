import 'package:flutter/material.dart';
import 'package:start_page/pages/home/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Balsamiq Sans",
      ),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/register.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: -120,
                left: -70,
                child: Image.asset(
                  "assets/Logo.png",
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 260),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            color: Color.fromARGB(255, 31, 29, 29),
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 30),
                        child: Column(
                          children: [
                            // Input Name
                            TextField(
                              controller: nameController,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 33, 30, 30)),
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Input Email
                            TextField(
                              controller: emailController,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 14, 14, 14)),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Password
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 24, 24, 24)),
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Navigate to the login page upon registration
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyLogin()),
                                    );
                                  },
                                  child: const Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color.fromARGB(255, 23, 16, 16),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 0),
                                  child: SizedBox(
                                    width: 280,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(20),
                                        backgroundColor:
                                            const Color(0xff4c505b),
                                      ),
                                      onPressed: () {
                                        // Registration logic
                                        String name = nameController.text;
                                        String email = emailController.text;
                                        String password =
                                            passwordController.text;

                                        // using Firebase Auth to create a new user
                                        _auth
                                            .createUserWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        )
                                            .then((userCredential) {
                                          // Registration successful
                                          // Store user's name in Firestore
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userCredential.user?.uid)
                                              .set({
                                            'name': name,
                                            'email': email,
                                          }).then((_) {
                                            // Successfully stored name
                                            // Navigate to the home page or display a success message
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyLogin()),
                                            );
                                          }).catchError((error) {
                                            // Handle error while storing name
                                            print("Error storing name: $error");
                                          });
                                        }).catchError((error) {
                                          // Handle registration errors
                                          print(
                                              "Error registering user: $error");
                                        });
                                      },
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
