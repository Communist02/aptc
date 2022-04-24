import 'package:aptc/messages.dart';
import 'package:aptc/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ships.dart';
import 'clients.dart';
import 'settings.dart';
import 'requests.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'global.dart';
import 'state_update.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const ShipsPage(),
    const ClientsPage(),
    const RequestsPage(),
    const MessagesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    context.watch<ChangeProfile>();
    if (account.id != null) {
      return DefaultTabController(
        length: _pages.length,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ButtonsTabBar(
                  height: 80,
                  radius: 15,
                  borderWidth: 1.5,
                  duration: 0,
                  labelSpacing: 10,
                  borderColor: Theme.of(context).tabBarTheme.labelColor!,
                  unselectedBorderColor: Colors.transparent,
                  labelStyle: TextStyle(
                      fontSize: 26,
                      color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                      fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(
                    color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                    fontWeight: FontWeight.w600,
                  ),
                  buttonMargin:
                      const EdgeInsets.only(left: 10, top: 6, bottom: 6),
                  backgroundColor: Colors.transparent,
                  unselectedBackgroundColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.directions_boat_outlined,
                        size: 40,
                      ),
                      text: 'Судна',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.person_outlined,
                        size: 48,
                      ),
                      text: 'Клиенты',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 40,
                      ),
                      text: 'Заявки',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.message_outlined,
                        size: 40,
                      ),
                      text: 'Сообщения',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.settings_outlined,
                        size: 40,
                      ),
                      text: 'Настройки',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: _pages),
        ),
      );
    }
    else {
      return const ProfilePage();
    }
  }
}
