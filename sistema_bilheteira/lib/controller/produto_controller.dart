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
        estoque: 0);

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

  /*
  Future<void> verificarEstoque() async {
    final inventario = await _bilheteModel.verificarEstoque();
    for (var item in inventario) {
      print('Bilhete: ${item.bilhete.nome}, Estoque: ${item.estoque}');
    }
  }

  */

  Future<List<Bilhete>> getBilhetes() async {
    return await _bilheteModel.getBilhetes();
  }
}
