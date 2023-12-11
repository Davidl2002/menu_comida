// ignore_for_file: use_key_in_widget_constructors

// main.dart
import 'package:flutter/material.dart';
import 'package:menu_comida/database_helper.dart';
import 'package:postgres/postgres.dart';
import 'menu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurante XYZ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
      ),
      home: FutureBuilder<PostgreSQLConnection?>(
        future: DatabaseHelper.openConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data == null) {
              return ErrorScreen(message: "Error de conexión");
            }
            return MenuScreen(snapshot.data!);
          } else if (snapshot.hasError) {
            return ErrorScreen(message: "Error de conexión");
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}
