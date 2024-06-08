// lib/controllers/database_helper.dart
import 'package:sistema_bilheteira/model/cliente_model.dart';

class ClienteController {
  final ClienteModel _clienteModel = ClienteModel();

  Future<int> criarCliente(String nome, String email, String telefone) async {
    Cliente novoCliente = Cliente(nome: nome, email: email, telefone: telefone);
    return await _clienteModel.criarCliente(novoCliente);
  }

  Future<int> atualizarCliente(
      int id, String nome, String email, String telefone) async {
    Cliente clienteAtualizado =
        Cliente(id: id, nome: nome, email: email, telefone: telefone);
    return await _clienteModel.atualizarCliente(clienteAtualizado);
  }

  Future<int> apagarCliente(int id) async {
    return await _clienteModel.apagarCliente(id);
  }

  Future<List<Cliente>> getClientes() async {
    return await _clienteModel.getClientes();
  }
}
