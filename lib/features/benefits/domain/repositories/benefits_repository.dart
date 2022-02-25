import 'package:appdriver/features/benefits/data/models/benefit_model.dart';

abstract class BenefitsRepository {
  Future<List<BenefitModel>> getBenefitsAll();
}
