import 'package:appdriver/features/models/operation_past_model.dart';
import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart';

abstract class OperationRepository{

  Future<Operation?> operation();
  Future<TravelsPastModel?> getTravelsPastAll();
  Future<Rating?> getRating({TravelModel? travel});
}