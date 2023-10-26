import 'package:intl/intl.dart';

String formattedDateWidget({required String formatDate}) {
  DateTime parsedDate = DateTime.parse(formatDate);
  DateFormat formatter = DateFormat('dd MMM, yyyy - HH:mm:ss a');
  return formatter.format(parsedDate);
}
