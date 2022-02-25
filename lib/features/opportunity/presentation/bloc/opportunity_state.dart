part of 'opportunity_bloc.dart';

class OpportunityState extends Equatable {
  final List<TravelModel>? travels;
  final List<TravelModel>? travelsRoundTrips;
  final List<ExchangeRate>? exchangeRates;
  final List<CategoryModel>? categories;
  final FormSubmissionStatus? formStatus;
  final FormSubmissionStatus? formStatusCancelled;
  final bool? loading;
  final bool initial;
  final bool? successPostulation;
  final bool? cancelPostulation;
  final bool? confirmPostulation;
  final TypeFilter? typeFilter;
  DateTime? start;
  DateTime? end;
  CategoryModel? category;
  final bool? isFilterDate;
  final bool? isFilterCategory;
  final bool? isFilterPaid;
  final bool? isFilterToPaid;
  final ResponseStatus? status;
  final String? messages;
  final TravelModel? travelItem;
  final PostulationRequest? postulation;
  OpportunityState({
    this.travels,
    this.categories,
    this.messages,
    this.exchangeRates,
    this.isFilterDate,
    this.isFilterCategory,
    this.start,
    this.end,
    this.initial = true,
    this.status,
    this.cancelPostulation,
    this.category,
    this.typeFilter,
    this.formStatus,
    this.formStatusCancelled,
    this.travelsRoundTrips,
    this.isFilterPaid,
    this.isFilterToPaid,
    this.loading,
    this.successPostulation,
    this.confirmPostulation,
    this.postulation,
    this.travelItem,
  });
  static OpportunityState get initialState => OpportunityState(
        travels: const [],
        categories: const [],
        exchangeRates: const [],
        loading: false,
        isFilterDate: false,
        typeFilter: TypeFilter.NONE,
        end: null,
        isFilterPaid: false,
        isFilterToPaid: false,
        initial: true,
        category: null,
        start: null,
        travelItem: null,
        isFilterCategory: false,
        cancelPostulation: false,
        confirmPostulation: false,
        messages: '',
        status: ResponseStatus.NONE,
        travelsRoundTrips: const [],
        postulation: null,
        successPostulation: false,
        formStatus: const InitialFormStatus(),
        formStatusCancelled: const InitialFormStatus(),
      );
  @override
  List<Object?> get props => [
        travels,
        formStatus,
        messages,
        exchangeRates,
        isFilterCategory,
        categories,
        loading,
        isFilterDate,
        cancelPostulation,
        end,
        isFilterPaid,
        initial,
        travelItem,
        isFilterToPaid,
        category,
        start,
        postulation,
        typeFilter,
        successPostulation,
        confirmPostulation,
        travelsRoundTrips,
        formStatusCancelled,
        status,
      ];

  OpportunityState copyWith({
    List<TravelModel>? travels,
    List<CategoryModel>? categories,
    List<ExchangeRate>? exchangeRates,
    List<TravelModel>? travelsRoundTrips,
    FormSubmissionStatus? formStatus,
    FormSubmissionStatus? formStatusCancelled,
    bool? loading,
    bool? initial,
    bool? isFilterDate,
    TravelModel? travelItem,
    TypeFilter? typeFilter,
    CategoryModel? category,
    bool? cancelPostulation,
    bool? confirmPostulation,
    bool? isFilterCategory,
    DateTime? start,
    DateTime? end,
    ResponseStatus? status,
    bool? isFilterPaid,
    bool? isFilterToPaid,
    bool? successPostulation,
    String? messages,
    PostulationRequest? postulation,
  }) {
    return OpportunityState(
      travels: travels ?? this.travels,
      exchangeRates: exchangeRates ?? this.exchangeRates,
      initial: initial ?? this.initial,
      end: end ?? this.end,
      travelItem: travelItem ?? this.travelItem,
      category: category ?? this.category,
      cancelPostulation: cancelPostulation ?? this.cancelPostulation,
      confirmPostulation: confirmPostulation ?? this.confirmPostulation,
      isFilterPaid: isFilterPaid ?? this.isFilterPaid,
      isFilterToPaid: isFilterToPaid ?? this.isFilterToPaid,
      start: start ?? this.start,
      categories: categories ?? this.categories,
      typeFilter: typeFilter ?? this.typeFilter,
      isFilterDate: isFilterDate ?? this.isFilterDate,
      isFilterCategory: isFilterCategory ?? this.isFilterCategory,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      travelsRoundTrips: travelsRoundTrips ?? this.travelsRoundTrips,
      postulation: postulation ?? this.postulation,
      loading: loading ?? this.loading,
      formStatus: formStatus ?? this.formStatus,
      formStatusCancelled: formStatusCancelled ?? this.formStatusCancelled,
      successPostulation: successPostulation ?? this.successPostulation,
    );
  }
}
