import 'package:bookkeeping/data/bean/journal_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:bookkeeping/data/bean/remark_bean.dart';
import 'package:bookkeeping/db/remark_dao.dart';
import 'package:bookkeeping/util/date_util.dart';
import 'package:bookkeeping/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class EveryDayDataDialog extends StatefulWidget {
  final List<JournalBean> list;
  final String amount;
  final DateTime date;
  final JournalType journalType;

  const EveryDayDataDialog({
    super.key,
    required this.list,
    required this.amount,
    required this.date,
    required this.journalType,
  });

  @override
  State createState() => _EveryDayDataDialogState();

  static showDialog(
    BuildContext context,
    List<JournalBean> list,
    String amount,
    DateTime date,
    JournalType journalType,
    VoidCallback onClose,
  ) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      scrollControlDisabledMaxHeightRatio: 0.5,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EveryDayDataDialog(
          list: list,
          amount: amount,
          date: date,
          journalType: journalType,
        );
      },
    ).then((value) {
      onClose();
    });
  }
}

class _EveryDayDataDialogState extends State<EveryDayDataDialog> {
  bool isExtend = false;

  // 在 State 类中添加
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _close() {
    context.pop();
  }

  void _handleScroll() {
    print(_scrollController.offset); //打印滚动位置
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // 向上滑动
      _extend(); // 调用你的扩展方法
    }
  }

  void _extend() {
    if (isExtend) {
      return;
    }
    setState(() {
      isExtend = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var totalHeight = MediaQuery.of(context).size.height;
    var contentHeight = isExtend ? totalHeight * 0.8 : totalHeight * 0.5;
    return Stack(
      children: [
        Container(
          height: contentHeight,
          padding: EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              _topBar(),
              Expanded(child: _buildContent()),
              SizedBox(height: 20),
              _bottomBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar() {
    var date = DateUtil.formatYearMonthDay(widget.date);
    var type = widget.journalType == JournalType.income ? "入账" : "支出";
    var amount = FormatUtil.formatAmount(widget.amount);
    String title = "$date共$type¥$amount";
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
    );
  }

  Widget _bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _close();
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Color(0xFFF5F5F5),
            minimumSize: Size(200, 40),
          ),
          child: Text(
            "我知道了",
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(left: 4, right: 16),
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        var bean = widget.list[index];
        return _buildItem(index + 1, bean, widget.journalType);
      },
    );
  }

  Widget _buildItem(int index, JournalBean data, JournalType type) {
    Color amountTextColor =
        type == JournalType.income ? Colors.orange : Colors.black;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                "$index",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.journalProjectName,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                if (data.description != null && data.description!.isNotEmpty)
                  Text(
                    data.description ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${type.symbol}${FormatUtil.formatAmount(data.amount)}",
                  style: TextStyle(fontSize: 14, color: amountTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
