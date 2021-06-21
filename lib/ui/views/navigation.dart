import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tyba_test/ui/views/home.dart';
import 'package:tyba_test/ui/views/login.dart';
import 'package:tyba_test/ui/views/records.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final auth = FirebaseAuth.instance;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const RecordsView(),
  ];

  void logoutModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Cerrar sesión",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("¿Estás seguro de cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () {
                auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

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
                  onTap: () {
                    logoutModal(context);
                  },
                  child: const Icon(
                    Icons.logout,
                    size: 30.0,
                  ),
                )),
          ],
          backgroundColor: Colors.lightBlue,
          bottom: const TabBar(
            indicatorColor: Colors.white,
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
