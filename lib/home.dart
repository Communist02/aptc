import 'package:flutter/material.dart';
import 'ships.dart';
import 'clients.dart';
import 'settings.dart';

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
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(Icons.directions_boat_outlined),
                text: 'Судна',
              ),
              Tab(
                icon: Icon(Icons.person_outlined),
                text: 'Клиенты',
              ),
              Tab(
                icon: Icon(Icons.settings_outlined),
                text: 'Настройки',
              ),
            ],
          ),
        ),
        body: TabBarView(children: _pages),
      ),
    );
  }
}
