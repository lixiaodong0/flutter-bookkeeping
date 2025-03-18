import 'package:flutter/material.dart';

//自定义键盘
class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width.toInt();
    return Container(
      child: Stack(
        children: [
          Column(
            spacing: 8,
            children: [
              Row(
                children: [
                  _keySizedContainer(totalWidth, _keyButton("1", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _keyButton("2", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _keyButton("3", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _backspaceButton(() {})),
                ],
              ),
              Row(
                children: [
                  _keySizedContainer(totalWidth, _keyButton("4", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _keyButton("5", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _keyButton("6", () {})),
                ],
              ),
              Row(
                children: [
                  _keySizedContainer(totalWidth, _keyButton("7", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _keyButton("8", () {})),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(totalWidth, _keyButton("9", () {})),
                ],
              ),
              Row(
                children: [
                  _keySizedContainer(
                    totalWidth,
                    _keyButton("0", () {}),
                    itemColumns: 2,
                  ),
                  Padding(padding: const EdgeInsets.only(right: 8)),
                  _keySizedContainer(
                    totalWidth,
                    _keyButton(".", () {}),
                    itemColumns: 1,
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 48,right: 8),
            child: _keySizedContainer(
              totalWidth,
              _keyButton("确认", () {}),
              height: 120 + (2 * 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyButton(String key, VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        key,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Widget _keySizedContainer(
    int totalWidth,
    Widget child, {
    int rowColumns = 4,
    int itemColumns = 1,
    int spacing = 8,
    double height = 40,
  }) {
    var fullWidth = totalWidth - (rowColumns * spacing);
    var itemWidth = (fullWidth / rowColumns) * itemColumns;
    if (itemColumns > 1) {
      itemWidth += spacing * (itemColumns - 1);
    }
    return SizedBox(width: itemWidth, height: height, child: child);
  }

  Widget _zeroButton(
    BuildContext context,
    String key, {
    required VoidCallback onClick,
  }) {
    var width = MediaQuery.of(context).size.width;
    var itemWidth = width / 4 * 2;
    return SizedBox(
      width: itemWidth - 4,
      height: 40,
      child: OutlinedButton(
        onPressed: onClick,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          key,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  Widget _pointButton(
    BuildContext context,
    String key, {
    required VoidCallback onClick,
  }) {
    var width = MediaQuery.of(context).size.width;
    var itemWidth = width / 4;
    return SizedBox(
      width: itemWidth - 8,
      height: 40,
      child: OutlinedButton(
        onPressed: onClick,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          key,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  Widget _backspaceButton(VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Icon(Icons.backspace),
    );
  }

  Widget _confirmButton(String key, VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(key),
    );
  }

  Widget _placeholderButton() {
    return Expanded(child: SizedBox(height: 40, child: Spacer()));
  }
}
