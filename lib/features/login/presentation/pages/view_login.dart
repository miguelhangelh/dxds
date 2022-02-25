import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/pages/login_phone_number_view_1.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class LoginMainView extends StatelessWidget {
  const LoginMainView({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginMainView());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // For both Android + iOS
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          width: 100.0.w,
          height: 100.0.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/truck.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w, top: 30.0.h, bottom: 10.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo-deltax.png',
                  height: 38.0,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    RoundedButton(
                      onPressed: () {
                        NavigatorExtension.pushAndRemoveUntil(const LoginPhoneNumberView(), context);
                      },
                      label: ' Iniciar sesión',
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundedButton(
                      onPressed: () {
                        NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
                      },
                      underline: true,
                      fontSize: 14,
                      label: S.of(context).guest, //S.of(context).task,
                      textColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.transparent,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
