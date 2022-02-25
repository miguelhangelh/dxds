
import 'package:equatable/equatable.dart';

class ResourceEntity extends Equatable {

  final String? description;
  final String? path;

  ResourceEntity( {
    this.description,
    this.path,
  } );

  @override
  List<Object?> get props => [
    description,
    path,
  ];
  
}
