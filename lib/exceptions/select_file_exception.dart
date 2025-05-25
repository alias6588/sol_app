class SelectFileException implements Exception {
  final String message;

  SelectFileException(
      [this.message = 'هنوز فایل انتخاب نشده است یا انتخاب لغو شده است.']);

  @override
  String toString() => 'خطا در انتخاب فایل: $message';
}
