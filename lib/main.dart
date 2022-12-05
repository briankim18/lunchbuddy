import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lunch_buddy/blocs/autocomplete/autocomplete_event.dart';
import 'package:lunch_buddy/blocs/geolocation_bloc.dart';
import 'package:lunch_buddy/blocs/geolocation_event.dart';
import 'package:lunch_buddy/places/places_repository.dart';
import 'package:lunch_buddy/repositories/geolocation/geolocation_repository.dart';
import 'blocs/autocomplete/autocomplete_bloc.dart';
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
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }
  @override
  Widget build(BuildContext context) {
    openLocationSetting();
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<GeolocationRepository>(
        create: (_) => GeolocationRepository(),
      ),
      RepositoryProvider<PlacesRepository>(
        create: (_) => PlacesRepository(),
      ),
    ], child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>  GeolocationBloc(geolocationRepository: context.read<GeolocationRepository>())
          ..add(LoadGeolocation())),
        BlocProvider(create: (context) =>  AutocompleteBloc(placesRepository: context.read<PlacesRepository>())
          ..add(LoadAutocomplete())),


      ], child: MultiProvider(
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
    ),
    ));
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
