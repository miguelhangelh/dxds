import 'dart:async';
import 'dart:convert';
import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_all_exchange_rate_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appdriver/core/error/errors.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/opportunity/domain/usecases/add_postulation_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/confirm_postulation_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/cancelled_postulation_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunity_all_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunity_by_id_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunity_all_payments_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_oportunitys_round_trip_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_postulation_truck_usecase.dart';
import 'package:appdriver/features/opportunity/domain/usecases/get_category_all_usecase.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'opportunity_event.dart';
part 'opportunity_state.dart';

class OpportunityBloc extends Bloc<OpportunityEvent, OpportunityState> {
  UserPreference userPreference = UserPreference();
  final GetOportunityAllUseCase getOportunityAllUsecase;
  final GetOpportunityAllPaymentsUseCase getOpportunityAllPaymentsUseCase;
  final GetCategoryAllUseCase getCategoryAllUseCase;
  final GetAllExchangeRateUseCase getAllExchangeRateUseCase;
  final GetOpportunityAllRoundTripUseCase getOportunityAllRoundTripUsecase;
  final AddPostulationUseCase addPostulationUsecase;
  final ConfirmPostulationUseCase confirmPostulationUsecase;
  final CancelledPostulationUseCase cancelledPostulationUsecase;
  final GetPostulationTruckUseCase getPostulationTruckUsecase;
  final GetOportunityByIdUseCase getOportunityByIdUseCase;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int currentPage = 0;
  int size = 10;
  int totalPages = 0;
  OpportunityBloc({
    required this.getOportunityAllUsecase,
    required this.getAllExchangeRateUseCase,
    required this.getOportunityByIdUseCase,
    required this.getCategoryAllUseCase,
    required this.getOpportunityAllPaymentsUseCase,
    required this.getOportunityAllRoundTripUsecase,
    required this.cancelledPostulationUsecase,
    required this.addPostulationUsecase,
    required this.confirmPostulationUsecase,
    required this.getPostulationTruckUsecase,
  }) : super(OpportunityState.initialState);

  void onRefresh() async {
    add(GetTravels(isRefresh: true, typeFilter: state.typeFilter, end: state.end, start: state.start, category: state.category));
  }

  void onLoading() async {
    add(GetTravels(isRefresh: false, typeFilter: state.typeFilter, end: state.end, start: state.start, category: state.category));
  }

  void retryTravels() {
    add(GetTravels(
      isRefresh: true,
      typeFilter: state.typeFilter,
      end: state.end,
      start: state.start,
      category: state.category,
    ));
  }

  void retryTravelsPayments() {
    add(GetTravelsPayments(isFilterPaid: state.isFilterPaid, isFilterToPaid: state.isFilterToPaid));
  }

