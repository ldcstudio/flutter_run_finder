extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String distanceToString(double value) {
  if (value.toInt() > 1000) {
    value /= 1000.0;
    return '${value.toStringAsFixed(1)}km';
  } else {
    return '${value.toInt()}m';
  }
}
