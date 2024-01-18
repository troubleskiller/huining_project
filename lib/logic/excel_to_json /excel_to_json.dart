import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Uint8List?> pickExcelCsv({
  String pickTitle = "Pick File",
}) async {
  final picker = FilePicker.platform;

  final FilePickerResult? result = await picker.pickFiles(
    allowCompression: false,
    allowMultiple: false,
    withData: true,
    allowedExtensions: [
      'xlsx',
    ],
    type: FileType.custom,
    dialogTitle: pickTitle,
  );

  if (result != null) {
    return result.files.first.bytes;
  }

  return null;
}

List<Map<String, dynamic>> extractDataFromExcel({required Uint8List bytes}) {
  Excel excel = Excel.decodeBytes(bytes);
  final List<Map<String, dynamic>> result = [];
  final Map<String, dynamic> createMap = {};
  final keys = <String>[];

  // get data from first sheet
  final int n = excel.tables[excel.tables.keys.first]?.rows.length ?? 0;
  debugPrint('n => $n');
  // final List<Data?> rows in excel.tables[excel.tables.keys.first]!.rows
  for (int i = 0; i < n; i++) {
    final rows = excel.tables[excel.tables.keys.first]!.rows[i];
    for (int j = 0; j < rows.length; j++) {
      // index = 0 it will show an header of sheet
      final row = rows[j];
      // Create Header(Keys) for map
      if (i == 0 && row != null) {
        // get header/key from excel and make it list
        keys.add('${row.value}'); // Store key as string
        // Default value is empty
        createMap['${row.value}'] = "";
      }
      // add value in map
      else if (i > 0 && row != null) {
        createMap[keys[j]] = row.value;
      }
    }

    // Now We have make ready
    // we have multiple map/json
    // we we can make list of map/json
    // we add map have key and value both => add if i!=0

    if (i != 0) result.add(Map<String, dynamic>.from(createMap));
  }
  return result;
}
