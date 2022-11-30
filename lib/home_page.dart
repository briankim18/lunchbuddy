import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("HOME"),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}