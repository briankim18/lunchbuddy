import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/messaging_page.dart';
import 'package:lunch_buddy/page/messages_page.dart';
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

    MessagesPage(),

  //  MessagingPage(),
    HomePage(),
    UserProfilePage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Flutter'),
      // ),
      extendBody: true,
      body: pages[currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const PublicRequestPage()),
          // );
          context.read<AuthenticationService>().signOut();
        },
        backgroundColor: MyApp.bGreen,
        elevation: 4.0,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        // ****** APP BAR ******************
        shape:
            const CircularNotchedRectangle(), // ← carves notch for FAB in BottomAppBar
        color: MyApp.bGreen,
        // ↑ use .withAlpha(0) to debug/peek underneath ↑ BottomAppBar
        elevation: 0, // ← removes slight shadow under FAB, hardly noticeable
        // ↑ default elevation is 8. Peek it by setting color ↑ alpha to 0
        child: NavigationBar(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
          surfaceTintColor: MyApp.dGreen,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(
                icon: ImageIcon(
                  AssetImage('images/RequestBoard.png'),
                  color: MyApp.dGreen,
                  size: 40,
                ),
                label: 'Request Board'),
            NavigationDestination(
                icon: ImageIcon(
                  AssetImage('images/Messaging.png'),
                  color: MyApp.dGreen,
                  size: 40,
                ),
                label: 'Settings'),
            Visibility(
              visible: false,
              child: NavigationDestination(
                  icon: ImageIcon(
                    AssetImage('images/Messaging.png'),
                    color: MyApp.dGreen,
                    size: 40,
                  ),
                  label: 'Settings'),
            ),
            NavigationDestination(
                icon: ImageIcon(
                  AssetImage('images/UserIcon.png'),
                  color: MyApp.dGreen,
                  size: 40,
                ),
                label: 'Request Board'),
            NavigationDestination(
                icon: ImageIcon(
                  AssetImage('images/Settings.png'),
                  color: MyApp.dGreen,
                  size: 40,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
