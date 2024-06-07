import 'package:sistema_bilheteira/model/baseDeDados.dart';
import 'package:sistema_bilheteira/model/inventario_model.dart';
import 'package:sqflite/sqflite.dart';

class Bilhete {
  int? id;
  final String nome;
  final String descricao;
  final DateTime dataDoEvento;
  final double preco;
  final String status;

  Bilhete({
    this.id,
    required this.nome,
    required this.descricao,
    required this.dataDoEvento,
    required this.preco,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'dataDoEvento': dataDoEvento.toIso8601String(),
      'preco': preco,
      'status': status
    };
  }

  @override
  String toString() {
    return 'Bilhete{id: $id, nome: $nome, descricao: $descricao, dataDoEvento: $dataDoEvento, preco: $preco, status: $status}';
  }
}

class BilheteModel {
  Future<Database> get _database async {
    return await BaseDeDados().database;
  }

  Future<int> criarBilhete(Bilhete bilhete) async {
    final db = await _database;
    return await db.insert('bilhetes', bilhete.toMap());
  }

  Future<int> atualizarBilhete(Bilhete bilhete) async {
    final db = await _database;
    return await db.update(
      'bilhetes',
      bilhete.toMap(),
      where: 'id = ?',
      whereArgs: [bilhete.id],
    );
  }

  Future<int> apagarBilhete(int id) async {
    final db = await _database;
    return await db.delete(
      'bilhetes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Bilhete>> getBilhetes() async {
    final db = await _database;
    final result = await db.query('bilhetes');

    return result.map((json) {
      return Bilhete(
        id: json['id'] as int?,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String,
        dataDoEvento: DateTime.parse(json['dataDoEvento'] as String),
        preco: json['preco'] as double,
        status: json['status'] as String,
      );
    }).toList();
  }

  Future<List<Inventario>> verificarEstoque() async {
    final db = await BaseDeDados().database;
    final result = await db.rawQuery('''
      SELECT bilhetes.*, COUNT(vendas.id) as estoque 
      FROM bilhetes 
      LEFT JOIN vendas ON bilhetes.id = vendas.bilheteId 
      GROUP BY bilhetes.id
    ''');

    return result.map((json) {
      return Inventario(
        bilhete: Bilhete(
          id: json['id'] as int,
          nome: json['nome'] as String,
          descricao: json['descricao'] as String,
          dataDoEvento: DateTime.parse(json['dataDoEvento'] as String),
          preco: json['preco'] as double,
          status: json['status'] as String,
        ),
        estoque: json['estoque'] as int,
      );
    }).toList();
  }
}
