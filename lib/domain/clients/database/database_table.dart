abstract class Table {
  static const String SQL_TYPE_INTEGER = 'INTEGER';
  static const String SQL_TYPE_REAL = 'REAL';
  static const String SQL_TYPE_TEXT = 'TEXT';
  static const String SQL_TYPE_BLOB = 'BLOB';

  String _tableName = '';

  Map<String, String> _databaseColumns = Map();

  String get getTableName => _tableName;

  void setTableName(String tableName) => _tableName = tableName;

  void setColumns(Map<String, String> columns) => _databaseColumns = columns;

  @override
  String toString() => _databaseColumns.toString();

  ///method returns a List with all columns
  List<String> getTableColumnsList() {
    List<String> result = <String>[];
    if (_databaseColumns.isEmpty) return result;
    for (var key in _databaseColumns.keys) {
      result.add(key);
    }
    return result;
  }


  /// Create table action.
  /// Method returns a SQL query string for creating table. All table columns separated by comma.
  String getCreateSQLQuery() {
    String tableColumns = '';

    /// Add all table columns to create a query string.
    _databaseColumns.forEach((String key, String value) {
      String isAutoincrement = key.toUpperCase() == 'ID' ? 'PRIMARY KEY AUTOINCREMENT' : '';
      tableColumns = '$tableColumns${key.toUpperCase()} ${value.toUpperCase()} $isAutoincrement,';
    });

    /// Delete last coma symbol from query string.
    if (tableColumns[tableColumns.length - 1] == ',') {
      tableColumns = tableColumns.substring(0, tableColumns.length - 1);
    }

    /// Return full SQL query string for create table.
    return 'CREATE TABLE IF NOT EXISTS $getTableName ($tableColumns);';
  }

  ///method returns a String with all columns comma separated
  ///Table clearing action
  String getStringForDeleteFromTable() {
    String result = 'DELETE FROM $getTableName;';
    return result;
  }
}
