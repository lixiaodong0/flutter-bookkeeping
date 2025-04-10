import 'package:bookkeeping/data/bean/journal_month_bean.dart';
import 'package:bookkeeping/data/bean/journal_type.dart';

class StatisticsEvent {
  const StatisticsEvent();
}

class StatisticsInitLoad extends StatisticsEvent {
  const StatisticsInitLoad();
}

class StatisticsReload extends StatisticsEvent {
  const StatisticsReload();
}

class StatisticsOnSwitchType extends StatisticsEvent {
  final JournalType journalType;

  const StatisticsOnSwitchType({required this.journalType});
}

class StatisticsOnShowDatePicker extends StatisticsEvent {
  final int accountBookId;
  const StatisticsOnShowDatePicker(this.accountBookId);
}

class StatisticsOnCloseDatePicker extends StatisticsEvent {
  const StatisticsOnCloseDatePicker();
}

class StatisticsOnShowEveryDayDataDialog extends StatisticsEvent {
  final JournalType type;
  final DateTime date;
  final String amount;

  const StatisticsOnShowEveryDayDataDialog({
    required this.type,
    required this.date,
    required this.amount,
  });
}

class StatisticsOnCloseEveryDayDataDialog extends StatisticsEvent {
  const StatisticsOnCloseEveryDayDataDialog();
}

class StatisticsOnSelectedDate extends StatisticsEvent {
  final DateTime selectedDate;

  const StatisticsOnSelectedDate({required this.selectedDate});
}

class StatisticsOnExpandedChange extends StatisticsEvent {
  final bool newExpanded;

  const StatisticsOnExpandedChange({required this.newExpanded});
}

class StatisticsOnChangeJournalRankingList extends StatisticsEvent {
  final DateTime changeDateTime;
  final int selectIndex;

  const StatisticsOnChangeJournalRankingList({
    required this.changeDateTime,
    required this.selectIndex,
  });
}

class StatisticsOnChangeDayChartData extends StatisticsEvent {
  final int selectIndex;

  const StatisticsOnChangeDayChartData({required this.selectIndex});
}
