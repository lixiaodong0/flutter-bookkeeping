enum JournalType {
  //收入
  income(name: "income", symbol: "+"),
  //支出
  expense(name: "expense", symbol: "-");

  const JournalType({required this.name, required this.symbol});

  final String name;
  final String symbol;

  static JournalType fromName(String name) {
    return JournalType.values.firstWhere((element) => element.name == name);
  }
}
