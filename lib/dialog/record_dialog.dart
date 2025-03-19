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
          Padding(padding: EdgeInsets.only(top: 8)),
          _inputContainer(inputAmount),
          Padding(padding: EdgeInsets.only(top: 8)),
          TextButton(onPressed: () {}, child:Text("添加备注",style: TextStyle(fontSize: 16,color: Colors.blue))),
          KeyboardWidget(onClickKeyCode: onClickKeyCode),
        ],
      ),
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
