import 'package:intl/intl.dart';

String formattedDateWidget({
  required String formatDate,
  String? customFormat,
}) {
  final DateFormat dateFormat = customFormat != null
      ? DateFormat(customFormat)
      : DateFormat('dd MMM, yyyy - HH:mm:ss a');

  DateTime parsedDate = DateTime.parse(formatDate);
  return dateFormat.format(parsedDate);
}