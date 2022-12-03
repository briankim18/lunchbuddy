import 'package:flutter/material.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/main.dart';
import 'package:provider/provider.dart';

const int itemCount = 20;

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<AuthenticationService>().signOut();
      },
      backgroundColor: MyApp.bGreen,
      elevation: 4.0,
      child: const Icon(Icons.add),
    );
  }
}
