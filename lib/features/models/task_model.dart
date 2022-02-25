// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
    TaskModel({
        this.taskId,
        this.name,
    });

    final String? taskId;
    final String? name;

    TaskModel copyWith({
        String? taskId,
        String? name,
    }) => 
        TaskModel(
            taskId: taskId ?? this.taskId,
            name: name ?? this.name,
        );

    factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        taskId: json["taskId"] == null ? null : json["taskId"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "taskId": taskId == null ? null : taskId,
        "name": name == null ? null : name,
    };
}
