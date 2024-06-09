import 'package:sistema_bilheteira/model/baseDeDados.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';

class Venda {
  int? id;
  int id_cliente;
  int? id_bilhete;
  int? quantidade;
  double? valorTotal;
  String? dataVenda;

  Venda(
      {required this.id,
      required this.id_cliente,
      required this.id_bilhete,
      required this.quantidade,
      required this.valorTotal,
      required this.dataVenda});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': id_cliente,
      'bilheteId': id_bilhete,
      'quantidade': quantidade,
      'valorTotal': valorTotal,
      'dataVenda': dataVenda
    };
  }

  @override
  String toString() {
    return 'Venda{id: $id, clienteId: $id_cliente, bilheteId: $id_bilhete, quantidade: $quantidade, valorTotal: $valorTotal, dataVenda: $dataVenda}';
  }
}

class VendaModel {
  Future<int> criarVenda(Venda venda) async {
    final db = await BaseDeDados().database;
    
    return await db.insert('vendas', venda.toMap());
  }

  Future<int> atualizarVenda(Venda venda) async {
    final db = await BaseDeDados().database;
    return await db.update(
      'vendas',
      venda.toMap(),
      where: 'id = ?',
      whereArgs: [venda.id],
    );
  }

  Future<int> apagarVenda(int id) async {
    final db = await BaseDeDados().database;
    return await db.delete(
      'vendas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Venda>> getVendas() async {
    final db = await BaseDeDados().database;
    final result = await db.query('vendas');

    return result
        .map((json) => Venda(
            id: json['id'] as int,
            id_bilhete: json['clienteId'] as int,
            id_cliente: json['bilheteId'] as int,
            quantidade: json['quantidade'] as int,
            valorTotal: json['valorTotal'] as double,
            dataVenda: json['dataVenda'] as String))
        .toList();
  }

  Future<List<Bilhete>> getBilhetesPorCliente(int clienteId) async {
    final db = await BaseDeDados().database;
    final result = await db.rawQuery(
      'SELECT bilhetes.* FROM bilhetes INNER JOIN vendas ON bilhetes.id = vendas.bilheteId WHERE vendas.clienteId = ?',
      [clienteId],
    );

    return result
        .map((json) => Bilhete(
              id: json['id'] as int,
              nome: json['nome'] as String,
              descricao: json['descricao'] as String,
              dataDoEvento: DateTime.parse(json['dataDoEvento'] as String),
              preco: json['preco'] as double,
              status: json['status'] as String,
              estoque: json['estoque'] as int,
            ))
        .toList();
  }
}
