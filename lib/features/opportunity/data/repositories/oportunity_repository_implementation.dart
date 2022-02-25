import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/data/datasources/remote/oportunity_datasource_remote.dart';
import 'package:appdriver/features/opportunity/domain/repositories/oportunity_repository.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';

class OpportunityRepositoryImplementation extends OportunityRepository {
  final OpportunityDataSourceRemote opportunityDataSourceRemote;

  OpportunityRepositoryImplementation({required this.opportunityDataSourceRemote});
  @override
  Future<List<TravelModel>> getOpportunityAll({
    int? page,
    DateTime? end,
    DateTime? start,
    String? category,
    TypeFilter? typeFilter,
  }) async {
    return await opportunityDataSourceRemote.getOpportunities(page: page, end: end, start: start, category: category, typeFilter: typeFilter);
  }

  @override
  Future<List<CategoryModel>> getCategoryAll() async {
    return await opportunityDataSourceRemote.getCategoryAll();
  }

  @override
  Future<List<TravelModel>> getOpportunityAllPayments({
    int? page,
    String? typeFilter,
  }) async {
    return await opportunityDataSourceRemote.getOpportunityAllPayments(page: page, typeFilter: typeFilter);
  }

  @override
  Future<PostulationRequest?> addPostulation(PostulationRequest? postulationRequest) async {
    return await opportunityDataSourceRemote.addPostulation(postulationRequest!);
  }

  @override
  Future<PostulationRequest?> confirmPostulation(PostulationRequest? postulationRequest) async {
    return await opportunityDataSourceRemote.confirmPostulation(postulationRequest!);
  }

  @override
  Future<PostulationRequest?> getPostulationTruck(String? travelId) async {
    return await opportunityDataSourceRemote.getPostulationTruck(travelId!);
  }

  @override
  Future<List<TravelModel>> getOpportunityAllRoundTrip(TravelModel travel) async {
    return await opportunityDataSourceRemote.getOpportunityAllRoundTrip(travel);
  }

  @override
  Future<PostulationRequest?> cancelledPostulation({PostulationRequest? postulation}) async {
    return await opportunityDataSourceRemote.cancelledPostulation(postulation: postulation!);
  }

  @override
  Future<TravelModel> getOpportunityById({String? travelId}) async {
    return await opportunityDataSourceRemote.getOpportunityById(travelId: travelId);
  }

  @override
  Future<List<ExchangeRate>> getAllExchangeRate() async {
    return await opportunityDataSourceRemote.getAllExchangeRate();
  }
}
