import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 255, 151),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Lunch Buddy",
                    style: GoogleFonts.indieFlower(fontSize: 50)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Username", style: GoogleFonts.indieFlower(
                      fontSize: 20, height: 2)),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    isDense: true,
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Password", style: GoogleFonts.indieFlower(
                      fontSize: 20, height: 2)),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    labelText: "Password",
                    isDense: true,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                  child: const Text("Sign In"),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage())
                      );
                    }, child: const Text("Register")
                ),
                SizedBox(height: 50),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'images/BrownBag.png',
                      height: 150,
                      width: 150,
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
