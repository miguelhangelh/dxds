

import 'package:appdriver/features/profile/domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {

  AccountModel( {
    String? disableDate,
    String? createDate,
    String? updateDate,
  } ) : super(
    createDate: createDate,
    disableDate: disableDate,
    updateDate: updateDate,
  );

  AccountModel copyWith({
    String? disableDate,
    String? createDate,
    String? updateDate,
  }) {
    return AccountModel(
      disableDate : disableDate ?? this.disableDate,
      createDate  : createDate ?? this.createDate,
      updateDate  : updateDate ?? this.updateDate,
    );
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
      disableDate: json.containsKey( 'disableDate' ) ? json["disableDate"] : '',
      createDate:  json.containsKey( 'createDate' ) ? json["createDate"]  : '',
      updateDate:  json.containsKey( 'updateDate' ) ? json["updateDate"]  : '',
  );

  Map<String, dynamic> toJson() => {
      "disableDate": disableDate,
      "createDate" : createDate,
      "updateDate" : updateDate,
  };

}
