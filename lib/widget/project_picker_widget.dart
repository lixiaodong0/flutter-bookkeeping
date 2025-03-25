import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:flutter/material.dart';

import '../data/bean/journal_project_bean.dart';

class ProjectPickerWidget extends StatelessWidget {
  final JournalProjectBean? currentProject;
  final List<JournalProjectBean> allIncomeProject;
  final List<JournalProjectBean> allExpenseProject;

  final ValueChanged<JournalProjectBean?> onChanged;

  const ProjectPickerWidget({
    super.key,
    required this.currentProject,
    required this.allIncomeProject,
    required this.allExpenseProject,
    required this.onChanged,
  });

  static showDatePicker(
    BuildContext context, {
    required JournalProjectBean? currentProject,
    required List<JournalProjectBean> allIncomeProject,
    required List<JournalProjectBean> allExpenseProject,
    required ValueChanged<JournalProjectBean?> onChanged,
    required VoidCallback onClose,
  }) {
    var rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Color.fromRGBO(237, 237, 237, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      scrollControlDisabledMaxHeightRatio: 0.6,
      builder: (BuildContext context) {
        return ProjectPickerWidget(
          currentProject: currentProject,
          allIncomeProject: allIncomeProject,
          allExpenseProject: allExpenseProject,
          onChanged: onChanged,
        );
      },
    ).then((value) {
      onClose();
    });
  }

  void _onSelectedProject(BuildContext context, JournalProjectBean? data) {
    onChanged(data);
    Navigator.of(context).pop();
  }

  void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(Padding(padding: EdgeInsets.only(top: 20)));

    children.add(_allItemContainer(context));

    children.add(
      Padding(
        padding: EdgeInsets.only(top: 14, bottom: 10, left: 16, right: 16),
        child: Text("支出", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ),
    );
    children.add(_projectGridContainer(context, allExpenseProject));

    children.add(
      Padding(
        padding: EdgeInsets.only(top: 14, bottom: 10, left: 16, right: 16),
        child: Text("入账", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ),
    );
    children.add(_projectGridContainer(context, allIncomeProject));

    children.add(Padding(padding: EdgeInsets.only(bottom: 20)));
    return Column(
      children: [
        _topToolbarContainer(context),
        Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _allItemContainer(BuildContext context) {
    List<Widget> children = [];
    children.add(_allItem(context));
    children.add(Spacer());
    children.add(Spacer());
    return _styleGridView(children);
  }

  Widget _topToolbarContainer(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              padding: EdgeInsets.symmetric(horizontal: 4),
              onPressed: () {
                _onClose(context);
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "请选择类型",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _projectGridContainer(
    BuildContext context,
    List<JournalProjectBean> list,
  ) {
    List<Widget> children = [];
    for (var value in list) {
      children.add(_projectItem(context, value));
    }
    return _styleGridView(children);
  }

  Widget _styleGridView(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1 / 0.5,
      padding: EdgeInsets.symmetric(horizontal: 16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // 禁用滚动
      children: children,
    );
  }

  Widget _projectItem(BuildContext context, JournalProjectBean data) {
    var isSelected = data.name == currentProject?.name;
    Color textColor = isSelected ? Colors.white : Colors.black;
    Color backgroundColor = isSelected ? Colors.green : Colors.white;
    return TextButton(
      onPressed: () {
        _onSelectedProject(context, data);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(data.name, style: TextStyle(color: textColor, fontSize: 14)),
    );
  }

  Widget _allItem(BuildContext context) {
    var isSelected = currentProject == null;
    Color textColor = isSelected ? Colors.white : Colors.black;
    Color backgroundColor = isSelected ? Colors.green : Colors.white;
    return TextButton(
      onPressed: () {
        _onSelectedProject(context, null);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text("全部类型", style: TextStyle(color: textColor, fontSize: 14)),
    );
  }
}
