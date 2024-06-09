import 'package:sistema_bilheteira/model/inventario_model.dart';
import 'package:sistema_bilheteira/model/venda_model.dart';

class RelatorioController {
  final InventarioModel inventarioModel;
  final VendaModel vendaModel;

  RelatorioController(this.inventarioModel, this.vendaModel);

  Future<Map<String, dynamic>> gerarRelatorioEstoque() async {
    final inventory = await inventarioModel.getProdutosAbaixoReorderPoint(0);
    return {
      'title': 'Relatório de Estoque',
      'data': inventory,
    };
  }

 Future<Map<String, dynamic>> gerarRelatorioVenda() async {
    final sales = await inventarioModel.getProdutosMaisVendidos();
    return {
      'title': 'Relatório de Vendas',
      'data': sales,
    };
  }
}
