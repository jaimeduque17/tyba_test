import 'package:flutter/material.dart';
import 'package:tyba_test/ui/views/home.dart';
import 'package:tyba_test/ui/views/records.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const RecordsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _widgetOptions.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurantes'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.logout,
                    size: 30.0,
                  ),
                )),
          ],
          backgroundColor: Colors.lightBlue,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Búsqueda'),
              Tab(text: 'Registros de búsqueda'),
            ],
          ),
        ),
        body: TabBarView(
          children: _widgetOptions,
        ),
      ),
    );
  }
}
