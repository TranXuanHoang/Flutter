/// Represents an arbitrary HTTP exception used in this project.
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
