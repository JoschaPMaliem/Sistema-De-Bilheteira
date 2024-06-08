import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/inventario_controller.dart';
import 'package:sistema_bilheteira/model/inventario_model.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class InventarioView extends StatefulWidget {
  @override
  _InventarioViewState createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  final InventarioController _inventarioController = InventarioController();
  List<Bilhete>? _produtos;
  int? _stock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                int pontoDeEncomenda = 5;
                List<Bilhete> produtos = await _inventarioController.getProdutosAbaixoReorderPoint(pontoDeEncomenda);
                setState(() {
                  _produtos = produtos;
                });
              },
              child: Text('Listar produtos abaixo do estoque limite'),
            ),
            ElevatedButton(
              onPressed: () async {
                int produtoId = 1; // Example product ID
                int stock = await _inventarioController.verificarEstoque(produtoId);
                setState(() {
                  _stock = stock;
                });
              },
              child: Text('Verificar estoque do produto'),
            ),
            if (_stock != null)
              Text('Estoque do produto: $_stock'),
            if (_produtos != null && _produtos!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _produtos!.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos![index];
                    return ListTile(
                      title: Text('Produto: ${produto.nome}'),
                      subtitle: Text('Estoque: ${produto.estoque}'),
                    );
                  },
                ),
              ),
            if (_produtos != null && _produtos!.isEmpty)
              Text('Nenhum produto abaixo do estoque limite.'),
          ],
        ),
      ),
    );
  }
}