  @override
  Stream<OpportunityState> mapEventToState(
    OpportunityEvent event,
  ) async* {
    if (event is GetAllExchangeRate) {
      List<ExchangeRate>? exchangesRates = await getAllExchangeRateUseCase();
      var response = ApiResponse.completed(exchangesRates);
      yield state.copyWith(exchangeRates: response.data);
    }
    if (event is GetFilterCategory) {
      List<CategoryModel>? categories = await getCategoryAllUseCase();
      var response = ApiResponse.completed(categories);
      yield state.copyWith(categories: response.data);
    }
    if (event is GetPostulationTruck) {
      yield state.copyWith(loading: true);
      var postulanteResponse = await getPostulationTruckUsecase(travelId: event.travelId);
      var response = ApiResponse.completed(postulanteResponse);
      yield state.copyWith(postulation: response.data, loading: false);
    }
    if (event is GetTravelsFilterDates) {}
    if (event is GetTravels) {
      if (state.initial) {
        yield state.copyWith(status: ResponseStatus.LOADING);
      }
      try {
        List<TravelModel> travelsNew = [];
        if (event.typeFilter == TypeFilter.NONE) {
          yield state.copyWith(typeFilter: TypeFilter.NONE);
          if (event.isRefresh) {
            currentPage = 0;
            // yield state.copyWith(status: ResponseStatus.LOADING);
          } else {
            currentPage++;
          }
          List<TravelModel>? travels = await getOportunityAllUsecase(page: currentPage, typeFilter: TypeFilter.NONE);
          var response = ApiResponse.completed(travels);

          if (event.isRefresh) {
            travelsNew = List<TravelModel>.from(response.data!);
            if (response.data == null) {
              refreshController.loadNoData();
            } else {
              refreshController.refreshCompleted(resetFooterState: true);
            }
            for (var element in travelsNew) {
              if (element.postulation != null) {
                element.postulation!.removeWhere((element) => element.cancelledDate != null);
              }
            }
          } else {
            travelsNew = List<TravelModel>.from(state.travels!);
            if (response.data == null || response.data!.isEmpty) {
              refreshController.loadNoData();
            } else {
              travelsNew.addAll(response.data!);
              refreshController.loadComplete();
            }
            for (var element in travelsNew) {
              if (element.postulation != null) {
                element.postulation!.removeWhere((element) => element.cancelledDate != null);
              }
            }
          }
          yield state.copyWith(travels: travelsNew, status: ResponseStatus.COMPLETED, initial: false);
        }
        if (event.typeFilter == TypeFilter.DATE) {
          state.start = event.start;
          state.end = event.end;
          yield state.copyWith(typeFilter: TypeFilter.DATE);
          if (event.isRefresh) {
            currentPage = 0;
            // yield state.copyWith(status: ResponseStatus.LOADING, isFilterDate: true);
          } else {
            currentPage++;
          }
          List<TravelModel>? travels = [];
          if (state.end != null && state.start != null && state.category == null) {
            travels = await getOportunityAllUsecase(page: currentPage, start: state.start, end: state.end, typeFilter: TypeFilter.DATE);
          } else if (state.end != null && state.start != null && state.category != null) {
            travels = await getOportunityAllUsecase(
                page: currentPage, start: state.start, end: state.end, category: event.category?.id, typeFilter: TypeFilter.ALL);
          } else if (state.end == null && state.start == null && state.category != null) {
            travels = await getOportunityAllUsecase(page: currentPage, category: event.category?.id, typeFilter: TypeFilter.CATEGORY);
          } else if (state.end == null && state.start == null && state.category == null) {
            travels = await getOportunityAllUsecase(page: currentPage, typeFilter: TypeFilter.NONE);
          }
          var response = ApiResponse.completed(travels);
          if (event.isRefresh) {
            travelsNew = List<TravelModel>.from(response.data!);
            if (response.data == null) {
              refreshController.loadNoData();
            } else {
              refreshController.refreshCompleted(resetFooterState: true);
            }
            for (var element in travelsNew) {
              if (element.postulation != null) {
                element.postulation!.removeWhere((element) => element.cancelledDate != null);
              }
            }
          } else {
            travelsNew = List<TravelModel>.from(state.travels!);
            if (response.data == null || response.data!.isEmpty) {
              refreshController.loadNoData();
            } else {
              travelsNew.addAll(response.data!);
              refreshController.loadComplete();
            }
            for (var element in travelsNew) {
              if (element.postulation != null) {
                element.postulation!.removeWhere((element) => element.cancelledDate != null);
              }
            }
          }
          yield state.copyWith(travels: travelsNew, status: ResponseStatus.COMPLETED, initial: false);
        }
        if (event.typeFilter == TypeFilter.CATEGORY) {
          state.category = event.category;
          yield state.copyWith(typeFilter: TypeFilter.CATEGORY);
          if (event.isRefresh) {
            currentPage = 0;
            yield state.copyWith(status: ResponseStatus.LOADING);
          } else {
            currentPage++;
          }
          List<TravelModel>? travels = [];
          if (state.end != null && state.start != null && state.category == null) {
            travels = await getOportunityAllUsecase(page: currentPage, start: state.start, end: state.end, typeFilter: TypeFilter.DATE);
          } else if (state.end != null && state.start != null && state.category != null) {
            travels = await getOportunityAllUsecase(
                page: currentPage, start: state.start, end: state.end, category: event.category?.id, typeFilter: TypeFilter.ALL);
          } else if (state.end == null && state.start == null && state.category != null) {
            travels = await getOportunityAllUsecase(page: currentPage, category: event.category?.id, typeFilter: TypeFilter.CATEGORY);
          } else if (state.end == null && state.start == null && state.category == null) {
            travels = await getOportunityAllUsecase(page: currentPage, typeFilter: TypeFilter.NONE);
          }
          var response = ApiResponse.completed(travels);

          if (event.isRefresh) {
            travelsNew = List<TravelModel>.from(response.data!);
            if (response.data == null) {
              refreshController.loadNoData();
            } else {
              refreshController.refreshCompleted(resetFooterState: true);
            }
            for (var element in travelsNew) {
              if (element.postulation != null) {
                element.postulation!.removeWhere((element) => element.cancelledDate != null);
              }
            }
          } else {
            travelsNew = List<TravelModel>.from(state.travels!);
            if (response.data == null || response.data!.isEmpty) {
              refreshController.loadNoData();
            } else {
              travelsNew.addAll(response.data!);
              refreshController.loadComplete();
            }
            for (var element in travelsNew) {
              if (element.postulation != null) {
                element.postulation!.removeWhere((element) => element.cancelledDate != null);
              }
            }
          }
          yield state.copyWith(travels: travelsNew, status: ResponseStatus.COMPLETED, initial: false);
        }
      } on FetchDataException catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(
          status: response.status,
          messages: response.message,
        );
      } catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(
          status: response.status,
          messages: "Algo salió mal. Intenta de nuevo",
        );
      }
    }
    if (event is GetTravelsPayments) {
      try {
        yield state.copyWith(loading: true, isFilterPaid: event.isFilterPaid, isFilterToPaid: event.isFilterToPaid);
        List<TravelModel>? travels = [];
        if (state.isFilterPaid == false && state.isFilterToPaid == false) {
          travels = await getOpportunityAllPaymentsUseCase(typeFilter: 'full');
        } else if (state.isFilterPaid == true && state.isFilterToPaid == false) {
          travels = await getOpportunityAllPaymentsUseCase(typeFilter: 'paid');
        } else if (state.isFilterPaid == false && state.isFilterToPaid == true) {
          travels = await getOpportunityAllPaymentsUseCase(typeFilter: 'topaid');
        } else if (state.isFilterPaid == true && state.isFilterToPaid == true) {
          travels = await getOpportunityAllPaymentsUseCase(typeFilter: 'full');
        }
        List<ExchangeRate>? exchangesRates = await getAllExchangeRateUseCase();
        var responseExchange = ApiResponse.completed(exchangesRates);
        var response = ApiResponse.completed(travels);
        List<TravelModel> copy = List<TravelModel>.from(response.data!);
        yield state.copyWith(travels: copy, exchangeRates: responseExchange.data, loading: false);
      } catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(status: response.status, messages: response.message, loading: false);
      }
    }
    if (event is GetTravelsRoundTrip) {
      List<TravelModel>? travels = await getOportunityAllRoundTripUsecase(event.travel!);
      var response = ApiResponse.completed(travels);
      yield state.copyWith(travelsRoundTrips: response.data, loading: false);
    }
    if (event is OpportunityPostulationAdd) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        var postulation = await addPostulationUsecase(postulation: event.postulationRequest);
        var response = ApiResponse.completed(postulation);
        userPreference.setTravelPostulation = json.encode(response.data);
        yield state.copyWith(loading: false, formStatus: SubmissionSuccess(), successPostulation: true);
      } on BadRequestException catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(formStatus: SubmissionFailed(Exception(response.message)), messages: response.message);
      } catch (e) {
        var response = ApiResponse.error(e.toString());
        yield state.copyWith(formStatus: SubmissionFailed(Exception(response.message)), messages: response.message);
      }
    }
    if (event is OpportunityPostulationConfirm) {
      yield state.copyWith(formStatus: FormSubmitting());
      try {
        var postulation = await confirmPostulationUsecase(postulation: event.postulationRequest);
        var response = ApiResponse.completed(postulation);
        postulation = response.data;
        postulation!.postulation!.confirmedDate = DateTime.now();
        userPreference.setTravelPostulation = json.encode(postulation);
        yield state.copyWith(loading: false, formStatus: SubmissionSuccess(), confirmPostulation: true);
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(Exception('failed')));
      }
    }
    if (event is OpportunityPostulationCancelled) {
      yield state.copyWith(formStatusCancelled: FormSubmitting());
      try {
        await cancelledPostulationUsecase(postulation: event.postulationRequest);
        yield state.copyWith(loading: false, formStatusCancelled: SubmissionSuccess(), cancelPostulation: true);
      } catch (e) {
        yield state.copyWith(formStatusCancelled: SubmissionFailed(Exception('failed')));
      }
    }
    if (event is OpportunityClosedSuccess) {
      yield state.copyWith(loading: false, successPostulation: false);
    }
    if (event is OpportunityGetById) {
      TravelModel? travel;
      if (event.isDetailNotification!) {
        yield state.copyWith(loading: true);
        TravelModel? responseApi = await getOportunityByIdUseCase(travelId: event.travelId);
        var response = ApiResponse.completed(responseApi);
        travel = response.data;
      } else {
        travel = event.travel;
      }
      yield state.copyWith(travelItem: travel, loading: false);
      add(GetTravelsRoundTrip(travel: travel));
    }
  }
}
