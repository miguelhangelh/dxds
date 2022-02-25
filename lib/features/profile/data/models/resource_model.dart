
import 'package:appdriver/features/profile/domain/entities/resource_entity.dart';

class ResourceModel extends ResourceEntity {

  ResourceModel( {
    String? description,
    String? path,
  } ) : super(
    description: description,
    path: path,
  );

  ResourceModel copyWith({
    String? description,
    String? path,
  }) {
    return ResourceModel(
      description : description ?? this.description,
      path: path ?? this.path,
    );
  }

  factory ResourceModel.fromJson(Map<String, dynamic> json) => ResourceModel(
    description : json.containsKey( 'description' ) ? json["description"] : '',
    path        : json.containsKey( 'path' ) ? json["path"] : '',
  );

  Map<String, dynamic> toJson() => {
    "description" : description,
    "path"        : path,
  };

}