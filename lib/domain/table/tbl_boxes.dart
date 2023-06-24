import 'package:flutter_ffi/domain/clients/database/database_table.dart';

class TblRecognized extends Table {
  TblRecognized() {
    setTableName('RECOGNIZED');
    setColumns({
      'ID': 'INTEGER',
      'USERNAME': 'TEXT',
      'PLATENUMBER': 'TEXT',
      'RECOGNIZEDIMAGEPATH': 'TEXT',
      'LOCATION': 'TEXT',
      'MODIFIEDDATE': 'TEXT'
    });
  }
}
