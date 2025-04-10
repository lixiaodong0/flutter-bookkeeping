import '../../db/model/account_book_entry.dart';

class AccountBookBean {
  final int id;
  final String name;
  final DateTime createDate;
  final int sysDefault;
  int show;
  final String? description;

  AccountBookBean({
    required this.id,
    required this.name,
    this.description,
    required this.createDate,
    required this.sysDefault,
    required this.show,
  });

  factory AccountBookBean.fromJson(Map<String, dynamic> json) =>
      AccountBookBean(
        id: json[AccountBookEntry.tableColumnId],
        name: json[AccountBookEntry.tableColumnName],
        createDate: DateTime.parse(
          json[AccountBookEntry.tableColumnCreateDate],
        ),
        description: json[AccountBookEntry.tableColumnDescription],
        sysDefault: json[AccountBookEntry.tableColumnSysDefault],
        show: json[AccountBookEntry.tableColumnShow],
      );
}
