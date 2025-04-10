import 'package:bookkeeping/data/bean/account_book_bean.dart';
import 'package:bookkeeping/data/repository/account_book_repository.dart';
import 'package:bookkeeping/db/model/account_book_entry.dart';
import 'package:bookkeeping/util/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef OnCreateSuccessCallback = void Function(AccountBookBean);

class CreateAccountBookDialog extends StatefulWidget {
  final OnCreateSuccessCallback onCreateSuccessCallback;
  final AccountBookRepository repository;

  const CreateAccountBookDialog({
    super.key,
    required this.onCreateSuccessCallback,
    required this.repository,
  });

  @override
  State createState() => _CreateAccountBookDialogState();

  static showDialog(
    BuildContext context,
    AccountBookRepository repository, {
    required OnCreateSuccessCallback onCreateSuccessCallback,
  }) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.4,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CreateAccountBookDialog(
          repository: repository,
          onCreateSuccessCallback: onCreateSuccessCallback,
        );
      },
    );
  }
}

class _CreateAccountBookDialogState extends State<CreateAccountBookDialog> {
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _create(String name) async {
    var find = await widget.repository.findAccountBookByName(name);
    if (find != null) {
      showToast("账本名称已存在，请修改");
      return;
    }
    var insert = AccountBookEntry(
      name: name,
      description: "",
      createDate: DateTime.now(),
    );
    var result = await widget.repository.insert(insert);
    if (result <= 0) {
      showToast("创建失败");
      return;
    }
    insert.id = result;

    var bean = AccountBookBean.fromJson(insert.toMap());
    setState(() {
      widget.onCreateSuccessCallback(bean);
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ), // 确保底部内边距
        child: _buildContent(),
      ),
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
      title: Text("创建账本", style: TextStyle(fontSize: 16, color: Colors.black)),
      centerTitle: true,
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 40),
      child: Column(
        children: [
          _topBar(),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _remarkController,
              style: TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: '输入账本的名称，名称不能重复',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                focusColor: const Color(0xFFF5F5F5),
                hoverColor: const Color(0xFFF5F5F5),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                ),
                counter: ValueListenableBuilder(
                  valueListenable: _remarkController,
                  builder: (context, value, child) {
                    return Text(
                      "${_remarkController.text.length}/10",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  },
                ),
              ),
              maxLength: 10,
            ),
          ),
          SizedBox(height: 80),
          ValueListenableBuilder(
            valueListenable: _remarkController,
            builder: (context, value, child) {
              var isEnable = _remarkController.text.isNotEmpty;
              var textColor = isEnable ? Colors.white : Colors.grey;
              return TextButton(
                onPressed:
                    isEnable
                        ? () {
                          _create(_remarkController.text);
                        }
                        : null,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  fixedSize: Size.fromWidth(200),
                ),
                child: Text(
                  "创建",
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
