// lib/controllers/database_helper.dart
import 'package:path/path.dart';
import 'package:sistema_bilheteira/model/cliente_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'clients.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE clients(id INTEGER PRIMARY KEY, name TEXT, email TEXT, telefone TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertClient(Cliente cliente) async {
    final db = await database;
    cliente.id = DateTime.now().microsecondsSinceEpoch;
    await db.insert('clients', cliente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Cliente>> clients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients');
    return List.generate(maps.length, (i) {
      return Cliente(
        id: maps[i]['id'],
        nome: maps[i]['name'],
        email: maps[i]['email'],
        telefone: maps[i]['telefone'],
      );
    });
  }

  Future<void> updateClient(Cliente cliente) async {
    final db = await database;
    await db.update(
      'clients',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<void> deleteClient(int id) async {
    final db = await database;
    await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
