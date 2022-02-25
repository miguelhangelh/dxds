
import 'package:appdriver/features/profile/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  
  CompanyModel( {
    String? companyId,
    String? assignationDate,
    bool? active,
  }) : super(
    companyId: companyId,
    assignationDate: assignationDate,
    active: active,
  );

  CompanyModel copyWith({
    String? companyId,
    String? assignationDate,
    bool? active,
  }) {
    return CompanyModel(
      companyId       : companyId ?? this.companyId,
      assignationDate : assignationDate ?? this.assignationDate,
      active          : active ?? this.active,
    );
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
      companyId       : json.containsKey( 'companyId' ) ? json["companyId"] : '',
      assignationDate : json.containsKey( 'assignationDate' ) ? json["assignationDate"] : '',
      active          : json.containsKey( 'active' ) ? json["active"] : '' as bool?,
  );

  Map<String, dynamic> toJson() => {
      "companyId"       : companyId,
      "assignationDate" : assignationDate,
      "active"          : active,
  };

}