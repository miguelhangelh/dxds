import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/models/operation_past_model.dart';
import 'package:appdriver/features/operation/data/datasources/operation_datasource_remote.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart';
import 'package:appdriver/features/operation/domain/repositories/operation_repository.dart';

class OperationRepositoryImplementation implements OperationRepository{
  final OperationDatasourceRemote? operationDasourceRemote;
  OperationRepositoryImplementation({required this.operationDasourceRemote});
  @override
  Future<Operation?> operation() async{
    return await operationDasourceRemote!.operation();
  }
  @override
  Future<TravelsPastModel?> getTravelsPastAll() async {
    return await operationDasourceRemote!.getTravelsPastAll();
  }
  @override
  Future<Rating?> getRating({TravelModel? travel}) async {
    return await  operationDasourceRemote!.getRating(travel:travel!);
  }
}