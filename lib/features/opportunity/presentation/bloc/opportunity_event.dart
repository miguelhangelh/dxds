part of 'opportunity_bloc.dart';

enum TypeFilter { NONE, DATE, CATEGORY, ALL }

abstract class OpportunityEvent {}

class OpportunitySubmitted extends OpportunityEvent {}

class GetTravels extends OpportunityEvent {
  final TypeFilter? typeFilter;
  final bool isRefresh;
  final DateTime? end;
  final DateTime? start;
  final CategoryModel? category;
  GetTravels({
    this.isRefresh = false,
    this.end,
    this.start,
    this.category,
    this.typeFilter = TypeFilter.NONE,
  });
}

class GetTravelsFilterDates extends OpportunityEvent {
  final DateTime end;
  final DateTime start;
  GetTravelsFilterDates({required this.start, required this.end});
}

class GetTravelsPayments extends OpportunityEvent {
  final bool? isFilterPaid;
  final bool? isFilterToPaid;

  GetTravelsPayments({this.isFilterPaid = false, this.isFilterToPaid = false});
}

class GetFilterCategory extends OpportunityEvent {}

class OpportunityGetById extends OpportunityEvent {
  final String? travelId;
  final TravelModel? travel;
  final bool? isDetailNotification;
  OpportunityGetById({this.travelId, this.travel, this.isDetailNotification});
}

class GetTravelsRoundTrip extends OpportunityEvent {
  final TravelModel? travel;

  GetTravelsRoundTrip({this.travel});
}

class OpportunityPostulationAdd extends OpportunityEvent {
  final PostulationRequest? postulationRequest;

  OpportunityPostulationAdd({this.postulationRequest});
}

class OpportunityPostulationConfirm extends OpportunityEvent {
  final PostulationRequest? postulationRequest;

  OpportunityPostulationConfirm({this.postulationRequest});
}

class OpportunityPostulationCancelled extends OpportunityEvent {
  final PostulationRequest? postulationRequest;

  OpportunityPostulationCancelled({this.postulationRequest});
}

class OpportunityClosedSuccess extends OpportunityEvent {}
class GetAllExchangeRate extends OpportunityEvent {}

class GetPostulationTruck extends OpportunityEvent {
  final String? travelId;

  GetPostulationTruck({this.travelId});
}
