enum JournalType {
  //收入
  income(name: "income"),
  //支出
  expense(name: "expense");

  const JournalType({required this.name});

  final String name;

  static JournalType fromName(String name) {
    return JournalType.values.firstWhere((element) => element.name == name);
  }
}
