import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:lunch_buddy/home_page.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
<<<<<<< HEAD
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonBar(children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                  child: const Text("Sign in"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text("Register"),
                ),
              ]),
              const Text(
                "Lunch Buddy",
                style: TextStyle(
                    fontFamily: 'Times New Roman', 
                    fontSize: 45, 
                    color: Colors.black)),
              Padding(padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                },
                child: const Text("Login"),
              ),
              ClipRRect(
                  child: Image.asset(
                      'images/BrownBag.png',
                      width: 150,
                      height: 150)
              ),
            ],
=======
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              isDense: true,
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
            },
            child: const Text("Sign In"),
>>>>>>> 27f1b7f0f52c1cb30dd91f77422cc7274cb10458
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage())
              );
            }, child: const Text("Register")
          )
        ],
      ),
    ));
  }
}
