import 'package:delhimetro/server_connect.dart';
import 'package:delhimetro/stations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'slots.dart';
import 'home.dart';
import './providers/content.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => Content(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.black87,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
        routes: {
          Slots.routeName: (ctx) => Slots(),
          Stations.routeName: (ctx) => Stations(),
          Home.routename: (ctx) => Home(),
          MyHomePage.routeName: (ctx) => MyHomePage(),
        },
      ),
    );
  }
}
