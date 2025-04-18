import 'package:bookkeeping/data/bean/journal_type.dart';

class ExportParams {
  //账本ID
  int accountBookId;

  //账单开始时间
  DateTime startDate;

  //账单结束时间
  DateTime endDate;

  //账单收支类型 如果null则查询所有
  JournalType? journalType;

  //账单产品分类
  int? projectId;

  ExportParams({
    required this.accountBookId,
    required this.startDate,
    required this.endDate,
    this.journalType,
    this.projectId,
  });
}
