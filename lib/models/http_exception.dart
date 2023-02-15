class HttpException implements Exception {
  String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString();   // Returns "Instance of HttpException"
    // We are giving our custom exception.
  }
}
