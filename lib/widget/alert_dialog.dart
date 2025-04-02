
import 'package:flutter/material.dart';

final class AlertConfirmDialog extends StatelessWidget {
  final String desc;
  final String cancel;
  final String confirm;

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const AlertConfirmDialog({
    super.key,
    required this.desc,
    this.cancel = "取消",
    this.confirm = "确认",
    required this.onCancel,
    required this.onConfirm,
  });

  void _cancel(BuildContext context) {
    onCancel();
    Navigator.of(context).pop();
  }

  void _confirm(BuildContext context) {
    onConfirm();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: const Color(0xFFF5F5F5)),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    maximumSize: Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    _cancel(context);
                  },
                  child: Text(
                    cancel,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              VerticalDivider(width: 1, color: const Color(0xFFF5F5F5)),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    maximumSize: Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    _confirm(context);
                  },
                  child: Text(
                    confirm,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static showAlertDialog(
    BuildContext context, {
    required String desc,
    String? cancel,
    String? confirm,
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Center(
              child: SizedBox(
                height: screenHeight * 0.2, //
                child: AlertConfirmDialog(
                  desc: desc,
                  cancel: cancel ?? "取消",
                  confirm: confirm ?? "确认",
                  onCancel: onCancel,
                  onConfirm: onConfirm,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
