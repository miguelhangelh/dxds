import 'package:hive/hive.dart';
part 'tasks_local.g.dart';

@HiveType(typeId: 10)
class TaskLocal extends HiveObject implements Comparable {
  TaskLocal({
    this.id,
    this.taskId,
    this.name,
    this.changeStage,
    this.order,
    this.viewCarrier,
    this.viewClient,
    this.allowFiles,
    this.pushNotification,
    this.emailNotification,
    this.smsNotification,
    this.state,
    this.contentType,
    this.dateRealized,
    this.loadingOrderId,
    this.idStage,
    this.file = const [],

    ///ALLOW
    this.allowOperator,
    this.allowCarrier,
    this.allowClient,
    this.validationOperator,
    this.validationCarrier,
    this.validationClient,
    this.dateAction,
    this.dateValidation,
    this.approve,
    this.ifValidation,
    this.comment,
  });

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? taskId;
  @HiveField(2)
  String? name;
  @HiveField(3)
  bool? changeStage;
  @HiveField(4)
  int? order;
  @HiveField(5)
  bool? viewCarrier;
  @HiveField(6)
  bool? viewClient;
  @HiveField(7)
  bool? allowFiles;
  @HiveField(8)
  bool? pushNotification;
  @HiveField(9)
  bool? emailNotification;
  @HiveField(10)
  bool? smsNotification;

  @HiveField(11)
  int? state;
  @HiveField(12)
  String? contentType;
  @HiveField(13)
  String? dateRealized;
  @HiveField(14)
  String? loadingOrderId;
  @HiveField(15)
  List<String> file;
  @HiveField(16)
  String? idStage;

  @HiveField(17)
  bool? allowOperator;
  @HiveField(18)
  bool? allowCarrier;
  @HiveField(19)
  bool? allowClient;
  @HiveField(20)
  bool? validationOperator;
  @HiveField(21)
  bool? validationCarrier;
  @HiveField(22)
  bool? validationClient;
  @HiveField(23)
  String? dateAction;
  @HiveField(24)
  String? dateValidation;
  @HiveField(25)
  bool? ifValidation;
  @HiveField(26)
  bool? approve;
  @HiveField(27)
  String? comment;

  factory TaskLocal.fromJson(Map<String, dynamic> json) => TaskLocal(
        id: json["_id"] == null ? null : json["_id"],
        taskId: json["taskId"] == null ? null : json["taskId"],
        idStage: json["idStage"] == null ? null : json["idStage"],
        dateRealized: json["dateRealized"] == null ? null : json["dateRealized"],
        loadingOrderId: json["loadingOrderId"] == null ? null : json["loadingOrderId"],
        state: json["state"] == null ? null : json["state"],
        contentType: json["contentType"] == null ? null : json["contentType"],
        allowOperator: json["allowOperator"] == null ? null : json["allowOperator"],
        allowCarrier: json["allowCarrier"] == null ? null : json["allowCarrier"],
        allowClient: json["allowClient"] == null ? null : json["allowClient"],
        validationOperator: json["validationOperator"] == null ? null : json["validationOperator"],
        validationCarrier: json["validationCarrier"] == null ? null : json["validationCarrier"],
        validationClient: json["validationClient"] == null ? null : json["validationClient"],
        dateAction: json["dateAction"] == null ? null : json["dateAction"],
        dateValidation: json["dateValidation"] == null ? null : json["dateValidation"],
        name: json["name"] == null ? null : json["name"],
        file: json["file"] == null ? [] : List<String>.from(json["file"].map((x) => x)),
        changeStage: json["changeStage"] == null ? null : json["changeStage"],
        order: json["order"] == null ? null : json["order"],
        viewCarrier: json["viewCarrier"] == null ? null : json["viewCarrier"],
        viewClient: json["viewClient"] == null ? null : json["viewClient"],
        allowFiles: json["allowFiles"] == null ? null : json["allowFiles"],
        pushNotification: json["pushNotification"] == null ? null : json["pushNotification"],
        emailNotification: json["emailNotification"] == null ? null : json["emailNotification"],
        smsNotification: json["smsNotification"] == null ? null : json["smsNotification"],
        ifValidation: json["ifValidation"] == null ? null : json["ifValidation"],
        approve: json["approve"] == null ? null : json["approve"],
        comment: json["comment"] == null ? null : json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "taskId": taskId == null ? null : taskId,
        "idStage": idStage == null ? null : idStage,
        "dateRealized": dateRealized == null ? null : dateRealized,
        "loadingOrderId": loadingOrderId == null ? null : loadingOrderId,
        "state": state == null ? null : state,
        "contentType": contentType == null ? null : contentType,
        'allowOperator': allowOperator == null ? null : allowOperator,
        "allowCarrier": allowCarrier == null ? null : allowCarrier,
        'allowClient': allowClient == null ? null : allowClient,
        "validationOperator": validationOperator == null ? null : validationOperator,
        "validationCarrier": validationCarrier == null ? null : validationCarrier,
        'validationClient': validationClient == null ? null : validationClient,
        "dateAction": dateAction == null ? null : dateAction,
        "dateValidation": dateValidation == null ? null : dateValidation,
        "name": name == null ? null : name,
        "file": List<String>.from(file.map((x) => x)),
        "changeStage": changeStage == null ? null : changeStage,
        "order": order == null ? null : order,
        'viewCarrier': viewCarrier == null ? null : viewCarrier,
        "viewClient": viewClient == null ? null : viewClient,
        'allowFiles': allowFiles == null ? null : allowFiles,
        "pushNotification": pushNotification == null ? null : pushNotification,
        "emailNotification": emailNotification == null ? null : emailNotification,
        'smsNotification': smsNotification == null ? null : smsNotification,
        'ifValidation': ifValidation == null ? null : ifValidation,
        'approve': approve == null ? null : approve,
        'comment': comment == null ? null : comment,
      };

  @override
  int compareTo(other) {
    if (this.state! < other.state) {
      return 1;
    }

    if (this.state! > other.state) {
      return -1;
    }

    if (this.state == other.state) {
      return 0;
    }

    return 0;
  }
}

// enum STATE_TASK {
//   UNREALIZED,
//   DONE,
//   PENDING,
// }
