import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/vendas_controller.dart';
import 'package:sistema_bilheteira/model/venda_model.dart';

class VendaView extends StatefulWidget {
  @override
  _VendaViewState createState() => _VendaViewState();
}

class _VendaViewState extends State<VendaView> {
  final VendaController _vendaController = VendaController();
  final _clienteIdController = TextEditingController();
  final _bilheteIdController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _valorTotalController = TextEditingController();
  final _dataDeVendaController = TextEditingController();
  List<Venda> _vendas = [];
  Map<int, String> _clientesNomes = {};

  @override
  void initState() {
    super.initState();
    _fetchVendas();
  }

  Future<void> _fetchVendas() async {
    final vendas = await _vendaController.getVendas();
    for (var venda in vendas) {
      await _fetchClienteNome(venda.id_cliente);
    }
    setState(() {
      _vendas = vendas;
    });
  }

  Future<void> _fetchClienteNome(int clienteId) async {
    final cliente = await _vendaController.getClienteById(clienteId);
    setState(() {
      _clientesNomes[clienteId] = cliente?.nome ?? 'Unknown';
    });
  }

   Future<void> _addVenda() async {
    if (_clienteIdController.text.isNotEmpty &&
        _bilheteIdController.text.isNotEmpty &&
        _quantidadeController.text.isNotEmpty) {
      final bilheteId = int.parse(_bilheteIdController.text);
      final bilhete = await _vendaController.getBilheteById(bilheteId);
      if (bilhete != null) {
        final preco = bilhete.preco;
        final quantidade = int.parse(_quantidadeController.text);
        final valorTotal = preco * quantidade;
        final dataVenda = DateTime.now().toString();

        await _vendaController.criarVenda(
          Venda(
            id: null,
            id_cliente: int.parse(_clienteIdController.text),
            id_bilhete: bilheteId,
            quantidade: quantidade,
            valorTotal: valorTotal,
            dataVenda: dataVenda,
          ),
        );
        _clearForm();
        _fetchVendas();
        Navigator.of(context).pop();
      }
    }
  }


  void _clearForm() {
    _clienteIdController.clear();
    _bilheteIdController.clear();
    _quantidadeController.clear();
    _valorTotalController.clear();
    _dataDeVendaController.clear();
  }

  void _showAddVendaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Nova Venda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _clienteIdController,
                decoration: InputDecoration(labelText: 'Bilhete ID'),
                onChanged: (value) async {
                  final clienteId = int.tryParse(value);
                  if (clienteId != null) {
                    await _fetchClienteNome(clienteId);
                  }
                },
              ),
              if (_clienteIdController.text.isNotEmpty && _clientesNomes.containsKey(int.parse(_clienteIdController.text)))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Cliente: ${_clientesNomes[int.parse(_clienteIdController.text)]}'),
                ),
              TextField(
                controller: _bilheteIdController,
                decoration: InputDecoration(labelText: 'Cliente ID'),
              ),
              TextField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
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
              onPressed: _addVenda,
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
        title: Text('Vendas'),
      ),
      body: ListView.builder(
        itemCount: _vendas.length,
        itemBuilder: (context, index) {
          final venda = _vendas[index];
          final clienteNome = _clientesNomes[venda.id_cliente];
          return ListTile(
            title: Text('Venda ID: ${venda.id}'),
            subtitle: Text(
              'Cliente ID: ${venda.id_cliente}\n'
              'Cliente Nome: $clienteNome\n'
              'Bilhete ID: ${venda.id_bilhete}\n'
              'Quantidade: ${venda.quantidade}\n'
              'Valor Total: ${venda.valorTotal} Mts\n'
              'Data de Venda: ${venda.dataVenda}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
               /* IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateVenda(venda),
                ), */
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteVenda(venda.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVendaDialog,
        child: Icon(Icons.add),
      ),
    );
  }

/*
  Future<void> _updateVenda(Venda venda) async {
    _clienteIdController.text = venda.id_cliente.toString();
    _bilheteIdController.text = venda.id_bilhete.toString();
    _quantidadeController.text = venda.quantidade.toString();
    _valorTotalController.text = venda.valorTotal.toString();
    _dataDeVendaController.text = venda.dataVenda!;

    await _fetchClienteNome(venda.id_cliente);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Atualizar Venda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _clienteIdController,
                decoration: InputDecoration(labelText: 'Cliente ID'),
                onChanged: (value) async {
                  final clienteId = int.tryParse(value);
                  if (clienteId != null) {
                    await _fetchClienteNome(clienteId);
                  }
                },
              ),
              if (_clienteIdController.text.isNotEmpty && _clientesNomes.containsKey(int.parse(_clienteIdController.text)))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Cliente: ${_clientesNomes[int.parse(_clienteIdController.text)]}'),
                ),
              TextField(
                controller: _bilheteIdController,
                decoration: InputDecoration(labelText: 'Bilhete ID'),
              ),
              TextField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _valorTotalController,
                decoration: InputDecoration(labelText: 'Valor Total'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _dataDeVendaController,
                decoration: InputDecoration(labelText: 'Data de Venda'),
                keyboardType: TextInputType.datetime,
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
                await _vendaController.atualizarVenda(
                  Venda(
                    id: venda.id,
                    id_cliente: int.parse(_clienteIdController.text),
                    id_bilhete: int.parse(_bilheteIdController.text),
                    quantidade: int.parse(_quantidadeController.text),
                    valorTotal: double.parse(_valorTotalController.text),
                    dataVenda: _dataDeVendaController.text,
                  ),
                );
                _clearForm();
                _fetchVendas();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

*/
  Future<void> _deleteVenda(int id) async {
    await _vendaController.apagarVenda(id);
    _fetchVendas();
  }
}
