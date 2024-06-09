import 'package:sistema_bilheteira/model/baseDeDados.dart';
import 'package:sqflite/sqflite.dart';

class Bilhete {
  int? id;
  final String nome;
  final String descricao;
  final DateTime dataDoEvento;
  final double preco;
  final String status;
  int? estoque;

  Bilhete({
    this.id,
    required this.nome,
    required this.descricao,
    required this.dataDoEvento,
    required this.preco,
    required this.status,
     this.estoque,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'dataDoEvento': dataDoEvento.toIso8601String(),
      'preco': preco,
      'status': status,
      'estoque': estoque
    };
  }

  @override
  String toString() {
    return 'Bilhete{id: $id, nome: $nome, descricao: $descricao, dataDoEvento: $dataDoEvento, preco: $preco, status: $status, estoque: $estoque}';
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
        estoque: json['estoque'] as int,
      );
    }).toList();
  }

    Future<Bilhete?> getBilheteById(int id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bilhetes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Bilhete(
      id: maps[0]['id'] as int?,
      nome: maps[0]['nome'] as String,
      descricao: maps[0]['descricao'] as String,
      dataDoEvento: DateTime.parse(maps[0]['dataDoEvento'] as String),
      preco: maps[0]['preco'] as double,
      status: maps[0]['status'] as String,
      estoque: maps[0]['estoque'] as int,
    );
  }

   Future<List<Bilhete>> getBilhetePorCliente(int clientId) async {
    final db = await BaseDeDados().database;
    final List<Map<String, dynamic>> bilheteMaps = await db.rawQuery('''
      SELECT b.id
      FROM vendas AS v
      INNER JOIN bilhetes AS b ON v.bilheteId = b.id
      WHERE v.clienteId = ?
    ''', [clientId]);

    final BilheteModel _bilheteModel = BilheteModel(); // Create an instance of BilheteModel
    final List<Bilhete> bilhetes = [];

    for (final bilheteMap in bilheteMaps) {
      final int bilheteId = bilheteMap['id'] as int;
      final Bilhete? bilhete = await _bilheteModel.getBilheteById(bilheteId);
      if (bilhete != null) {
        bilhetes.add(bilhete);
      }
    }

    return bilhetes;
  }

  

}	
