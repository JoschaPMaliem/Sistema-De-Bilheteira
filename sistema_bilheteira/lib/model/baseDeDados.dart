import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDeDados {
  static final BaseDeDados _instance = BaseDeDados._internal();
  static Database? _database;

  factory BaseDeDados() {
    return _instance;
  }

  BaseDeDados._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bilheteira_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clientes (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        email TEXT NOT NULL,
        telefone TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bilhetes (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        dataDoEvento TEXT NOT NULL,
        preco REAL NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE vendas (
        id INTEGER PRIMARY KEY,
        clienteId INTEGER NOT NULL,
        bilheteId INTEGER NOT NULL,
        quantidade INTEGER NOT NULL,
        valorTotal REAL NOT NULL,
        dataVenda TEXT NOT NULL,
        FOREIGN KEY (bilheteId) REFERENCES bilhetes (id),
        FOREIGN KEY (clienteId) REFERENCES clientes (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE cliente_login (
        id INTEGER PRIMARY KEY,
        clienteId INTEGER NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        FOREIGN KEY (clienteId) REFERENCES clientes (id)
      )
    ''');
  }
}
