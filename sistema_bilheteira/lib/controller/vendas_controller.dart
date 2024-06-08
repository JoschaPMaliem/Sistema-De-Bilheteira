import 'package:sistema_bilheteira/model/cliente_model.dart';
import 'package:sistema_bilheteira/model/venda_model.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class VendaController {
  final VendaModel _vendaModel = VendaModel();
  final ClienteModel _clienteModel = ClienteModel();

  Future<int> criarVenda(Venda venda) {
    return _vendaModel.criarVenda(venda);
  }

  Future<int> atualizarVenda(Venda venda) {
    return _vendaModel.atualizarVenda(venda);
  }

  Future<int> apagarVenda(int id) {
    return _vendaModel.apagarVenda(id);
  }

  Future<List<Venda>> getVendas() {
    return _vendaModel.getVendas();
  }

  Future<List<Bilhete>> getBilhetesPorCliente(int clienteId) {
    return _vendaModel.getBilhetesPorCliente(clienteId);
  }

  Future<Cliente?> getClienteById(int id) {
    return _clienteModel.getClienteById(id);
  }
}
