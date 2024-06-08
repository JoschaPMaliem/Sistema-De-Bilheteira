// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/view/inventario/inventario_view.dart';
import 'package:sistema_bilheteira/view/produto/produto_view.dart';
import 'package:sistema_bilheteira/view/vendas/venda_view.dart';
import 'package:sistema_bilheteira/view/cliente/cliente_view.dart';
import 'package:sistema_bilheteira/widgets/drawer.dart';
//import 'package:sistema_bilheteira/view/produto/produto_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _currentView = Placeholder(); // Placeholder until a view is selected

  void _onMenuItemClicked(int index) {
    switch (index) {
      case 1:
        setState(() {
          _currentView = ClienteView(); // Navigate to ClienteView
        });
        break;
      case 2:
        setState(() {
          _currentView = ProdutoView(); // Navigate to ProdutoView
        });
        break;
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      drawer: MainMenuDrawer(
        onMenuItemClicked: _onMenuItemClicked,
      ),
      body: Center(
        child: _currentView,
      ),
    );
  }
}
