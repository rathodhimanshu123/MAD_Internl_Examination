import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import '../models/voice_command_model.dart';

class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._init();
  static Database? _database;
  
  // Mock storage for web
  final List<TaskModel> _webTasks = [];
  final List<Map<String, dynamic>> _webCommands = [];

  LocalDatabaseService._init();

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
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
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE tasks ( 
  id $idType, 
  title $textType,
  description $textType,
  isCompleted $boolType,
  createdAt $textType,
  updatedAt $textType,
  isSynced $boolType
  )
''');

    await db.execute('''
CREATE TABLE commands (
  id $idType,
  type $textType,
  data $textType,
  timestamp $textType,
  processed $boolType
  )
''');
  }

  Future<void> insertTask(TaskModel task) async {
    if (kIsWeb) {
      _webTasks.removeWhere((t) => t.id == task.id);
      _webTasks.add(task);
      return;
    }
    final db = await instance.database;
    await db!.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getAllTasks() async {
    if (kIsWeb) return _webTasks;
    final db = await instance.database;
    final result = await db!.query('tasks', orderBy: 'createdAt DESC');
    return result.map((json) => TaskModel.fromMap(json)).toList();
  }

  Future<void> deleteTask(String id) async {
    if (kIsWeb) {
      _webTasks.removeWhere((t) => t.id == id);
      return;
    }
    final db = await instance.database;
    await db!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTaskSyncStatus(String id, bool isSynced) async {
    if (kIsWeb) {
      final idx = _webTasks.indexWhere((t) => t.id == id);
      if (idx != -1) _webTasks[idx] = _webTasks[idx].copyWith(isSynced: isSynced);
      return;
    }
    final db = await instance.database;
    await db!.update(
      'tasks',
      {'isSynced': isSynced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Commands management
  Future<void> insertCommand(VoiceCommandModel command) async {
    if (kIsWeb) {
      _webCommands.add(command.toMap());
      return;
    }
    final db = await instance.database;
    await db!.insert(
      'commands',
      command.toMap(),
    );
  }

  Future<List<Map<String, dynamic>>> getUnprocessedCommands() async {
    if (kIsWeb) return _webCommands.where((cmd) => cmd['processed'] == 0).toList();
    final db = await instance.database;
    return await db!.query(
      'commands',
      where: 'processed = 0',
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> markCommandProcessed(String id) async {
    if (kIsWeb) {
      final idx = _webCommands.indexWhere((cmd) => cmd['id'] == id);
      if (idx != -1) _webCommands[idx]['processed'] = 1;
      return;
    }
    final db = await instance.database;
    await db!.update(
      'commands',
      {'processed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
