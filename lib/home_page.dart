import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/messaging_page.dart';
import 'package:lunch_buddy/public_request_page.dart';
import 'package:lunch_buddy/settings_page.dart';
import 'package:lunch_buddy/user_profile_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = const [
    PublicRequestPage(),
    MessagingPage(),
    UserProfilePage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter'),
      ),
      body: pages[currentPage],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     debugPrint('Floating Action');
      //   },
      //   child: const Icon(Icons.add),
      // ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
        elevation: 4.0,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/RequestBoard.png'),
                color: MyApp.dGreen,
              ),
              label: 'Request Board'),
          NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/Messaging.png'),
                color: MyApp.dGreen,
              ),
              label: 'Settings'),
          NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/UserIcon.png'),
                color: MyApp.dGreen,
              ),
              label: 'Request Board'),
          NavigationDestination(
              icon: ImageIcon(
                AssetImage('images/Settings.png'),
                color: MyApp.bGreen,
              ),
              label: 'Settings'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
