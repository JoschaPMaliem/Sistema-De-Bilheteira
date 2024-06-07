// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/view/cliente/cliente_view.dart';
import 'package:sistema_bilheteira/view/produto/produto_view.dart';

void main() {
  runApp(BilheteiraApp());
}

class BilheteiraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProdutoView(), 
      //HomePage_Cliente(),
    );
  }
}
