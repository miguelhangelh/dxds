import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/benefits/data/models/benefit_model.dart';

class BenefitsDataSourceRemote {
  final ApiBaseHelper _helper =  ApiBaseHelper();
  final UserPreference userPreference =  UserPreference();

  Future<List<BenefitModel>> getBenefitsAll() async {
    var url = dotenv.env['URL_BENEFITS'];
    var response = await _helper.get(url, queryParameters: {'app': true});
    var data = response['benefits'] as List;
    List<BenefitModel> benefits = data.map<BenefitModel>((e) => BenefitModel.fromJson(e)).toList();
    return benefits;
  }
}
