import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:bookkeeping/data/repository/datasource/account_book_datasource.dart';
import 'package:bookkeeping/db/account_book_dao.dart';
import 'package:bookkeeping/db/model/account_book_entry.dart';

class AccountBookLocalDataSource extends AccountBookDataSource {
  final AccountBookDao dao;

  AccountBookLocalDataSource({required this.dao});

  @override
  Future<int> delete(int id) {
    return dao.delete(id);
  }

  @override
  Future<AccountBookBean?> findAccountBookByName(String name) {
    return dao.findAccountBookByName(name);
  }

  @override
  Future<List<AccountBookBean>> findAll() {
    return dao.findAll();
  }

  @override
  Future<int> insert(AccountBookEntry entry) {
    return dao.insert(entry);
  }

  @override
  Future<int> setCurrentShowId(int id) {
    return dao.setCurrentShowId(id);
  }
}
