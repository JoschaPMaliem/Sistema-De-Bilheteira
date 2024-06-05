import 'package:flutter/material.dart';
import 'package:sistema_bilheteira/controller/cliente_controller.dart';
import 'package:sistema_bilheteira/model/cliente_model.dart';

class HomePage_Cliente extends StatefulWidget {
  @override
  _HomePage_ClienteState createState() => _HomePage_ClienteState();
}

class _HomePage_ClienteState extends State<HomePage_Cliente> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
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
    final data = await _dbHelper.clients();
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
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
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
                        final cliente = Cliente(
                          nome: _nameController.text,
                          email: _emailController.text,
                          telefone: _telefoneController.text,
                        );
                        await _dbHelper.insertClient(cliente);
                        _clearForm();
                        _refreshClients();
                      }
                    },
                    child: Text('Add Client'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cliente.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_cliente[index].id}: ${_cliente[index].nome}'),
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
                                title: Text('Edit Client'),
                                content: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(labelText: 'Name'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a name';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(labelText: 'Email'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an email';
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
                                        final updatedClient = Cliente(
                                          id: _cliente[index].id,
                                          nome: _nameController.text,
                                          email: _emailController.text,
                                          telefone: _telefoneController.text,
                                        );
                                        await _dbHelper.updateClient(updatedClient);
                                        _clearForm();
                                        Navigator.of(context).pop();
                                        _refreshClients();
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _dbHelper.deleteClient(_cliente[index].id!);
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
