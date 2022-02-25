
import 'package:appdriver/features/profile/domain/entities/row_entity.dart';

class RowModel extends RowEntity {

  RowModel( {
    String? createDate,
    String? updateDate,
    String? disableDate,
  } ) : super(
    createDate: createDate,
    updateDate: updateDate,
    disableDate: disableDate,
  );

  RowModel copyWith({
    String? createDate,
    String? updateDate,
    String? disableDate,
  }) {
    return RowModel(
      createDate  : createDate ?? this.createDate,
      updateDate  : updateDate ?? this.updateDate,
      disableDate : disableDate ?? this.disableDate,
    );
  }

  factory RowModel.fromJson(Map<String, dynamic> json) => RowModel(
      createDate  : json.containsKey( 'createDate' ) ? json["createDate"] : '',
      updateDate  : json.containsKey( 'updateDate' ) ? json["updateDate"] : '',
      disableDate : json.containsKey( 'disableDate' ) ? json["disableDate"] : '',
  );

  Map<String, dynamic> toJson() => {
      "createDate"  : createDate,
      "updateDate"  : updateDate,
      "disableDate" : disableDate,
  };

}