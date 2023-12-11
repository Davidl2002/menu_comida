// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class ProductScreen extends StatefulWidget {
  final PostgreSQLConnection connection;
  final String categoryId;
  final String categoryName;

  const ProductScreen({
    required this.connection,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      var results = await widget.connection.query(
        'SELECT * FROM PRODUCTOS WHERE ID_CAT_PER = @categoryId',
        substitutionValues: {'categoryId': widget.categoryId},
      );

      setState(() {
        products = results.map((row) => row.toColumnMap()).toList();
      });
    } catch (e) {
      showErrorDialog("Error al obtener los productos");
    }
  }

  @override
  void dispose() {
    // No cierres la conexión aquí, permite que se cierre cuando el widget se destruya
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos en la categoría ${widget.categoryName.toUpperCase()}'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' ${widget.categoryName.toUpperCase()}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return buildProductCard(products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          product['url_img_pro'] as String,
          width: 60.0,
          height: 60.0,
          fit: BoxFit.cover,
        ),
        title: Text(
          product['nom_pro'] as String,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          product['des_pro'] as String,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
  '\$${double.tryParse(product['pre_uni_pro'] as String)?.toStringAsFixed(2) ?? ''}',
  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
