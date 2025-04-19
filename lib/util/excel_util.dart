//表格工具类
//操作文档：https://help.syncfusion.com/flutter/xlsio/getting-started
import 'dart:collection';
import 'dart:io';

import 'package:bookkeeping/data/bean/export_params.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../data/bean/journal_bean.dart';

typedef OnCreateExcel = void Function(Workbook workbook);
typedef OnCreateStyle = void Function(Style style);

enum ExcelCellType {
  journalType,
  projectName,
  amount,
  date,
  description;

  String get name {
    switch (this) {
      case ExcelCellType.journalType:
        return "类型";
      case ExcelCellType.projectName:
        return "分类";
      case ExcelCellType.amount:
        return "金额";
      case ExcelCellType.date:
        return "日期";
      case ExcelCellType.description:
        return "描述";
    }
  }
}

class ExcelUtil {
  static ExcelDataRow _toExcelDataRow(
    Map<ExcelCellType, String> cellReferenceMap,
    JournalBean item,
  ) {
    List<ExcelDataCell> cells = [];
    for (var entries in cellReferenceMap.entries) {
      cells.add(_toExcelDataCell(entries.key, item));
    }
    return ExcelDataRow(cells: cells);
  }

  static ExcelDataCell _toExcelDataCell(
    ExcelCellType cellType,
    JournalBean item,
  ) {
    if (cellType == ExcelCellType.date) {
      return ExcelDataCell(columnHeader: cellType.name, value: item.date);
    }
    if (cellType == ExcelCellType.journalType) {
      var name = item.type == JournalType.expense ? "支出" : "入账";
      return ExcelDataCell(columnHeader: cellType.name, value: name);
    }
    if (cellType == ExcelCellType.projectName) {
      return ExcelDataCell(
        columnHeader: cellType.name,
        value: item.journalProjectName,
      );
    }
    if (cellType == ExcelCellType.description) {
      return ExcelDataCell(
        columnHeader: cellType.name,
        value: item.description,
      );
    }
    if (cellType == ExcelCellType.amount) {
      var amount =
          item.type == JournalType.expense
              ? num.parse("-${item.amount}")
              : num.parse(item.amount);
      return ExcelDataCell(columnHeader: cellType.name, value: amount);
    }
    return ExcelDataCell(columnHeader: "未定义", value: "");
  }

  static Future<void> exportJournalDataToExcel(
    ExportParams params,
    List<JournalBean> data,
  ) async {
    String createExcelName = params.exportCreateExcelName;

    createExcel(excelName: createExcelName, (workbook) {
      final Worksheet sheet = workbook.worksheets[0];
      int totalRows = 0;

      //方便调换顺序，用个有顺序的map维护映射关系。
      LinkedHashMap<ExcelCellType, String> cellReferenceMap =
          LinkedHashMap.from({
            ExcelCellType.date: "A",
            ExcelCellType.journalType: "B",
            ExcelCellType.projectName: "C",
            ExcelCellType.description: "D",
            ExcelCellType.amount: "E",
          });

      final excelDataRows =
          data.map<ExcelDataRow>((JournalBean item) {
            return _toExcelDataRow(cellReferenceMap, item);
          }).toList();
      sheet.importData(excelDataRows, 1, 1);

      if (excelDataRows.isEmpty) {
        return;
      }

      totalRows += excelDataRows.length + 1;

      var centerStyle = addCenterStyle(workbook);

      //产品整列样式配置
      var projectReference = cellReferenceMap[ExcelCellType.projectName];
      var projectColumns = sheet.getRangeByName(
        "${projectReference}2:$projectReference$totalRows",
      );
      projectColumns.cellStyle = centerStyle;
      projectColumns.autoFitColumns();

      //日期整列样式配置
      var dateReference = cellReferenceMap[ExcelCellType.date];
      var dateColumns = sheet.getRangeByName(
        "${dateReference}2:$dateReference${excelDataRows.length + 1}",
      );
      dateColumns.cellStyle = addStyle(workbook, "dateStyle", (Style style) {
        style.hAlign = HAlignType.center;
        style.vAlign = VAlignType.center;
        // style.numberFormat = "m/d/yy h:mm";
        // style.numberFormat = "m/d/yy h:mm AM/PM";
        // style.numberFormat = "m/d/yyyy h:mm AM/PM";
        style.numberFormat = "m/d/yyyy h:mm";
      });
      dateColumns.autoFitColumns();

      //类型整列样式配置
      var typeReference = cellReferenceMap[ExcelCellType.journalType];
      var typeColumns = sheet.getRangeByName(
        "${typeReference}2:$typeReference$totalRows",
      );
      typeColumns.cellStyle = centerStyle;
      typeColumns.autoFitColumns();

      //金额整列样式配置
      var amountReference = cellReferenceMap[ExcelCellType.amount];
      var amountCellReference =
          "${amountReference}2:$amountReference$totalRows";
      var amountColumns = sheet.getRangeByName(amountCellReference);
      amountColumns.cellStyle = addStyle(workbook, "amountStyle", (
        Style style,
      ) {
        style.numberFormat = '¥#,##0.00';
      });
      amountColumns.autoFitColumns();

      //描述整列样式配置
      var descriptionReference = cellReferenceMap[ExcelCellType.description];
      var descriptionColumns = sheet.getRangeByName(
        "${descriptionReference}2:$descriptionReference$totalRows",
      );
      descriptionColumns.cellStyle = centerStyle;
      descriptionColumns.autoFitColumns();

      //表头整行头部配置
      var firstReference = cellReferenceMap.entries.first.value;
      var endReference = cellReferenceMap.entries.last.value;
      var headerColumns = sheet.getRangeByName(
        "${firstReference}1:${endReference}1",
      );
      headerColumns.cellStyle = addStyle(workbook, "headerStyle", (
        Style style,
      ) {
        style.hAlign = HAlignType.center;
        style.vAlign = VAlignType.center;
        style.backColorRgb = Colors.green;
        style.fontColorRgb = Colors.white;
        style.fontSize = 12;
        style.bold = true;
      });
      headerColumns.rowHeight = 30;
      totalRows++;

      //开启公式计算
      sheet.enableSheetCalculations();
      //添加统计行
      var endRow = sheet.getRangeByName(
        "$firstReference$totalRows:$endReference$totalRows",
      );
      //合并单元格
      endRow.merge();
      endRow.setFormula('="总计：" & SUM($amountCellReference)');
      endRow.cellStyle = addCenterStyle(
        workbook,
        styleName: "endRowStyle",
        onCreateStyle: (style) {
          style.backColorRgb = Colors.green;
          style.fontColorRgb = Colors.white;
          style.fontSize = 12;
          style.bold = true;
        },
      );
      endRow.rowHeight = 30;
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
    if (excelName.isEmpty) {
      excelName = "Output";
    }
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
