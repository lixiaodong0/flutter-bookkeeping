import 'package:bookkeeping/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastManager {
  //私有构造函数
  ToastManager._();

  // 静态变量保存唯一实例
  static final ToastManager _instance = ToastManager._();

  // 工厂构造函数，提供全局访问点
  factory ToastManager() => _instance;

  final FToast toast = FToast();

  final GlobalKey toastGlobalContext = GlobalKey();
}

void showToast(
  String msg, {
  int seconds = 2,
  ToastGravity gravity = ToastGravity.CENTER,
}) {
  showCustomToast(_commonToastWidget(msg), seconds: seconds, gravity: gravity);
}

FToast showCustomToast(
  Widget container, {
  int seconds = 2,
  ToastGravity gravity = ToastGravity.CENTER,
}) {
  var toast = ToastManager._instance.toast;
  var currentContext = ToastManager._instance.toastGlobalContext.currentContext;
  if (currentContext == null) {
    return toast;
  }
  toast.removeQueuedCustomToasts();
  toast.init(currentContext);
  toast.showToast(
    child: container,
    gravity: gravity,
    toastDuration: Duration(seconds: seconds),
  );
  return toast;
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
