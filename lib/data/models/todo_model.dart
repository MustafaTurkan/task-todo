import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/infrastructure/enums.dart';

class TodoModel {
  TodoModel({this.id, this.title, this.text, this.status, this.period, this.createdDate, this.finishedDate});

  TodoModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        text = map['text'],
        status = map['status'],
        period = map['period'],
        createdDate = map['createdDate'].toDate(),
        finishedDate = map['finishedDate'].toDate();

  final String title;
  final String text;
  final int period;

  String id;
  int status;
  DateTime createdDate;
  DateTime finishedDate;

  RemainingTime get remainingTime {
    var now = DateTime.now();

    if (finishedDate.isBefore(now)) {
      return RemainingTime(TimeType.hour, 0);
    }

    var remainingHours = finishedDate.difference(now).inHours;
    if (remainingHours < 24) {
      return RemainingTime(TimeType.hour, remainingHours+1);
    }
    var remainingDays = finishedDate.difference(now).inDays;

    return RemainingTime(TimeType.day, remainingDays+1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'status': status,
      'period': period,
      'finishedDate': Timestamp.fromDate(finishedDate),
      'createdDate': Timestamp.fromDate(createdDate)
    };
  }
}

class RemainingTime {
  RemainingTime(this.timeType, this.time);
  final TimeType timeType;
  final int time;
}
