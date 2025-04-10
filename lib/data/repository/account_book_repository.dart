import 'package:bookkeeping/data/bean/account_book_bean.dart';

import 'package:bookkeeping/db/model/account_book_entry.dart';

import 'datasource/account_book_datasource.dart';

class AccountBookRepository extends AccountBookDataSource {
  final AccountBookDataSource _localDataSource;

  AccountBookRepository({required AccountBookDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<int> delete(int id) {
    return _localDataSource.delete(id);
  }

  @override
  Future<AccountBookBean?> findAccountBookByName(String name) {
    return _localDataSource.findAccountBookByName(name);
  }

  @override
  Future<List<AccountBookBean>> findAll() {
    return _localDataSource.findAll();
  }

  @override
  Future<int> insert(AccountBookEntry entry) {
    return _localDataSource.insert(entry);
  }

  @override
  Future<int> setCurrentShowId(int id) {
    return _localDataSource.setCurrentShowId(id);
  }
}
