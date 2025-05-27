class SoundFontLoadingException implements Exception {
  final String message;

  SoundFontLoadingException([this.message = 'خطا در بارگذاری فایل SoundFont رخ داد.']);

  @override
  String toString() => 'SoundFontLoadingException: $message';
}