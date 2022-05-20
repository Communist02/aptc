import 'package:flutter/material.dart';
import 'firebase.dart';
import 'global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'state_update.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> changePrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: InkWell(
              child: const ListTile(
                leading: Icon(Icons.exit_to_app_outlined, size: 34),
                title: Text('Выход из аккаунта'),
                subtitle: Text('Выйти из вашего аккаунта'),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Вы уверены?', textScaleFactor: 1.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    actions: [
                      ListTile(
                        leading: const Icon(Icons.not_interested_outlined),
                        title: const Text('Нет', textScaleFactor: 1.2),
                        onTap: () => Navigator.pop(context, 'false'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app_outlined),
                        title: const Text('Да', textScaleFactor: 1.2),
                        onTap: () => Navigator.pop(context, 'true'),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value == 'true') {
                    final AuthService _authService = AuthService();
                    await _authService.signOut();
                    account.clear();
                    context.read<ChangeProfile>().change();
                  }
                });
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: InkWell(
              child: ListTile(
                leading: const Icon(Icons.color_lens_outlined, size: 34),
                title: const Text('Тема приложения'),
                subtitle: Text(appSettings['theme'] == 'light'
                    ? 'Светлая тема'
                    : appSettings['theme'] == 'dark'
                        ? 'Темная тема'
                        : 'Системная тема'),
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Тема приложения'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.wb_sunny_outlined),
                        title: const Text('Светлая тема'),
                        onTap: () => Navigator.pop(context, 'light'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.nights_stay_outlined),
                        title: const Text('Темная тема'),
                        onTap: () => Navigator.pop(context, 'dark'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone_android_outlined),
                        title: const Text('Системная тема'),
                        onTap: () => Navigator.pop(context, 'system'),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      changePrefs('theme', value);
                      appSettings['theme'] = value;
                      context.read<ChangeTheme>().change();
                    });
                  }
                });
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            child: const ListTile(
              title: Text('АТТК'),
              subtitle: Text('Версия 0.9 Beta'),
            ),
          ),
        ],
      ),
    );
  }
}
