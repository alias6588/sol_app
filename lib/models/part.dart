import 'package:sol/models/measure.dart';

class Part {
  final String partInfo;
  final List<Measure> measures;

  Part({
    required this.partInfo,
    required this.measures,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      partInfo: json['part_info'] as String,
      measures: (json['measures'] as List)
          .map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
