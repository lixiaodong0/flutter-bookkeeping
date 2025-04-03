import 'package:bookkeeping/data/bean/remark_bean.dart';
import 'package:bookkeeping/db/remark_dao.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../db/model/remark_entry.dart';

typedef OnRemarkCallback = void Function(String);

class RemarkDialog extends StatefulWidget {
  final String? remark;
  final OnRemarkCallback callback;

  const RemarkDialog({super.key, required this.callback, this.remark});

  @override
  State createState() => _RemarkDialogState();

  static showDialog(
    BuildContext context,
    String remark,
    OnRemarkCallback callback,
  ) {
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
        return RemarkDialog(remark: remark, callback: callback);
      },
    );
  }
}

class _RemarkDialogState extends State<RemarkDialog> {
  final TextEditingController _remarkController = TextEditingController();
  final List<RemarkBean> remarks = [];
  final RemarkDao dao = RemarkDao();

  @override
  void initState() {
    _remarkController.text = widget.remark ?? "";
    _queryRemarks();
    super.initState();
  }

  void _queryRemarks() async {
    var remarks = await dao.take(3);
    setState(() {
      this.remarks.clear();
      this.remarks.addAll(remarks);
    });
  }

  void _saveRemark(String remark) async {
    await dao.insert(RemarkEntry(remark: remark, date: DateTime.now()));
    setState(() {
      widget.callback.call(remark);
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
      title: Text("添加备注", style: TextStyle(fontSize: 16, color: Colors.black)),
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
                hintText: '输入备注内容',
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
                      "${_remarkController.text.length}/30",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  },
                ),
              ),
              maxLength: 30,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  for (var remark in remarks)
                    TextButton(
                      onPressed: () {
                        _remarkController.text = remark.remark;
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        remark.remark,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          ValueListenableBuilder(
            valueListenable: _remarkController,
            builder: (context, value, child) {
              var isEnable = _remarkController.text.isNotEmpty;
              var textColor = isEnable ? Colors.white : Colors.grey;
              return TextButton(
                onPressed:
                    isEnable
                        ? () {
                          _saveRemark(_remarkController.text);
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
                  "确认",
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
