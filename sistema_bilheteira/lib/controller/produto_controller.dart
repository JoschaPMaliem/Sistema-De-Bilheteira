import 'package:sistema_bilheteira/model/produto_model.dart';

class ProdutoController {
  final BilheteModel _bilheteModel = BilheteModel();

  Future<int> adicionarBilhete(String nome, String descricao,
      String dataDoEvento, String preco, String status) async {
    Bilhete newBilhete = Bilhete(
        nome: nome,
        descricao: descricao,
        dataDoEvento: DateTime.parse(dataDoEvento),
        preco: double.parse(preco),
        status: status,
        estoque: 500);

    return await _bilheteModel.criarBilhete(newBilhete);
  }

  Future<int> atualizarBilhete(int id, String nome, String descricao,
      String dataDoEvento, String preco, String status) async {
    Bilhete bilheteAtualizado = Bilhete(
      id: id,
      nome: nome,
      descricao: descricao,
      dataDoEvento: DateTime.parse(dataDoEvento),
      preco: double.parse(preco),
      status: status,
    );

    return await _bilheteModel.atualizarBilhete(bilheteAtualizado);
  }

  Future<int> apagarBilhete(int id) async {
    return await _bilheteModel.apagarBilhete(id);
  }

  Future<List<Bilhete>> getBilhetes() async {
    return await _bilheteModel.getBilhetes();
  }

   Future<List<Bilhete>> getBilhetesPorCliente(int clientId) async {
    return await _bilheteModel.getBilhetePorCliente(clientId);
  }
}
