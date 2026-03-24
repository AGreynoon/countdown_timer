import 'dart:convert';

class Event {
  final String id;
  final String title;
  final DateTime targetDate;
  final String category;
  final Map<String, bool> displayUnits;

  const Event({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.category,
    required this.displayUnits,
  });

  Event copyWith({
    String? id,
    String? title,
    DateTime? targetDate,
    String? category,
    Map<String, bool>? displayUnits,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
      category: category ?? this.category,
      displayUnits: displayUnits ?? this.displayUnits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'target_date': targetDate.toIso8601String(),
      'category': category,
      'display_units': jsonEncode(displayUnits),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      targetDate: DateTime.parse(map['target_date'] as String),
      category: map['category'] as String,
      displayUnits: Map<String, bool>.from(jsonDecode(map['display_units'] as String) as Map),
    );
  }
}
