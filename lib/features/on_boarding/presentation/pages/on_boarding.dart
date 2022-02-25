import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/font_styles.dart';
import 'package:appdriver/features/authentication_aws/presentation/bloc/authentication_bloc.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:sizer/sizer.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return const OnBoardingView();
  }
}

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final controller = PageController(viewportFraction: 1);
  int _pageCurrent = 0;
  late AuthenticationBloc _authenticationBloc;
  late Size _size;
  UserPreference userPreference = UserPreference();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  Future<void> initPlatformState() async {
    bg.BackgroundGeolocation.onProviderChange((event) {});
    await bg.BackgroundGeolocation.ready(
      bg.Config(
          backgroundPermissionRationale: bg.PermissionRationale(
            title: "Permitir que DeltaX acceda a la ubicación de este dispositivo incluso cuando esté cerca o no esté en uso?",
            message: "DeltaX recopila datos de tu ubicación, para realizar seguimiento a las cargas que transportas",
            positiveAction: "Cambiar a 'Permitir todo el tiempo'",
            negativeAction: "Cancelar",
          ),
          locationAuthorizationRequest: 'Always'),
    );

    try {
      int status = await bg.BackgroundGeolocation.requestPermission();
      if (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
      } else if (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {}
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: _size.height,
            child: PageView(
              // physics: new NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _pageCurrent = index;
                });
              },
              controller: controller,
              children: [
                item(context),
                item2(context),
                item3(context),
              ],
            ),
          ),
          Positioned(
            top: (_size.height + 30) / 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: _size.width,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: SlideEffect(
                      spacing: 10.0,
                      radius: 0.0,
                      dotWidth: (constraints.maxWidth - 20) / 3,
                      dotHeight: 5.0,
                      dotColor: Colors.grey,
                      // paintStyle: PaintingStyle.stroke,
                      strokeWidth: 2,
                      activeDotColor: primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: _size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RoundedButton(
                      onPressed: () {
                        userPreference.onBoarding = true;
                        _authenticationBloc.add(AuthenticationStarted());
                      },
                      label: S.of(context).skip,
                      backgroundColor: const Color(0xffFAFAFA),
                      borderColor: const Color(0xffD9D9D9),
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: RoundedButton(
                      onPressed: () async {
                        if (_pageCurrent <= 0 || _pageCurrent <= 1) {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.linear,
                          );
                        } else {
                          _authenticationBloc.add(LoginMainViewEvent());
                          userPreference.onBoarding = true;
                          await initPlatformState();
                        }
                      },
                      label: 'Continuar',
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Stack item(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/oportunidades.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              height: (_size.height / 2),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: (_size.height / 2) - 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Oportunidades', style: FontStyles.title),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Podrás ver información de las oportunidades y cargas existentes en la zona que te encuentres. También podrás postularte a todas las oportunidades disponibles y realizar diferentes embarques.",
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }

  Stack item2(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/beneficios.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              height: (_size.height / 2),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: (_size.height / 2) - 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Beneficios', style: FontStyles.title),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "¡Al usar nuestra aplicación podrás tener los beneficios de distintos proveedores de productos y servicios que tenemos para ti!",
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }

  Stack item3(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/localizacion.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              height: (_size.height / 2),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: (_size.height / 2) - 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Uso de tu ubicación', style: FontStyles.title),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Al usar la App, tomaremos tu ubicación en segundo plano, para realizar seguimiento a las cargas que transportas. ¡Te acompañamos en el viaje!",
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }
}
