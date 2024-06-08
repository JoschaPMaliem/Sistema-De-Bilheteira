import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/produto_controller.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class ProdutoView extends StatefulWidget {
  @override
  _ProdutoViewState createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> {
  final ProdutoController _produtoController = ProdutoController();
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
    final bilhetes = await _produtoController.getBilhetes();
    setState(() {
      _bilhetes = bilhetes;
    });
  }

  Future<void> _addBilhete() async {
    if (_nomeController.text.isNotEmpty &&
        _descricaoController.text.isNotEmpty &&
        _dataController.text.isNotEmpty &&
        _precoController.text.isNotEmpty &&
        _statusController.text.isNotEmpty) {
      await _produtoController.adicionarBilhete(
        _nomeController.text,
        _descricaoController.text,
        _dataController.text,
        _precoController.text,
        _statusController.text,
      );
      _clearForm();
      _fetchBilhetes();
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateBilhete(Bilhete bilhete) async {
    _nomeController.text = bilhete.nome;
    _descricaoController.text = bilhete.descricao;
    _dataController.text = bilhete.dataDoEvento.toIso8601String().split('T').first;
    _precoController.text = bilhete.preco.toString();
    _statusController.text = bilhete.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Atualizar Bilhete'),
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
                _clearForm();
              },
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () async {
                await _produtoController.atualizarBilhete(
                  bilhete.id!,
                  _nomeController.text,
                  _descricaoController.text,
                  _dataController.text,
                  _precoController.text,
                  _statusController.text,
                );
                _clearForm();
                _fetchBilhetes();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBilhete(int id) async {
    await _produtoController.apagarBilhete(id);
    _fetchBilhetes();
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
              'ID: ${bilhete.id}\n'
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
              onPressed: _addBilhete,
            ),
          ],
        );
      },
    );
  }
}
