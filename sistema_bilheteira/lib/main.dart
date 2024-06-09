// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/view/inventario/inventario_view.dart';
import 'package:sistema_bilheteira/view/produto/produto_view.dart';
import 'package:sistema_bilheteira/view/relatorio/relatorio_view.dart';
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

      debugShowCheckedModeBanner: false,
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
          _currentView = ClienteView();
        });
        break;
      case 2:
        setState(() {
          _currentView = ProdutoView(); 
        });
        break;

      case 3:
        setState(() {
          _currentView = InventarioView();
        });
        break;

        case 4:
        setState(() {
          _currentView = VendaView();
        });
        break;

        case 5:
        setState(() {
          _currentView = RelatorioView();
        });
        break;

        case 6:
        setState(() {
         // _currentView = LoginView();
        });
        break;

       

        
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de gestão de bilheteira'),

        
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
