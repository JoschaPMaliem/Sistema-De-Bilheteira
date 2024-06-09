import 'baseDeDados.dart';

class Cliente {
  int? id;
  final String nome;
  final String email;
  final String telefone;

  Cliente(
      {this.id,
      required this.nome,
      required this.email,
      required this.telefone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'email': email, 'telefone': telefone};
  }

  @override
  String toString() {
    return 'Cliente{id: $id,  nome: $nome, email: $email, telefone: $telefone}';
    //
  }
}

class ClienteModel {
  Future<int> criarCliente(Cliente cliente) async {
    final db = await BaseDeDados().database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<int> atualizarCliente(Cliente cliente) async {
    final db = await BaseDeDados().database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> apagarCliente(int id) async {
    final db = await BaseDeDados().database;
    return await db.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Cliente>> getClientes() async {
    final db = await BaseDeDados().database;
    final result = await db.query('clientes');

    return result
        .map((json) => Cliente(
              id: json['id'] as int,
              nome: json['nome'] as String,
              email: json['email'] as String,
              telefone: json['telefone'] as String,
            ))
        .toList();
  }

  Future<Cliente?> getClienteById(int id) async {
    final db = await BaseDeDados().database;
    final result = await db.query('clientes', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Cliente(
        id: result.first['id'] as int,
        nome: result.first['nome'] as String,
        email: result.first['email'] as String,
        telefone: result.first['telefone'] as String,
      );
    }
    return null;
  }


}
