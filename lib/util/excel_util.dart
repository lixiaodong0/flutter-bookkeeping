//表格工具类
//操作文档：https://help.syncfusion.com/flutter/xlsio/getting-started
import 'dart:io';

import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/bean/journal_bean.dart';

typedef OnCreateExcel = void Function(Workbook workbook);
typedef OnCreateStyle = void Function(Style style);

class ExcelUtil {
  static Future<void> saveToExcel(List<JournalBean> data) async {
    createExcel((workbook) {
      final Worksheet sheet = workbook.worksheets[0];
      int totalRows = 0;
      final excelDataRows =
          data.map<ExcelDataRow>((JournalBean item) {
            var amount =
                item.type == JournalType.expense
                    ? num.parse("-${item.amount}")
                    : num.parse(item.amount);
            return ExcelDataRow(
              cells: [
                ExcelDataCell(
                  columnHeader: "类型",
                  value: item.journalProjectName,
                ),
                ExcelDataCell(columnHeader: "金额", value: amount),
                ExcelDataCell(columnHeader: "日期", value: item.date),
                ExcelDataCell(columnHeader: "描述", value: item.description),
              ],
            );
          }).toList();
      sheet.importData(excelDataRows, 1, 1);

      if (excelDataRows.isEmpty) {
        return;
      }

      totalRows += excelDataRows.length + 1;

      var centerStyle = addCenterStyle(workbook);

      //类型整列样式配置
      var typeColumns = sheet.getRangeByName("A2:A$totalRows");
      typeColumns.cellStyle = centerStyle;
      typeColumns.autoFitColumns();

      //金额整列样式配置
      var amountCellReference = "B2:B$totalRows";
      var amountColumns = sheet.getRangeByName(amountCellReference);
      amountColumns.cellStyle = addStyle(workbook, "amountStyle", (
        Style style,
      ) {
        style.numberFormat = '¥#,##0.00';
      });
      amountColumns.autoFitColumns();

      //日期整列样式配置
      var dateColumns = sheet.getRangeByName("C2:C${excelDataRows.length + 1}");
      dateColumns.cellStyle = addStyle(workbook, "dateStyle", (Style style) {
        style.hAlign = HAlignType.center;
        style.vAlign = VAlignType.center;
        style.numberFormat = "yyyy-mm-dd hh:mm:ss";
      });
      dateColumns.autoFitColumns();

      //描述整列样式配置
      var descriptionColumns = sheet.getRangeByName("D2:D$totalRows");
      descriptionColumns.cellStyle = centerStyle;
      descriptionColumns.autoFitColumns();

      //表头整行头部配置
      var headerColumns = sheet.getRangeByName("A1:D1");
      headerColumns.cellStyle = addStyle(workbook, "headerStyle", (
        Style style,
      ) {
        style.hAlign = HAlignType.center;
        style.vAlign = VAlignType.center;
        style.backColorRgb = Colors.green;
        style.fontColorRgb = Colors.white;
        style.fontSize = 16;
        style.bold = true;
      });
      totalRows++;

      //开启公式计算
      sheet.enableSheetCalculations();
      //添加统计行
      var endRow = sheet.getRangeByName("A$totalRows:D$totalRows");
      //合并单元格
      endRow.merge();
      endRow.setFormula('="总计：" & SUM($amountCellReference)');
      endRow.cellStyle = addCenterStyle(
        workbook,
        styleName: "endRowStyle",
        onCreateStyle: (style) {
          style.backColorRgb = Colors.green;
          style.fontColorRgb = Colors.white;
          style.fontSize = 16;
          style.bold = true;
        },
      );
    }, isPreview: true);
  }

  //添加样式
  //样式配置文档：https://help.syncfusion.com/flutter/xlsio/working-with-cell-formatting#create-a-style
  static Style addStyle(
    Workbook workbook,
    String styleName,
    OnCreateStyle onCreateStyle,
  ) {
    var style = workbook.styles.add(styleName);
    onCreateStyle(style);
    return style;
  }

  //添加居中样式
  static Style addCenterStyle(
    Workbook workbook, {
    String styleName = "centerStyle",
    OnCreateStyle? onCreateStyle,
  }) {
    var style = workbook.styles.add(styleName);
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    onCreateStyle?.call(style);
    return style;
  }

  //创建表格
  static Future<void> createExcel(
    OnCreateExcel onCreate, {
    String excelName = "Output",
    Directory? directory,
    bool isPreview = false,
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
    if (isPreview) {
      OpenFile.open(file.absolute.path);
    }
  }
}
