import 'package:appdriver/features/benefits/domain/repositories/benefits_repository.dart';
import 'package:appdriver/features/benefits/data/datasources/remote/benefits_datasource_remote.dart';
import 'package:appdriver/features/benefits/data/models/benefit_model.dart';

class BenefitsRepositoryImplementation extends BenefitsRepository {
  final BenefitsDataSourceRemote benefitsDataSourceRemote;

  BenefitsRepositoryImplementation({required this.benefitsDataSourceRemote});

  @override
  Future<List<BenefitModel>> getBenefitsAll() async {
    return await benefitsDataSourceRemote.getBenefitsAll();
  }
}
