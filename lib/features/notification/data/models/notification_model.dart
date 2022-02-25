import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.sent,
    this.read,
    this.id,
    this.operationId,
    this.travelId,
    this.loadingOrderId,
    this.taskId,
    this.userId,
    this.message,
    this.type,
    this.createDate,
  });

  final bool? sent;
  final bool? read;
  final String? id;
  final String? operationId;
  final String? travelId;
  final String? loadingOrderId;
  final String? taskId;
  final String? userId;
  final String? message;
  final String? type;
  final DateTime? createDate;

  NotificationModel copyWith({
    bool? sent,
    bool? read,
    String? id,
    String? operationId,
    String? travelId,
    String? loadingOrderId,
    String? taskId,
    String? userId,
    String? message,
    String? type,
    DateTime? createDate,
  }) =>
      NotificationModel(
        sent: sent ?? this.sent,
        read: read ?? this.read,
        id: id ?? this.id,
        operationId: operationId ?? this.operationId,
        travelId: travelId ?? this.travelId,
        loadingOrderId: loadingOrderId ?? this.loadingOrderId,
        taskId: taskId ?? this.taskId,
        userId: userId ?? this.userId,
        message: message ?? this.message,
        type: type ?? this.type,
        createDate: createDate ?? this.createDate,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    sent: json["sent"] == null ? null : json["sent"],
    read: json["read"] == null ? null : json["read"],
    id: json["_id"] == null ? null : json["_id"],
    operationId: json["operationId"] == null ? null : json["operationId"],
    travelId: json["travelId"] == null ? null : json["travelId"],
    loadingOrderId: json["loadingOrderId"] == null ? null : json["loadingOrderId"],
    taskId: json["taskId"] == null ? null : json["taskId"],
    userId: json["userId"] == null ? null : json["userId"],
    message: json["message"] == null ? null : json["message"],
    type: json["type"] == null ? null : json["type"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
  );

  Map<String, dynamic> toJson() => {
    "sent": sent == null ? null : sent,
    "read": read == null ? null : read,
    "_id": id == null ? null : id,
    "operationId": operationId == null ? null : operationId,
    "travelId": travelId == null ? null : travelId,
    "loadingOrderId": loadingOrderId == null ? null : loadingOrderId,
    "taskId": taskId == null ? null : taskId,
    "userId": userId == null ? null : userId,
    "message": message == null ? null : message,
    "type": type == null ? null : type,
    "createDate": createDate == null ? null : createDate!.toIso8601String(),
  };
}
