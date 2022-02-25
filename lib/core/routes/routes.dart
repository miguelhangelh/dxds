import 'package:flutter/material.dart';
import 'package:appdriver/features/benefits/presentation/pages/benefits_page.dart';
import 'package:appdriver/features/login/presentation/pages/view_login.dart';
import 'package:appdriver/features/notification/presentation/pages/notification_page.dart';
import 'package:appdriver/features/operation/presentation/pages/operation_page.dart';
import 'package:appdriver/features/operation/presentation/pages/show_operation_page.dart';
import 'package:appdriver/features/opportunity/presentation/pages/detail_opportunity_page.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/payment/presentation/pages/travel_payment_page.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/pages/login_phone_number_view_1.dart';
import 'package:appdriver/features/profile/presentation/pages/account/account_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/profile/register_profile_page.dart';
import 'package:appdriver/features/profile/presentation/pages/account/profile_edit_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_data_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_features_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_type_page.dart';
import 'package:appdriver/features/operation/presentation/pages/travels_past_page.dart';
import 'package:appdriver/global_widgets/custom_success.dart';
import 'package:appdriver/features/operation/presentation/pages/operation_camera_task.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (BuildContext context) => const HomeMainView(),
  'transportunittype': (BuildContext context) => const TransportUnitTypePage(),
  'transport_unit_data_route': (BuildContext context) => const TransportUnitDataPage(),
  'transport_unit_features_route': (BuildContext context) => const TransportUnitFeaturesPage(),
  'profile': (BuildContext context) => const PrincipalProfilePage(),
  'profileedit': (BuildContext context) => const ProfileEditPageView(),
  'opportunity': (BuildContext context) => const OpportunityPage(),
  'payment': (BuildContext context) => TravelPaymentPage(),
  'benefits': (BuildContext context) => const BenefitsPage(),
  'notification': (BuildContext context) => const NotificationPage(),
  'detail_oportunity': (BuildContext context) => const DetailOpportunityPage(),
  'success': (BuildContext context) => const SuccessPage(),
  'login': (BuildContext context) => const LoginMainView(),
  'loginPhone': (BuildContext context) => const LoginPhoneNumberView(),
  OperationPage.routeName: (BuildContext context) => const OperationPage(),
  TravelPastPage.routeName: (BuildContext context) => const TravelPastPage(),
  ShowOperationPage.routeName: (BuildContext context) => const ShowOperationPage(),
  SuccessPage.routeName: (BuildContext context) => const SuccessPage(),
};
