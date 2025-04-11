import 'package:bookkeeping/util/toast_util.dart';
import 'package:flutter/material.dart';

void showSuccessActionToast(String message) {
  showActionToast(message, icon: Icons.check_circle_rounded);
}

void showErrorActionToast(String message) {
  showActionToast(message);
}

void showActionToast(
  String message, {
  IconData icon = Icons.info_outline_rounded,
  double iconSize = 32,
  Color iconColor = Colors.white,
  Color textColor = Colors.white,
}) {
  showCustomToast(
    Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      constraints: BoxConstraints(minWidth: 120, minHeight: 100),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            SizedBox(height: 8),
            Text(message, style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}
