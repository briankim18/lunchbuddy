import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 15, 255, 151),
          body: Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 40),
                          backgroundColor: MyApp.aqua,
                          elevation: 4,
                        ),
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.indieFlower(
                              fontSize: 20, color: MyApp.dGreen),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          // padding: const EdgeInsets.all(10),
                          fixedSize: const Size(100, 40),
                          backgroundColor: MyApp.bGreen,
                          elevation: 4,
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.indieFlower(
                              fontSize: 20, color: MyApp.dGreen),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Lunch Buddy",
                    style: GoogleFonts.indieFlower(fontSize: 50)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Username",
                      style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      isDense: true,
                      labelText: "Username",
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password",
                      style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      labelText: "Password",
                      isDense: true,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      // padding: const EdgeInsets.all(10),
                      fixedSize: const Size(300, 40),
                      backgroundColor: MyApp.bYellow,
                      elevation: 4,
                    ),
                    child: Text(
                      "Log In",
                      style: GoogleFonts.indieFlower(
                        fontSize: 24,
                        color: MyApp.dGreen,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      // padding: const EdgeInsets.all(10),
                      fixedSize: const Size(100, 40),
                      backgroundColor: MyApp.aqua,
                      elevation: 4,
                    ),
                    child: Text(
                      "Register",
                      style: GoogleFonts.indieFlower(
                          fontSize: 20, color: MyApp.dGreen),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'images/BrownBag.png',
                      height: 150,
                      width: 150,
                    )),
              ],
            ),
          ))),
    );
  }
}
