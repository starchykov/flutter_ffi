import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_ffi/domain/table/tbl_boxes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  DatabaseClient._();

  static final DatabaseClient database = DatabaseClient._();

  factory DatabaseClient() {
    return database;
  }

  final String _databaseName = 'box_storage.db';
  static late Database _database;

  final int _databaseVersion = 1;

  final TblRecognized _tblRecognized = TblRecognized();

  Future<Database> open() async {
    WidgetsFlutterBinding.ensureInitialized();

    log('Database $_databaseName opened. DB version $_databaseVersion', name: 'Database client');

    String defaultPath = await getDatabasesPath();

    _database = await openDatabase(
      join(defaultPath, _databaseName),
      onCreate: (db, version) => _createDatabase(db, version),
      onUpgrade: (db, oldVersion, newVersion) => _createDatabase(db, oldVersion),
      version: _databaseVersion,
    );

    return Future.value(_database);
  }

  /// When creating the database, create the table
  Future<void> _createDatabase(Database db, int version) async {
    Batch batch = db.batch();

    List tables = [_tblRecognized];

    for (var table in tables) {
      String creatingScript = table.getCreateSQLQuery();
      if (creatingScript.isNotEmpty) batch.execute(creatingScript);
    }

    await batch.commit(noResult: false);
  }

  Future<void> clearDB() async {
    Batch batch = _database.batch();

    List databases = [_tblRecognized];

    for (var database in databases) {
      String deleteScript = database.getStringForDeleteFromTable();
      if (deleteScript.isNotEmpty) batch.execute(deleteScript);
    }

    await batch.commit();
  }

  /// Inserts a row into the specified table with the given values.
  /// If a row with the same primary key already exists, it will be replaced.
  ///
  /// - [table]: The name of the table to insert the row into.
  /// - [values]: A map of column names to values representing the row to be inserted.
  ///
  /// Throws a [DatabaseException] if the insertion failed.
  ///
  /// Returns the ID of the inserted row.
  Future<int> insert(String table, Map<String, dynamic> values) async {
    Database database = _database;
    int id = await database.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
    return Future.value(id);
  }

  /// Updates rows in the given [table] with the [values] provided,
  /// that match the given [where] clause and [whereArgs] list of arguments.
  ///
  /// - [table]: a [String] representing the name of the table to update.
  /// - [values]: a [Map<String, dynamic>] representing the new values to set in the table.
  /// - [where]: a [String] representing the WHERE clause of the update statement.
  /// - [whereArgs]: a [List<dynamic>] representing the values to substitute in the WHERE clause.
  ///
  /// Returns a Future<int> that resolves to the number of rows  updated.
  ///
  /// The [conflictAlgorithm] parameter determines what should happen in case of a conflict.
  ///
  /// Logs the update query using the [log] function with the 'Database provider' tag.
  Future<int> update(String table, Map<String, dynamic> values, String where, List<dynamic> whereArgs) async {
    Database db = _database;
    log('Update query to $table where $where = $whereArgs', name: 'Database provider');
    int count = await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Future.value(count);
  }

  /// A method that queries a SQLite database table for specific columns, with optional conditions and order by.
  ///
  /// - [table]: the name of the table to query.
  /// - [columns]: a list of column names to retrieve.
  /// - [where]: an optional WHERE clause to filter the results.
  /// - [whereArgs]: optional arguments to substitute for placeholders in the WHERE clause.
  /// - [orderBy]: an optional column to order the results by. If null or empty, defaults to "ID".
  ///
  /// Returns a Future that resolves to a list of Maps containing the query results, with column names as keys and values as dynamic.
  Future<List<Map<String, dynamic>>> query(
    String table,
    List<String> columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  ) async {
    Database db = _database;
    String orderBy0 = ((orderBy == null) || (orderBy.isEmpty)) ? 'ID' : orderBy;
    log('Database query to $table where $where = $whereArgs orderBy $orderBy0', name: 'Database provider');
    List<Map<String, dynamic>> data = await db.query(table, columns: columns, where: where, whereArgs: whereArgs, orderBy: orderBy0);
    return Future.value(data);
  }

  /// Counts the number of rows in the specified table that match the given `where` clause.
  ///
  /// - [table]: the name of the table to count rows from.
  /// - [where]: the optional filter to apply on the rows.
  /// - [whereArgs]: the arguments to substitute in the `where` filter.
  ///
  /// Returns a Future<int> that resolves to the number of rows that match the `where` filter.
  Future<int> count(String table, String where, List<dynamic> whereArgs) async {
    Database db = _database;
    List<Map<String, dynamic>> data = await db.query(table, columns: ['ID'], where: where, whereArgs: whereArgs);
    return Future.value(data.length);
  }
}
