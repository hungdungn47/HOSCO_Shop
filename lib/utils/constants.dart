
import 'dart:ui';

final Color primaryColor = Color(0xff2F98F5);
final String transactionTypeSale = 'sale';
final String transactionTypeImport = 'import';

final List<String> productTypes = [
  'Electronics',
  'Audio',
  'Accessories',
  'Camera',
  'Computer',
  'Tech',
  'Sports'
];

  enum TimeRange {
    lastHour,
    today,
    thisWeek,
    thisMonth,
  }

const Map<TimeRange, String> timeRangeLabels = {
  TimeRange.lastHour: "1 giờ qua",
  TimeRange.today: "Hôm nay",
  TimeRange.thisWeek: "Tuần này",
  TimeRange.thisMonth: "Tháng này",
};

TimeRange? getTimeRangeFromLabel(String label) {
  return timeRangeLabels.entries
      .firstWhere((entry) => entry.value == label, orElse: () => MapEntry(TimeRange.thisWeek, ""))
      .key;
}
