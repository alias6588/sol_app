class NotFoundSoundFontIdException implements Exception {
  final String message;

  NotFoundSoundFontIdException([this.message = 'شناسه فونت صدا یافت نشد.']);

  @override
  String toString() => 'NotFoundSoundFontIdException: $message';
}
