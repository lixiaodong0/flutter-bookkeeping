//表格工具类
//操作文档：https://help.syncfusion.com/flutter/xlsio/getting-started
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/bean/journal_bean.dart';

typedef OnCreateExcel = void Function(Workbook workbook);

class ExcelUtil {
  static Future<void> saveToExcel(List<JournalBean> data) async {
    createExcel((workbook) {
      final Worksheet sheet = workbook.worksheets[0];
      final excelDataRows =
          data.map<ExcelDataRow>((JournalBean item) {
            return ExcelDataRow(
              cells: [
                ExcelDataCell(
                  columnHeader: "类型",
                  value: item.journalProjectName,
                ),
                ExcelDataCell(
                  columnHeader: "价格",
                  value: "${item.type.symbol}${item.amount}",
                ),
                ExcelDataCell(columnHeader: "日期", value: item.date),
                ExcelDataCell(columnHeader: "描述", value: item.description),
              ],
            );
          }).toList();
      sheet.importData(excelDataRows, 1, 1);
      final Style style = workbook.styles.add("style1");
      style.numberFormat = "yyyy-mm-dd hh:mm:ss";
      sheet.getRangeByName("C1:C${excelDataRows.length + 1}").cellStyle = style;

      sheet.autoFitColumn(3);
    });
  }

  static Future<void> createExcel(
    OnCreateExcel onCreate, {
    String excelName = "Output",
    Directory? directory,
  }) async {
    final Workbook workbook = Workbook();
    onCreate.call(workbook);
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();
    directory ??= await getExternalStorageDirectory();
    final path = directory!.path;
    File file = File('$path/$excelName.xlsx');
    await file.writeAsBytes(bytes, flush: true);
    print("createExcel:${file.absolute.path}");
  }
}
