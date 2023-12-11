// menu_screen.dart
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'database_helper.dart';
import 'product_screen.dart';

class MenuScreen extends StatefulWidget {
  final PostgreSQLConnection connection;

  MenuScreen(this.connection);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late PostgreSQLConnection _connection;
  List<Map<String, dynamic>> _categories = [];
  String _selectedCategoryDescription = '';
  String _hoveredCategoryId = ''; // Nueva variable

  @override
  void initState() {
    super.initState();
    openConnectionAndFetchCategories();
  }

  Future<void> openConnectionAndFetchCategories() async {
    try {
      _connection = await DatabaseHelper.openConnection();
      _categories = await DatabaseHelper.fetchCategories(_connection);

      // Inicializa la descripción con la primera categoría
      if (_categories.isNotEmpty) {
        setState(() {
          _selectedCategoryDescription = _categories.first['descripcion'] ?? '';
        });
      }
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  @override
  void dispose() {
    widget.connection.close(); // Cerrar la conexión al destruir el widget
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Bienvenido al Restaurante'),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            '¡Bienvenido a nuestro restaurante!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        buildCategoryMenu(),
      ],
    ),
  );
}

Widget buildCategoryMenu() {
  return SizedBox(
    height: 500.0, // Ajusta la altura según tus necesidades
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return buildCategoryCard(_categories[index]);
      },
    ),
  );
}

Widget buildCategoryCard(Map<String, dynamic> category) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductScreen(
            connection: widget.connection,
            categoryId: category['id_cat'] ?? '',
            categoryName: (category['nom_cat'] ?? '').toUpperCase(),
          ),
        ),
      );
    },
    onHover: (isHovered) {
      setState(() {
        _selectedCategoryDescription =
            isHovered ? category['des_cat'] ?? '' : '';
        _hoveredCategoryId = isHovered ? category['id_cat'] ?? '' : '';
      });
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(category['url_img_cat'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category['nom_cat'] ?? '',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedOpacity(
              opacity: _selectedCategoryDescription.isNotEmpty &&
                  _hoveredCategoryId == category['id_cat']
                  ? 1.0
                  : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _selectedCategoryDescription,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;

  ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
