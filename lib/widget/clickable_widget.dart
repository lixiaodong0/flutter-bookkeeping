import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget clickableWidget(VoidCallback onPressed, Widget child) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      onPressed();
    },
    child: child,
  );
}

Widget sizedButtonWidget({
  double? width,
  double? height,
  VoidCallback? onPressed,
  required Widget child,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      onPressed?.call();
    },
    child: SizedBox(width: width, height: height, child: child),
  );
}
