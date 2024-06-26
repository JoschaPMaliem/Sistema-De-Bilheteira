import 'package:sistema_bilheteira/model/baseDeDados.dart';
import 'package:sistema_bilheteira/model/produto_model.dart';
import 'package:sqflite/sqflite.dart';

class InventarioModel {
  Future<Database> get _database async {
    return await BaseDeDados().database;
  }

    Future<List<Bilhete>> getTodosProdutos() async {
    final db = await BaseDeDados().database;
    final result = await db.query('bilhetes');
    
    return result.map((json) {
      return Bilhete(
        id: json['id'] as int?,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String,
        dataDoEvento: DateTime.parse(json['dataDoEvento'] as String),
        preco: json['preco'] as double,
        status: json['status'] as String,
        estoque: json['estoque'] as int?,
      );
    }).toList();
  }

  Future<int> verificarEstoque(int productId) async {
    final db = await _database;
    final result = await db.query(
      'bilhetes',
      columns: ['estoque'],
      where: 'id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty ? result.first['estoque'] as int : 0;
  }

  Future<List<Bilhete>> getProdutosAbaixoReorderPoint(int reorderPoint) async {
    final db = await _database;
    final result = await db.query(
      'bilhetes',
      where: 'estoque < ?',
      whereArgs: [reorderPoint],
    );

    return result.map((json) {
      return Bilhete(
        id: json['id'] as int?,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String,
        dataDoEvento: DateTime.parse(json['dataDoEvento'] as String),
        preco: json['preco'] as double,
        status: json['status'] as String,
        estoque: json['estoque'] as int?,
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getProdutosMaisVendidos() async {
    final db = await _database;
    final result = await db.rawQuery('''
      SELECT bilhetes.*, SUM(vendas.quantidade) as quantidadeVendida 
      FROM bilhetes 
      LEFT JOIN vendas ON bilhetes.id = vendas.bilheteId 
      GROUP BY bilhetes.id 
      ORDER BY quantidadeVendida DESC
    ''');

    return result;
  }
}
