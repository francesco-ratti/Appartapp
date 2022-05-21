import 'package:appartapp/classes/apartment.dart';

class LessorMatch {
  Apartment apartment;
  DateTime time;

  LessorMatch(this.apartment, this.time);

  LessorMatch.fromMap(Map map)
      : this.apartment = map['apartment'],
        this.time = DateTime.fromMillisecondsSinceEpoch(map['matchDate']);
}