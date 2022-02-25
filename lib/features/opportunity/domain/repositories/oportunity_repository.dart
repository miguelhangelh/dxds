import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';

abstract class OportunityRepository {
  Future<List<TravelModel>> getOpportunityAll({
    int? page,
    DateTime? end,
    DateTime? start,
    String? category,
    TypeFilter? typeFilter,
  });
  Future<List<CategoryModel>> getCategoryAll();
  Future<PostulationRequest?> addPostulation(PostulationRequest? postulationRequest);
  Future<PostulationRequest?> confirmPostulation(PostulationRequest? postulationRequest);
  Future<PostulationRequest?> getPostulationTruck(String? travelId);
  Future<List<ExchangeRate>> getAllExchangeRate();
  Future<List<TravelModel>> getOpportunityAllRoundTrip(TravelModel travel);
  Future<PostulationRequest?> cancelledPostulation({PostulationRequest? postulation});
  Future<List<TravelModel>> getOpportunityAllPayments({
    int? page,
    String? typeFilter,
  });
  Future<TravelModel> getOpportunityById({
    String? travelId,
  });
}
