import 'package:flutter_test/flutter_test.dart';
import 'package:sol/models/music_player_notifier.dart';
import 'package:sol/models/measure.dart';
import 'package:sol/models/music_elements/note.dart';

void main() {
  group('MusicPlayNotifier.getElement', () {
    late MusicPlayNotifier notifier;
    late Note firstNote;
    late Note secondNote;
    late Note thirdNote;

    setUp(() {
      firstNote = Note('note', 'C4', 'C4', 0, 60, 1, 'quarter', 'C4');
      secondNote = Note('note', 'D4', 'D4', 1, 62, 1, 'quarter', 'D4');
      thirdNote = Note('note', 'E4', 'E4', 0, 64, 1, 'quarter', 'E4');

      final measure1 = Measure(measureNumber: 1, elements: [firstNote, secondNote]);
      final measure2 = Measure(measureNumber: 2, elements: [thirdNote]);

      notifier = MusicPlayNotifier(measures: [measure1, measure2]);
    });

    test('returns the correct element when indexes are valid', () {
      final element1 = notifier.getElement(measureIndex: 0, elementIndex: 1);
      expect(element1, same(secondNote));

      final element2 = notifier.getElement(measureIndex: 1, elementIndex: 0);
      expect(element2, same(thirdNote));
    });

    test('throws RangeError for out-of-range indexes', () {
      expect(() => notifier.getElement(measureIndex: -1, elementIndex: 0), throwsRangeError);
      expect(() => notifier.getElement(measureIndex: 2, elementIndex: 0), throwsRangeError);
      expect(() => notifier.getElement(measureIndex: 0, elementIndex: 2), throwsRangeError);
      expect(() => notifier.getElement(measureIndex: 0, elementIndex: -1), throwsRangeError);
    });
  });
}
