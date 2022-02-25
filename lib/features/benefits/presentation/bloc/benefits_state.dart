part of 'benefits_bloc.dart';

class BenefitState extends Equatable {
  final List<BenefitModel>? benefits;
  final bool? loading;
  final bool? initial;
  const BenefitState({
    this.benefits,
    this.loading,
    this.initial = true,
  });
  static BenefitState get initialState => const BenefitState(
        benefits: [],
        loading: false,
        initial: true,
      );
  BenefitState copyWith({
    List<BenefitModel>? benefits,
    bool? loading,
    bool? initial,
  }) {
    return BenefitState(
      benefits: benefits ?? this.benefits,
      loading: loading ?? this.loading,
      initial: initial ?? this.initial,
    );
  }

  @override
  List<Object?> get props => [benefits, loading, initial];

  factory BenefitState.fromMap(Map<String, dynamic> map) => BenefitState(
        loading: map["loading"] == null ? null : map["loading"],
        benefits: map['benefits'] == null ? null : List<BenefitModel>.from(map['benefits']?.map((x) => BenefitModel.fromJson(x))),
      );

  Map<String, dynamic> toMap() {
    return {
      'loading': loading == null ? null : loading,
      'benefits': benefits == null ? null : List<dynamic>.from(benefits!.map((x) => x.toJson())),
    };
  }
}
