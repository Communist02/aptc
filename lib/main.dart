import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state_update.dart';
import 'themes.dart';
import 'global.dart';
import 'home.dart';
import 'firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final theme = prefs.getString('theme');
  if (theme != null) appSettings['theme'] = theme;

  final clientsBase = prefs.getString('clientsBase');
  if (clientsBase != null) globalClients = jsonDecode(clientsBase);

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCwb7wfHs1Q8vmCMafEdA-3CMSHqlBUlA4',
      appId: '1:182561817454:android:07fb8984b5e41c8007377f',
      messagingSenderId: '182561817454',
      projectId: 'aptc-base',
    ),
  );
  AuthService().sign();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChangeNavigation()),
        ChangeNotifierProvider(create: (context) => ChangeProfile()),
        ChangeNotifierProvider(create: (context) => ChangeShip()),
        ChangeNotifierProvider(
          create: (context) => ChangeTheme(),
          builder: (BuildContext context, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'АТТК',
              themeMode:
                  AppThemes().getMode(context.watch<ChangeTheme>().getTheme),
              theme: AppThemes().light(),
              darkTheme: AppThemes().dark(),
              home: const HomePage(),
            );
          },
        ),
      ],
    );
  }
}
