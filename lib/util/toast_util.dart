import 'package:bookkeeping/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(
  String msg, {
  int seconds = 2,
  ToastGravity gravity = ToastGravity.CENTER,
}) {
  BuildContext? currentContext = toastGlobalContext.currentContext;
  if (currentContext != null) {
    var toast = FToast();
    toast.init(currentContext);
    toast.showToast(
      child: _commonToastWidget(msg),
      gravity: gravity,
      toastDuration: Duration(seconds: seconds),
    );
  }
}

Widget _commonToastWidget(String msg) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(32),
    ),
    child: Text(msg, style: TextStyle(color: Colors.white, fontSize: 16)),
  );
}
