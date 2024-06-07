import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/cliente_controller.dart';
import 'package:sistema_bilheteira/model/cliente_model.dart';

class HomePage_Cliente extends StatefulWidget {
  @override
  _HomePage_ClienteState createState() => _HomePage_ClienteState();
}

class _HomePage_ClienteState extends State<HomePage_Cliente> {
  final ClienteController _dbHelper = ClienteController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  List<Cliente> _cliente = [];

  @override
  void initState() {
    super.initState();
    _refreshClients();
  }

  void _refreshClients() async {
    final data = await _dbHelper.getClientes();
    setState(() {
      _cliente = data;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _telefoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite o email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu numero de telefone';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _dbHelper.criarCliente(
                          _nameController.text,
                          _emailController.text,
                          _telefoneController.text,
                        );
                        _clearForm();
                        _refreshClients();
                      }
                    },
                    child: Text('Adicionar Cliente'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cliente.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text('${_cliente[index].id}: ${_cliente[index].nome}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${_cliente[index].email}'),
                        Text('Telefone: ${_cliente[index].telefone}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _nameController.text = _cliente[index].nome;
                            _emailController.text = _cliente[index].email;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Editar Cliente'),
                                content: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        decoration:
                                            InputDecoration(labelText: 'Nome'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Digite o nome';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration:
                                            InputDecoration(labelText: 'Email'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Digite o email';
                                          }
                                          return null;
                                        },
                                      ),

                                      TextFormField(
                                        controller: _telefoneController,
                                        decoration:
                                            InputDecoration(labelText: 'Telefone'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Digite o numero de telefone';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                     if (_formKey.currentState!.validate()) {
                                        await _dbHelper.atualizarCliente(
                                          _cliente[index].id!,
                                          _nameController.text,
                                          _emailController.text,
                                          _telefoneController.text,
                                        );
                                        _clearForm();
                                        Navigator.of(context).pop();
                                        _refreshClients();
                                      }
                                    },
                                    child: Text('Atualizar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _dbHelper.apagarCliente(_cliente[index].id!);
                            _refreshClients();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
