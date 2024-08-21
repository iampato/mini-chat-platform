import 'package:intl/intl.dart';

class StatementDates {
  final DateTime startDate;
  final DateTime endDate;

  const StatementDates({
    required this.startDate,
    required this.endDate,
  });

  // startDateString
  // to the format 2021-01-20
  String get startDateString {
    return DateFormat('yyyy-MM-dd').format(startDate);
  }

  // endDateString
  // to the format 2021-01-20
  String get endDateString {
    return DateFormat('yyyy-MM-dd').format(endDate);
  }
}

// get this week's dates
StatementDates getThisWeekDates() {
  final today = DateTime.now();
  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  return StatementDates(
    startDate: startOfWeek,
    endDate: endOfWeek,
  );
}

// get this month's dates
StatementDates getThisMonthDates() {
  final today = DateTime.now();
  final startOfMonth = DateTime(today.year, today.month, 1);
  final endOfMonth = DateTime(today.year, today.month + 1, 0);

  return StatementDates(
    startDate: startOfMonth,
    endDate: endOfMonth,
  );
}

// get the last three months' dates
StatementDates getLastThreeMonthsDates() {
  final today = DateTime.now();
  final startOfLastThreeMonths = DateTime(today.year, today.month - 2, 1);
  final endOfLastThreeMonths = DateTime(today.year, today.month, 0);

  return StatementDates(
    startDate: startOfLastThreeMonths,
    endDate: endOfLastThreeMonths,
  );
}

// get the last six months' dates
StatementDates getLastSixMonthsDates() {
  final today = DateTime.now();
  final startOfLastSixMonths = DateTime(today.year, today.month - 5, 1);
  final endOfLastSixMonths = DateTime(today.year, today.month, 0);

  return StatementDates(
    startDate: startOfLastSixMonths,
    endDate: endOfLastSixMonths,
  );
}

// get the last twelve months' dates
StatementDates getLastTwelveMonthsDates() {
  final today = DateTime.now();
  final startOfLastTwelveMonths = DateTime(today.year - 1, today.month, 1);
  final endOfLastTwelveMonths = DateTime(today.year, today.month, 0);

  return StatementDates(
    startDate: startOfLastTwelveMonths,
    endDate: endOfLastTwelveMonths,
  );
}

// get custom Dates
StatementDates getCustomDates(DateTime startDate, DateTime endDate) {
  return StatementDates(
    startDate: startDate,
    endDate: endDate,
  );
}
