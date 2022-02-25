import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/features/benefits/data/models/benefit_model.dart';
import 'package:appdriver/features/benefits/domain/usecases/get_benefits_all_usecase.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
part 'benefits_event.dart';
part 'benefits_state.dart';

class BenefitsBloc extends HydratedBloc<BenefitsEvent, BenefitState> {
  GetBenefitsAllUseCase getBenefitsAllUseCase;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  BenefitsBloc({
    required this.getBenefitsAllUseCase,
  }) : super(BenefitState.initialState);
  @override
  Stream<BenefitState> mapEventToState(
    BenefitsEvent event,
  ) async* {
    if (event is GetBenefits) {
      if (!refreshController.isRefresh) {
        yield state.copyWith(loading: true);
      }
      try {
        List<BenefitModel>? response = await getBenefitsAllUseCase();
        var data = ApiResponse.completed(response);

        if (refreshController.isRefresh) {
          refreshController.refreshCompleted(resetFooterState: true);
        }
        yield state.copyWith(benefits: data.data, loading: false);
      } catch (e) {
        yield state.copyWith(loading: false, benefits: []);
      }
    }
  }

  void onRefresh() async {
    add(GetBenefits(
      isRefresh: true,
    ));
  }

  void onLoading() async {
    add(GetBenefits(
      isRefresh: false,
    ));
  }

  @override
  BenefitState fromJson(Map<String, dynamic> json) {
    return BenefitState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(BenefitState state) {
    return state.toMap();
  }
}
