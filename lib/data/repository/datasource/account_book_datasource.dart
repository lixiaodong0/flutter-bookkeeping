import '../../../db/model/account_book_entry.dart';
import '../../bean/account_book_bean.dart';

abstract class AccountBookDataSource {
  Future<List<AccountBookBean>> findAll();

  Future<AccountBookBean?> findAccountBookByName(String name);

  Future<int> insert(AccountBookEntry entry);

  Future<int> delete(int id);

  Future<int> setCurrentShowId(int id);
}
