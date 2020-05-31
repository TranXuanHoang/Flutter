import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class Column {
  final String name;
  final String dataType;
  final bool isPrimaryKey;

  Column({
    @required this.name,
    this.dataType = 'TEXT',
    this.isPrimaryKey = false,
  });

  String get sqlDefinition {
    return '$name $dataType${isPrimaryKey ? ' PRIMARY KEY' : ''}';
  }
}

class Table {
  final String name;
  final List<Column> columns;

  Table({@required this.name, @required this.columns});

  String get createTableQuery {
    return 'CREATE TABLE $name (${columns.map((col) => col.sqlDefinition).join(', ')})';
  }
}

class DBHelper {
  static const DATABASE_NAME = 'places';

  static final List<Table> tables = [
    Table(
      name: 'user_places',
      columns: [
        Column(name: 'id', isPrimaryKey: true),
        Column(name: 'title'),
        Column(name: 'image'),
        Column(name: 'loc_lat', dataType: 'REAL'),
        Column(name: 'loc_lng', dataType: 'REAL'),
        Column(name: 'address'),
      ],
    ),
  ];

  static Future<sql.Database> database() async {
    // Get a location of the database
    final dbPath = await sql.getDatabasesPath();
    print('dbPath: $dbPath');

    // Open the database
    return sql.openDatabase(
      path.join(dbPath, '${DBHelper.DATABASE_NAME}.db'),
      version: 1,
      onCreate: (db, version) {
        tables.forEach((table) async {
          print('onCreate table: ${table.name}');
          print('${table.createTableQuery}');
          await db.execute('${table.createTableQuery}');
        });
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final database = await DBHelper.database();

    // Insert data into the database.
    // If the same key record exists, replace it with the new one
    var insertResult = await database.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    print('insertResult: $insertResult');
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final database = await DBHelper.database();

    // Get all data from the given table
    return database.query(table);
  }
}
