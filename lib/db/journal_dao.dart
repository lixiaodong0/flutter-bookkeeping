import 'package:bookkeeping/data/bean/export_params.dart';
import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_project_bean.dart';
import 'package:bookkeeping/db/model/journal_project_entry.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:sqflite/sqflite.dart';

import '../data/bean/journal_type.dart';
import 'database.dart';
import 'model/journal_entry.dart';

class JournalDao {
  //插入数据
  Future<int> insert(JournalEntry journalEntry) async {
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    // 执行插入操作
    return await db.insert(JournalEntry.table, journalEntry.toMap());
  }

  //更新数据
  Future<int> update(JournalEntry journalEntry) async {
    Database db = DatabaseHelper().db;
    return await db.update(
      JournalEntry.table,
      journalEntry.toMap(),
      where: '${JournalEntry.tableColumnId} = ?',
      whereArgs: [journalEntry.id],
    );
  }

  //删除数据
  Future<int> delete(int id) async {
    Database db = DatabaseHelper().db;
    return await db.delete(
      JournalEntry.table,
      where: '${JournalEntry.tableColumnId} = ?',
      whereArgs: [id],
    );
  }

  //根据ID查询数据
  Future<JournalBean?> queryById(int id) async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,
      JournalEntry.tableColumnAccountBookId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //id筛选条件
    whereClauses.add('$tableName.${JournalEntry.tableColumnId} = ?');
    arguments.add(id);

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName 
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId} 
      $whereClause
    ''';

    print("[queryById]$sql");
    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );
    print("[queryById]$results");
    var list = results.map((e) => JournalBean.fromJson(e)).toList();
    return list.firstOrNull;
  }

  ///账单导出
  Future<List<JournalBean>> export(ExportParams params) async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,
      JournalEntry.tableColumnAccountBookId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //账本ID筛选
    whereClauses.add('${JournalEntry.tableColumnAccountBookId} = ?');
    arguments.add(params.accountBookId);

    //时间筛选条件
    whereClauses.add('${JournalEntry.tableColumnDate} BETWEEN ? AND ?');
    String startTime = params.startDate.toIso8601String();
    String endTime = params.endDate.toIso8601String();
    arguments.add(startTime);
    arguments.add(endTime);

    //类型筛选条件
    if(params.journalType != null){
      whereClauses.add('${JournalEntry.tableColumnType} = ?');
      arguments.add(params.journalType!.name);
    }

    //产品ID筛选
    if (params.projectId != null && params.projectId! > 0) {
      whereClauses.add('${JournalEntry.tableColumnJournalProjectId} = ?');
      arguments.add(params.projectId);
    }

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName 
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId} 
      $whereClause
      ORDER BY $tableName.${JournalEntry.tableColumnDate} DESC
    ''';

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );
    print("[export]$sql");
    print("[export]$results");
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }

  ///查询月份账单
  Future<List<JournalBean>> queryAllByMonth(
    int accountBookId,
    DateTime limitDate,
    JournalType journalType, {
    int projectId = -1,
  }) async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,
      JournalEntry.tableColumnAccountBookId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //账本ID筛选
    whereClauses.add('${JournalEntry.tableColumnAccountBookId} = ?');
    arguments.add(accountBookId);

    //类型筛选条件
    whereClauses.add('${JournalEntry.tableColumnType} = ?');
    arguments.add(journalType.name);

    //产品ID筛选
    if (projectId != -1) {
      whereClauses.add('${JournalEntry.tableColumnJournalProjectId} = ?');
      arguments.add(projectId);
    }

    //时间筛选条件
    whereClauses.add('${JournalEntry.tableColumnDate} BETWEEN ? AND ?');
    String startTime =
        DateTime(limitDate.year, limitDate.month, 1).toIso8601String();
    String endTime =
        DateTime(
          limitDate.year,
          limitDate.month,
          DateUtil.calculateMonthDays(limitDate.year, limitDate.month),
          23,
          59,
          59,
        ).toIso8601String();
    arguments.add(startTime);
    arguments.add(endTime);

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName 
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId} 
      $whereClause
      ORDER BY $tableName.${JournalEntry.tableColumnDate} DESC
    ''';

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );
    print("[queryAllByMonth]$sql");
    print("[queryAllByMonth]$results");
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }

  ///查询每天账单
  Future<List<JournalBean>> queryAllByDay(
    int accountBookId,
    DateTime limitDate,
    JournalType journalType,
  ) async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,
      JournalEntry.tableColumnAccountBookId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //账本ID筛选
    whereClauses.add('${JournalEntry.tableColumnAccountBookId} = ?');
    arguments.add(accountBookId);

    //类型筛选条件
    whereClauses.add('${JournalEntry.tableColumnType} = ?');
    arguments.add(journalType.name);
    //时间筛选条件
    whereClauses.add('${JournalEntry.tableColumnDate} BETWEEN ? AND ?');
    String startTime =
        DateTime(
          limitDate.year,
          limitDate.month,
          limitDate.day,
        ).toIso8601String();
    String endTime =
        DateTime(
          limitDate.year,
          limitDate.month,
          limitDate.day,
          23,
          59,
          59,
        ).toIso8601String();
    arguments.add(startTime);
    arguments.add(endTime);

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName 
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId} 
      $whereClause
      ORDER BY $tableName.${JournalEntry.tableColumnDate} DESC
    ''';

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );
    print("[queryAllByDay]$sql");
    print("[queryAllByDay]$results");
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }

  ///查询分页数据 按照日期倒序
  /// pageSize: 分页每页大小
  /// page: 分页
  /// limitDate: 限制日期
  /// limitProject: 限制分类
  Future<List<JournalBean>> queryPager(
    int accountBookId, {
    int pageSize = 20,
    int page = 1,

    DateTime? limitDate,
    JournalProjectBean? limitProject,
  }) async {
    final String tableName = JournalEntry.table;
    final String projectTableName = JournalProjectEntry.table;

    final List<String> columns = [
      JournalEntry.tableColumnId,
      JournalEntry.tableColumnType,
      JournalEntry.tableColumnAmount,
      JournalEntry.tableColumnDate,
      JournalEntry.tableColumnDescription,
      JournalEntry.tableColumnJournalProjectId,
      JournalEntry.tableColumnAccountBookId,

      '$projectTableName.${JournalProjectEntry.tableColumnName}',
    ];

    var offset = (page - 1) * pageSize;
    final List<String> selectFields =
        columns
            .map(
              (column) => column.contains('.') ? column : '$tableName.$column',
            )
            .toList();

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //账本ID筛选
    whereClauses.add('${JournalEntry.tableColumnAccountBookId} = ?');
    arguments.add(accountBookId);

    //类型筛选条件
    if (limitProject != null) {
      whereClauses.add('${JournalEntry.tableColumnType} = ?');
      arguments.add(limitProject.journalType.name);

      whereClauses.add('${JournalEntry.tableColumnJournalProjectId} = ?');
      arguments.add(limitProject.id);
    }

    //时间筛选条件
    if (limitDate != null) {
      whereClauses.add('${JournalEntry.tableColumnDate} < ?');
      arguments.add(
        DateTime(
          limitDate.year,
          limitDate.month,
          DateUtil.calculateMonthDays(limitDate.year, limitDate.month),
          23,
          59,
          59,
        ).toIso8601String(),
      );
    }

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    String sql = '''
      SELECT 
      ${selectFields.join(', ')}
      FROM $tableName 
      JOIN
      $projectTableName ON $tableName.${JournalEntry.tableColumnJournalProjectId} = $projectTableName.${JournalProjectEntry.tableColumnId} 
      $whereClause
      ORDER BY $tableName.${JournalEntry.tableColumnDate} DESC
      LIMIT $pageSize OFFSET $offset
    ''';

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );
    print("[queryPager]pageSize:$pageSize,page:$page");
    print("[queryPager]$sql");
    print("[queryPager]$results");
    return results.map((e) => JournalBean.fromJson(e)).toList();
  }

  //查询当天总的金额
  Future<String> queryTodayTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  }) async {
    final String tableName = JournalEntry.table;
    final String columnAmount = JournalEntry.tableColumnAmount;

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //账本ID筛选
    whereClauses.add('${JournalEntry.tableColumnAccountBookId} = ?');
    arguments.add(accountBookId);

    //类型筛选条件
    whereClauses.add('${JournalEntry.tableColumnType} = ?');
    arguments.add(type.name);

    //时间筛选条件
    whereClauses.add('${JournalEntry.tableColumnDate} BETWEEN ? AND ?');
    String startTime =
        DateTime(date.year, date.month, date.day).toIso8601String();
    String endTime =
        DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
    arguments.add(startTime);
    arguments.add(endTime);

    //产品筛选条件
    if (projectId != -1) {
      whereClauses.add('${JournalEntry.tableColumnJournalProjectId} = ?');
      arguments.add(projectId);
    }

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    String sql = '''
      SELECT SUM($columnAmount) AS total_amount
      FROM $tableName $whereClause
    ''';

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );

    // print(results);

    // 检查查询结果并返回总金额
    if (results.isNotEmpty && results[0]['total_amount'] != null) {
      return results[0]['total_amount'].toString();
    } else {
      // 如果没有记录，返回 "0"
      return "0";
    }
  }

  //查询当月总的金额
  Future<String> queryMonthTotalAmount(
    int accountBookId,
    DateTime date,
    JournalType type, {
    int projectId = -1,
  }) async {
    final String tableName = JournalEntry.table;
    final String columnAmount = JournalEntry.tableColumnAmount;

    // 动态构建 WHERE 子句
    List<String> whereClauses = [];
    List<Object?> arguments = [];

    //账本ID筛选
    whereClauses.add('${JournalEntry.tableColumnAccountBookId} = ?');
    arguments.add(accountBookId);

    //类型筛选条件
    whereClauses.add('${JournalEntry.tableColumnType} = ?');
    arguments.add(type.name);

    //时间筛选条件
    whereClauses.add('${JournalEntry.tableColumnDate} BETWEEN ? AND ?');
    String startTime = DateTime(date.year, date.month, 1).toIso8601String();
    String endTime =
        DateTime(
          date.year,
          date.month,
          DateUtil.calculateMonthDays(date.year, date.month),
          23,
          59,
          59,
        ).toIso8601String();
    arguments.add(startTime);
    arguments.add(endTime);

    //产品筛选条件
    if (projectId != -1) {
      whereClauses.add('${JournalEntry.tableColumnJournalProjectId} = ?');
      arguments.add(projectId);
    }

    String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    String sql = '''
      SELECT SUM($columnAmount) AS total_amount
      FROM $tableName $whereClause
    ''';

    // 获取数据库实例
    Database db = DatabaseHelper().db;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      sql,
      arguments,
    );

    // print(results);

    // 检查查询结果并返回总金额
    if (results.isNotEmpty && results[0]['total_amount'] != null) {
      return results[0]['total_amount'].toString();
    } else {
      // 如果没有记录，返回 "0"
      return "0";
    }
  }
}
