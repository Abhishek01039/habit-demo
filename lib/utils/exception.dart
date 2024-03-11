class CustomException implements Exception {
  CustomException({this.cause});

  final String? cause;
}
