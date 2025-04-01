class DateAmountCache {
  //私有构造函数
  DateAmountCache._();

  // 静态变量保存唯一实例
  static final DateAmountCache _instance = DateAmountCache._();

  // 工厂构造函数，提供全局访问点
  factory DateAmountCache() => _instance;

  final Map<String, AmountWrapper> _cacheMap = {};

  String _dateToKey(DateTime date) {
    return "${date.year}-${date.month}";
  }

  void putCache(DateTime date, String totalIncome, String totalExpense) {
    _cacheMap[_dateToKey(date)] = AmountWrapper(totalIncome, totalExpense);
  }

  bool hasCache(DateTime date) {
    var value = _cacheMap[_dateToKey(date)];
    return value != null;
  }

  AmountWrapper? getCache(DateTime date) {
    return _cacheMap[_dateToKey(date)];
  }

  void clearCache(DateTime date) {
    _cacheMap.remove(_dateToKey(date));
  }

  void clearAllCache() {
    _cacheMap.clear();
  }
}

class AmountWrapper {
  String incomeAmount;
  String expenseAmount;

  AmountWrapper(this.incomeAmount, this.expenseAmount);
}
