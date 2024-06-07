import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class ProdutoView extends StatefulWidget {
  @override
  _ProdutoViewState createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> {
  final BilheteModel _bilheteModel = BilheteModel();
  List<Bilhete> _bilhetes = [];

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _precoController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBilhetes();
  }

  void _clearForm() {
    _nomeController.clear();
    _descricaoController.clear();
    _dataController.clear();
    _precoController.clear();
    _statusController.clear();
  }

  Future<void> _fetchBilhetes() async {
    final bilhetes = await _bilheteModel.getBilhetes();
    setState(() {
      _bilhetes = bilhetes;
    });
  }

  Future<void> _addBilhete() async {
    final newBilhete = Bilhete(
      id: DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      dataDoEvento: DateTime.parse(_dataController.text),
      preco: double.parse(_precoController.text),
      status: _statusController.text,
    );
    await _bilheteModel.criarBilhete(newBilhete);
    _fetchBilhetes();
    Navigator.of(context).pop();
  }

  Future<void> _updateBilhete(Bilhete bilhete) async {
    final updatedBilhete = Bilhete(
      id: bilhete.id,
      nome: bilhete.nome + ' (Atualizado)',
      descricao: bilhete.descricao,
      dataDoEvento: bilhete.dataDoEvento,
      preco: bilhete.preco,
      status: bilhete.status,
    );
    await _bilheteModel.atualizarBilhete(updatedBilhete);
    _fetchBilhetes();
  }

  Future<void> _deleteBilhete(int id) async {
    await _bilheteModel.apagarBilhete(id);
    _fetchBilhetes();
  }

  Future<void> _checkInventory() async {
    final inventario = await _bilheteModel.verificarEstoque();
    for (var item in inventario) {
      print('Bilhete: ${item.bilhete.nome}, Estoque: ${item.estoque}');
    }
  }

  void _showAddBilheteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Novo Bilhete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _dataController,
                decoration:
                    InputDecoration(labelText: 'Data do Evento (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: _addBilhete, //current issue here is that the controllers are not being cleared
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Bilhetes'),
      ),
      body: ListView.builder(
        itemCount: _bilhetes.length,
        itemBuilder: (context, index) {
          final bilhete = _bilhetes[index];
          return ListTile(
            title: Text(bilhete.nome),
            subtitle: Text(
              'Descrição: ${bilhete.descricao}\n'
              'Data: ${bilhete.dataDoEvento}\n'
              'Preço: ${bilhete.preco}\n'
              'Status: ${bilhete.status}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateBilhete(bilhete),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteBilhete(bilhete.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBilheteDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
