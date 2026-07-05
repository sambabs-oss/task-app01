import 'package:flutter/material.dart';

class Task {
  String title;
  TimeOfDay? time;
  bool isCompleted;

  Task({
    required this.title,
    this.time,
    this.isCompleted = false,
  });
  Map<String,dynamic> toJson(){
    return {
      'title': title,
      'isCompleted': isCompleted,
      'time': time !=null
          ? '${time!.hour} : ${time!.minute}'
          : null,
    };
  }
  factory Task.fromJson(Map<String,dynamic> json){
    TimeOfDay? time;
    if(json['time'] != null){
      try {
        final parts = json['time'].split(':');
        time = TimeOfDay(hour: int.parse(parts[0].trim()), minute: int.parse(parts[1].trim()));
      } catch (e) {
        time = null;
      }
    }
  return Task(
    title : json['title'],
    isCompleted: json['isCompleted'],
    time: time,
  );
  }
}