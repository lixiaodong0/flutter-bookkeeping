import 'package:flutter/material.dart';

//自定义键盘
//Row没有android-Grid的跨行跨列展示，所以通过自定义计算来实现。
class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({super.key});

  static const double _keySpacing = 8;

  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width.toInt();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey[50]),
          padding: const EdgeInsets.symmetric(vertical: _keySpacing),
          child: Stack(
            children: [
              Column(
                spacing: _keySpacing,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("1", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("2", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("3", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _backspaceButton(() {})),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("4", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("5", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("6", () {})),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("7", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("8", () {})),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(totalWidth, _keyButton("9", () {})),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
                      _keySizedContainer(
                        totalWidth,
                        _keyButton("0", () {}),
                        itemColumns: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: _keySpacing),
                      ),
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
                padding: const EdgeInsets.only(top: 48, right: _keySpacing),
                child: _keySizedContainer(
                  totalWidth,
                  _keyButton("确认", () {}),
                  height: 120 + (2 * _keySpacing),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _keyButton(String key, VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: Colors.transparent),
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
    var fullWidth = totalWidth - (rowColumns * spacing + spacing);
    var itemWidth = (fullWidth / rowColumns) * itemColumns;
    if (itemColumns > 1) {
      itemWidth += spacing * (itemColumns - 1);
    }
    return SizedBox(width: itemWidth, height: height, child: child);
  }

  Widget _backspaceButton(VoidCallback onClick) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: Colors.transparent),
        iconColor: Colors.black,
      ),
      child: Icon(Icons.backspace),
    );
  }
}
