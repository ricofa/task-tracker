String formatShortDate(DateTime? date) {
  if (date == null) {
    return 'No due date';
  }

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();

  return '$day/$month/$year';
}
