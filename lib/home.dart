import 'package:flutter/material.dart';
import 'ships.dart';
import 'clients.dart';
import 'settings.dart';
import 'requests.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const ShipsPage(),
    const ClientsPage(),
    const RequestsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
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
                elevation: 1,
                labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
                buttonMargin:
                    const EdgeInsets.only(left: 10, top: 6, bottom: 6),
                backgroundColor: Colors.deepPurpleAccent,
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
}
