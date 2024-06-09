import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/inventario_controller.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({super.key});

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  final InventarioController _inventarioController = InventarioController();
  late Future<List<Bilhete>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _produtosFuture = _inventarioController.getTodosProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventário'),
      ),
      body: FutureBuilder<List<Bilhete>>(
        future: _produtosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum produto encontrado.'));
          } else {
            final produtos = snapshot.data!;
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(produto.nome),
                  onTap: () {
                    _showEstoqueDialog(context, produto);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showEstoqueDialog(BuildContext context, Bilhete produto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Estoque de ${produto.nome}'),
          content: Text('Quantidade disponível: ${produto.estoque}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
