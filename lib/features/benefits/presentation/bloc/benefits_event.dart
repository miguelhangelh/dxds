part of 'benefits_bloc.dart';

abstract class BenefitsEvent {}

class GetBenefits extends BenefitsEvent {
  final bool isRefresh;

  GetBenefits({
    this.isRefresh = false,
  });

}
