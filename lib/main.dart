import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/home_page.dart';
import 'package:lunch_buddy/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const silv = Color.fromARGB(255, 139, 148, 163);
  static const aqua = Color.fromARGB(255, 140, 251, 221);
  static const mRed = Color.fromARGB(255, 194, 1, 20);

  static const bRed = Color.fromARGB(255, 250, 117, 112);
  static const bPurple = Color.fromARGB(255, 178, 202, 228);
  static const bYellow = Color.fromARGB(255, 255, 255, 122);
  static const bGreen = Color.fromARGB(255, 15, 255, 151);
  static const mGreen = Color.fromARGB(255, 6, 186, 99);
  static const dGreen = Color.fromARGB(255, 16, 57, 0);

  static const List<Color> bColors = [
    aqua,
    bRed,
    bPurple,
    bGreen,
    bYellow,
    silv,
  ];
  void openLocationSetting() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      const AndroidIntent intent = AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    }
  }

  @override
  Widget build(BuildContext context) {
    openLocationSetting();
    return MultiProvider(
            providers: [
              Provider<AuthenticationService>(
                create: (_) => AuthenticationService(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) =>
                    context.read<AuthenticationService>().authStateChanges,
                initialData: null,
              )
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: const AuthenticationWrapper(),
            ),
          );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomePage();
    }
    return SignInPage();
  }
}

// Picks a random light color
randomColor() {
  return MyApp.bColors[Random().nextInt(6)];
}
