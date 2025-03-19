import 'package:bookkeeping/data/bean/journal_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/keyboard_widget.dart';

typedef OnRecordCloseFunction = void Function();
typedef OnRecordConfirmFunction = void Function();

void showRecordDialog(BuildContext context) {
  var rootContext = Navigator.of(context, rootNavigator: true).context;
  showModalBottomSheet(
    context: rootContext,
    builder: (BuildContext context) {
      return _RecordDialog(
        onClose: () {
          Navigator.of(rootContext).pop();
        },
        onConfirm: () {},
      );
    },
  );
}

class _RecordDialog extends StatefulWidget {
  const _RecordDialog({required this.onClose, required this.onConfirm})
    : super();
  final OnRecordCloseFunction onClose;
  final OnRecordConfirmFunction onConfirm;

  @override
  State<StatefulWidget> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<_RecordDialog> {
  String inputAmount = "";
  JournalType journalType = JournalType.expense;
  Color confirmColor = Colors.green;
  bool confirmEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  //点击按键
  void onClickKeyCode(KeyCode keyCode) {
    if (keyCode == KeyCode.confirm) {
      //确认
      widget.onConfirm();
      return;
    }
    var newAmount = inputAmount;
    switch (keyCode) {
      case KeyCode.one:
        newAmount += "1";
        break;
      case KeyCode.two:
        newAmount += "2";
        break;
      case KeyCode.three:
        newAmount += "3";
        break;
      case KeyCode.four:
        newAmount += "4";
        break;
      case KeyCode.five:
        newAmount += "5";
        break;
      case KeyCode.six:
        newAmount += "6";
        break;
      case KeyCode.seven:
        newAmount += "7";
        break;
      case KeyCode.eight:
        newAmount += "8";
        break;
      case KeyCode.nine:
        newAmount += "9";
        break;
      case KeyCode.zero:
        newAmount += "0";
        break;
      case KeyCode.dot:
        newAmount += ".";
        break;
      case KeyCode.backspace:
        if (newAmount.isEmpty) {
          return;
        }
        newAmount = newAmount.substring(0, newAmount.length - 1);
        break;
      case KeyCode.confirm:
    }
    newAmount = _validAmount(newAmount);
    setState(() {
      inputAmount = newAmount;
      confirmEnabled = inputAmount.isNotEmpty;
    });
  }

  String _validAmount(String amount) {
    //01 02开头
    if (amount.length == 2 && !amount.contains(".") && amount.startsWith("0")) {
      return amount.substring(1, 2);
    }

    //处理单独输入.
    if (amount.length == 1 && amount.contains(".")) {
      return "0.";
    }

    //保留.小数点后两位
    if (amount.contains(".")) {
      var index = amount.indexOf(".");
      if (amount.length - index > 2) {
        return amount.substring(0, index + 3);
      }
    }
    return amount;
  }

  void onClickJournalType(JournalType type) {
    setState(() {
      journalType = type;
      if (type == JournalType.expense) {
        confirmColor = Colors.green;
      } else {
        confirmColor = Colors.orange;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              widget.onClose();
            },
            icon: const Icon(Icons.close),
          ),
          _journalTypeContainer(),
          Padding(padding: EdgeInsets.only(top: 8)),
          _inputContainer(inputAmount),
          Padding(padding: EdgeInsets.only(top: 8)),
          TextButton(
            onPressed: () {},
            child: Text(
              "添加备注",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          KeyboardWidget(
            onClickKeyCode: onClickKeyCode,
            confirmColor: confirmColor,
            confirmEnabled: confirmEnabled,
          ),
        ],
      ),
    );
  }

  Widget _journalTypeContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _journalTypeButton("支出", journalType == JournalType.expense, () {
            onClickJournalType(JournalType.expense);
          }),
          Padding(padding: EdgeInsets.only(left: 8)),
          _journalTypeButton("入账", journalType == JournalType.income, () {
            onClickJournalType(JournalType.income);
          }),
        ],
      ),
    );
  }

  Widget _journalTypeButton(
    String title,
    bool selected,
    VoidCallback onPressed,
  ) {
    Color textColor = Colors.grey;
    Color? backgroundColor = Colors.grey[100];
    if (selected) {
      textColor = Colors.white;
      backgroundColor = Colors.blue;
    }
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(0),
        minimumSize: const Size(48, 26),
        fixedSize: const Size(48, 26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(title, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }

  Widget _inputContainer(String inputAmount) {
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text("¥", style: TextStyle(fontSize: 30, color: Colors.black)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
              Text(
                inputAmount,
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ],
          ),
          Divider(height: 1, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
