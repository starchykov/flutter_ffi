import 'package:flutter_ffi/domain/clients/database/database_client.dart';
import 'package:flutter_ffi/domain/table/tbl_boxes.dart';

class ScanDataProvider {
  final TblRecognized _tblRecognized = TblRecognized();

  String get _tableName => _tblRecognized.getTableName;

  Future<void> savePlate({
    required String username,
    required String plateNumber,
    required String location,
    required String modifiedDate,
    required String recognizedImagePath,
  }) async {
    Map<String, dynamic> dataToDb = {};
    dataToDb['USERNAME'] = username;
    dataToDb['PLATENUMBER'] = plateNumber;
    dataToDb['LOCATION'] = location;
    dataToDb['MODIFIEDDATE'] = modifiedDate;
    dataToDb['RECOGNIZEDIMAGEPATH'] = recognizedImagePath;

    const String where = 'PLATENUMBER = ?';
    final List<dynamic> args = [plateNumber];

    int count = await DatabaseClient.database.count(_tableName, where, args);

    if (count == 0) {
      int id = await DatabaseClient.database.insert(_tableName, dataToDb);
    }

    if (count > 0) {
      int id = await DatabaseClient.database.update(_tableName, dataToDb, where, args);
    }
  }

  Future<List<Map<String, dynamic>>> getPlates() async {
    await DatabaseClient.database.open();
    List<Map<String, dynamic>> data;
    data = await DatabaseClient.database.query(_tableName, _tblRecognized.getTableColumnsList(), null, null, 'ID DESC');
    return data;
  }

  Future<void> deletePlates() async {
    await DatabaseClient.database.clearDB();
  }

}
