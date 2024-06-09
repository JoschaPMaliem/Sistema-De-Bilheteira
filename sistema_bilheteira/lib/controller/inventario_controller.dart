import 'package:sistema_bilheteira/model/inventario_model.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class InventarioController {
  final InventarioModel _inventarioModel = InventarioModel();

  Future<int> verificarEstoque(int productId) async {
    return await _inventarioModel.verificarEstoque(productId);
  }

  Future<List<Bilhete>> getProdutosAbaixoReorderPoint(int reorderPoint) async {
    return await _inventarioModel.getProdutosAbaixoReorderPoint(reorderPoint);
  }

    Future<List<Bilhete>> getTodosProdutos() async {
    return await _inventarioModel.getTodosProdutos();
  }

  
}
