import 'package:bookkeeping/data/bean/journal_type.dart';

class JournalProjectEntry {
  final int? id; //主键可为空，自动生成
  final JournalType journalType;
  final String name; //类型名称
  final String source; //来源
  final int sort; //排序

  JournalProjectEntry({
    this.id,
    required this.journalType,
    required this.name,
    this.source = "",
    this.sort = 0,
  });

  factory JournalProjectEntry.fromJson(Map<String, dynamic> json) =>
      JournalProjectEntry(
        id: json['id'],
        name: json['name'],
        source: json['source'] ?? "",
        journalType: JournalType.fromName(json['journalType']),
        sort: json['sort'] ?? 0,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'journalType': journalType.name,
      'sort': sort,
    };
  }
}
