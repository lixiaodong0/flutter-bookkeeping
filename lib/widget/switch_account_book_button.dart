import 'package:flutter/material.dart';

import '../data/bean/account_book_bean.dart';

enum MenuItemType { item, space, add }

class MenuItem {
  final MenuItemType type;
  final String name;
  final AccountBookBean? data;

  const MenuItem({required this.type, required this.name, required this.data});
}

typedef OnCreateCallback = void Function();
typedef OnSwitchCallback = void Function(AccountBookBean);

class SwitchAccountBookButton extends StatelessWidget {
  final AccountBookBean currentAccountBook;
  final List<AccountBookBean> allAccountBooks;
  final OnCreateCallback onCreateCallback;
  final OnSwitchCallback onSwitchCallback;

  const SwitchAccountBookButton({
    super.key,
    required this.currentAccountBook,
    required this.allAccountBooks,
    required this.onCreateCallback,
    required this.onSwitchCallback,
  });

  @override
  Widget build(BuildContext context) {
    List<MenuItem> items =
        allAccountBooks
            .map(
              (e) => MenuItem(type: MenuItemType.item, name: e.name, data: e),
            )
            .toList();

    var spaceItem = MenuItem(type: MenuItemType.space, name: "", data: null);
    var addItem = MenuItem(type: MenuItemType.add, name: "新增账本", data: null);

    return PopupMenuButton<MenuItem>(
      itemBuilder:
          (BuildContext context) => [
            for (var item in items)
              PopupMenuItem<MenuItem>(
                value: item,
                padding: EdgeInsets.zero,
                onTap: () {
                  onSwitchCallback(item.data!);
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              item.data?.id == currentAccountBook.id
                                  ? Colors.green
                                  : Colors.black,
                        ),
                      ),
                      if (item.data?.id == currentAccountBook.id)
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.green,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            PopupMenuItem<MenuItem>(
              height: 8,
              padding: EdgeInsets.zero,
              onTap: null,
              value: spaceItem,
              child: Container(color: Color(0xFFF5F5F5), height: 8),
            ),

            PopupMenuItem<MenuItem>(
              value: addItem,
              padding: EdgeInsets.zero,
              onTap: () {
                onCreateCallback();
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      addItem.name,
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.add_circle_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
      color: Colors.white,
      menuPadding: EdgeInsets.zero,
      onSelected: (value) {},
      offset: Offset(0, 60),
      // 调整弹出位置
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      icon: Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              backgroundColor: Colors.white12,
              minimumSize: Size(0, 26),
            ),
            onPressed: null,
            child: Row(
              children: [
                Text(
                  currentAccountBook.name,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.menu_open_rounded,
                  color: Colors.white.withAlpha(200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
