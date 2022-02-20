import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state_update.dart';
import 'themes.dart';
import 'global.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final theme = prefs.getString('theme');
  if (theme != null) appSettings['theme'] = theme;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChangeNavigation()),
        ChangeNotifierProvider(
          create: (context) => ChangeTheme(),
          builder: (BuildContext context, _) {
            return MaterialApp(
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
