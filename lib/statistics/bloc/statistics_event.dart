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
  const StatisticsOnShowDatePicker();
}

class StatisticsOnCloseDatePicker extends StatisticsEvent {
  const StatisticsOnCloseDatePicker();
}

class StatisticsOnSelectedDate extends StatisticsEvent {
  final DateTime selectedDate;

  const StatisticsOnSelectedDate({required this.selectedDate});
}

class StatisticsOnExpandedChange extends StatisticsEvent {
  final bool newExpanded;

  const StatisticsOnExpandedChange({required this.newExpanded});
}
