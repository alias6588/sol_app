class PostFileException implements Exception {
  final String message;
  final Exception? cause;

  PostFileException(
      [this.message = 'خطا در ارتباط با سرور', this.cause]);

  @override
  String toString() {
    if (cause != null) {
      return 'خطا در ارتباط با سرور: $message\nCaused by: $cause';
    }
    return 'خطا در ارتباط با سرور: $message';
  }
}
