import 'package:flutter/material.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/main.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunch_buddy/change_info_page.dart';


const int itemCount = 20;

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text("Settings", style: GoogleFonts.indieFlower(fontSize: 50)),
          TextButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Notifications', style: GoogleFonts.indieFlower(fontSize: 30)),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Change username', style: GoogleFonts.indieFlower(fontSize: 30)),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Change Password', style: GoogleFonts.indieFlower(fontSize: 30)),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Log out', style: GoogleFonts.indieFlower(fontSize: 30)),
          ),
        ]
    );
  }
}
