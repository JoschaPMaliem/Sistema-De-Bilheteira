import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/inventario_controller.dart';
import 'package:sistema_bilheteira/controller/relatorio_controller.dart';
import 'package:sistema_bilheteira/model/inventario_model.dart';
import 'package:sistema_bilheteira/model/venda_model.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class RelatorioView extends StatefulWidget {
  @override
  _RelatorioViewState createState() => _RelatorioViewState();
}

class _RelatorioViewState extends State<RelatorioView> {
  final InventarioController _inventarioController = InventarioController();
  final RelatorioController _relatorioController = RelatorioController(InventarioModel(), VendaModel());
  late Future<Map<String, dynamic>> _relatorioVenda;
  late Future<List<Bilhete>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _relatorioVenda = _relatorioController.gerarRelatorioVenda();
    _produtosFuture = _fetchProdutosAbaixoReorderPoint();
  }

  Future<List<Bilhete>> _fetchProdutosAbaixoReorderPoint() async {
    int pontoDeEncomenda = 5;
    return await _inventarioController.getProdutosAbaixoReorderPoint(pontoDeEncomenda);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<List<Bilhete>>(
              future: _produtosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum produto abaixo do estoque limite.'));
                } else {
                  final produtos = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Produtos abaixo do ponto de encomenda',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: produtos.length,
                          itemBuilder: (context, index) {
                            final produto = produtos[index];
                            return ListTile(
                              title: Text('Produto: ${produto.nome}'),
                              subtitle: Text('Estoque: ${produto.estoque}'),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Produtos mais vendidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _relatorioVenda,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || (snapshot.data!['data'] as List).isEmpty) {
                  return Center(child: Text('Nenhum produto vendido.'));
                } else {
                  final produtos = snapshot.data!['data'] as List<Map<String, dynamic>>;
                  return ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final produto = produtos[index];
                      return ListTile(
                        title: Text('Produto: ${produto['nome']}'),
                        subtitle: Text('Quantidade Vendida: ${produto['quantidadeVendida']}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
