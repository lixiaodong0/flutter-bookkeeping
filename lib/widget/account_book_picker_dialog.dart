import 'package:bookkeeping/widget/toast_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import '../data/bean/account_book_bean.dart';

typedef OnPickerSuccessCallback = void Function(AccountBookBean);

class AccountBookPickerDialog extends StatefulWidget {
  final List<AccountBookBean> list;
  final AccountBookBean? current;
  final OnPickerSuccessCallback? onPickerSuccessCallback;

  const AccountBookPickerDialog({
    super.key,
    required this.list,
    required this.current,
    this.onPickerSuccessCallback,
  });

  @override
  State createState() => _AccountBookPickerDialogState();

  static showDialog(
    BuildContext context, {
    required List<AccountBookBean> list,
    AccountBookBean? current,
    OnPickerSuccessCallback? onPickerSuccessCallback,
    VoidCallback? onClose,
  }) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      scrollControlDisabledMaxHeightRatio: 0.5,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AccountBookPickerDialog(
          list: list,
          current: current,
          onPickerSuccessCallback: onPickerSuccessCallback,
        );
      },
    ).then((value) {
      onClose?.call();
    });
  }
}

class _AccountBookPickerDialogState extends State<AccountBookPickerDialog> {
  bool isExtend = false;

  AccountBookBean? selectedItem;

  // 在 State 类中添加
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    selectedItem = widget.current;
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _confirmSelected() {
    if (selectedItem == null) {
      showErrorActionToast("请选择账本");
      return;
    }
    _close();
    widget.onPickerSuccessCallback?.call(selectedItem!);
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
              SizedBox(height: 20),
              Expanded(child: _buildContent()),
              SizedBox(height: 40),
              _bottomBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          context.pop();
        },
      ),
      title: Text("请选择账本", style: TextStyle(fontSize: 16, color: Colors.black)),
      centerTitle: true,
    );
  }

  Widget _bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _confirmSelected();
          },
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Colors.green,
            minimumSize: Size(200, 40),
          ),
          child: Text(
            "确定",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        var bean = widget.list[index];
        return _buildItem(bean);
      },
    );
  }

  Widget _buildItem(AccountBookBean data) {
    var selected = data.id == selectedItem?.id;
    var textColor = selected ? Colors.green : Colors.black;
    // var backgroundColor = selected ? Colors.green : Colors.white;
    return InkWell(
      onTap: () {
        setState(() {
          selectedItem = data;
        });
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (data.sysDefault == 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "系统",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            Text(
              data.name,
              style: TextStyle(fontSize: 16, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (selected)
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_rounded, color: Colors.green, size: 26),
              ),
          ],
        ),
      ),
    );
  }
}
