import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dictionary_item.dart';
import '../data/initial_ambon_data.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ambon_dictionary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dictionary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ambon TEXT NOT NULL,
        indonesia TEXT NOT NULL,
        english TEXT,
        category TEXT NOT NULL,
        description TEXT
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final Batch batch = db.batch();
    
    // Gunakan data dari initial_ambon_data.dart
    final initialData = getInitialAmbonData();
    
    for (var item in initialData) {
      batch.insert('dictionary', item);
    }
    
    await batch.commit();
  }

  Future<List<DictionaryItem>> searchWords(String query, String fromLang, String toLang) async {
    final db = await database;
    
    String columnFrom;
    switch (fromLang) {
      case 'Ambon': columnFrom = 'ambon'; break;
      case 'Indonesia': columnFrom = 'indonesia'; break;
      case 'Inggris': columnFrom = 'english'; break;
      default: columnFrom = 'indonesia';
    }
    
    final List<Map<String, dynamic>> maps = await db.query(
      'dictionary',
      where: '$columnFrom LIKE ?',
      whereArgs: ['%$query%'],
    );
    
    return List.generate(maps.length, (i) {
      return DictionaryItem.fromMap(maps[i]);
    });
  }

  Future<int> addWord(DictionaryItem word) async {
    final db = await database;
    return await db.insert('dictionary', word.toMap());
  }

  Future<int> updateWord(DictionaryItem word) async {
    final db = await database;
    return await db.update(
      'dictionary',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<int> deleteWord(int id) async {
    final db = await database;
    return await db.delete(
      'dictionary',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<DictionaryItem>> getAllWords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dictionary');
    return List.generate(maps.length, (i) {
      return DictionaryItem.fromMap(maps[i]);
    });
  }
}