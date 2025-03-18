import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//自定义键盘
class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Column(
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  _keyButton("1", onClick: () {}),
                  _keyButton("2", onClick: () {}),
                  _keyButton("3", onClick: () {}),
                  _backspaceButton(() {}),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  _keyButton("4", onClick: () {}),
                  _keyButton("5", onClick: () {}),
                  _keyButton("6", onClick: () {}),
                  _placeholderButton(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  _keyButton("7", onClick: () {}),
                  _keyButton("8", onClick: () {}),
                  _keyButton("9", onClick: () {}),
                  _placeholderButton(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  _keyButton("0", flex: 2, onClick: () {}),
                  _keyButton(".", onClick: () {}),
                  _placeholderButton(),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 8,
              children: [
                _placeholderButton(),
                _placeholderButton(),
                _placeholderButton(),
                _confirmButton("确认", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyButton(String key, {int flex = 1, required VoidCallback onClick}) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 40,
        child: OutlinedButton(
          onPressed: onClick,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            key,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _backspaceButton(VoidCallback onClick) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: OutlinedButton(
          onPressed: onClick,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Icon(Icons.backspace),
        ),
      ),
    );
  }

  Widget _confirmButton(String key, VoidCallback onClick) {
    return Expanded(
      child: SizedBox(
        height: 120,
        child: OutlinedButton(
          onPressed: onClick,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(key),
        ),
      ),
    );
  }

  Widget _placeholderButton() {
    return Expanded(child: SizedBox(height: 40, child: Spacer()));
  }
}
