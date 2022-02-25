import 'dart:async';
import 'package:appdriver/core/utils/dialogs.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/bloc/phone_authentication1_bloc.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/features/profile/data/models/country_register.dart';
import 'package:appdriver/core/utils/font_styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../injection_container.dart';

class LoginPhoneNumberView extends StatelessWidget {
  const LoginPhoneNumberView({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPhoneNumberView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<PhoneAuthenticationBloc>(),
          child: _PhoneAuthViewBuilder(),
        ),
      ),
    );
  }
}

class _PhoneAuthViewBuilder extends StatefulWidget {
  @override
  __PhoneAuthViewBuilderState createState() => __PhoneAuthViewBuilderState();
}

class __PhoneAuthViewBuilderState extends State<_PhoneAuthViewBuilder> {
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  FocusNode number = FocusNode();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  StreamSubscription<String>? streamController;

  String phoneNumber = "";
  String? dialCode;

  List<DropdownMenuItem<CountryRegister>>? _dropdownMenuItems;
  CountryRegister? _selectedDeparment;
  late List<CountryRegister> _companies;
  PhoneAuthenticationBloc bloc = sl<PhoneAuthenticationBloc>();
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    ;
    _companies = CountryRegister.getCountries();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedDeparment = _dropdownMenuItems!.first.value;
    _countryCodeController.text = _selectedDeparment!.name.toString();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _listengSMS();
    });
  }

  List<DropdownMenuItem<CountryRegister>> buildDropdownMenuItems(List deparments) {
    List<DropdownMenuItem<CountryRegister>> items = [];
    for (CountryRegister department in deparments as Iterable<CountryRegister>) {
      items.add(
        DropdownMenuItem(
          value: department,
          child: Row(
            children: [
              Image.asset(
                'assets/${department.image}',
                width: 30,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(department.name),
            ],
          ),
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    bloc.textEditingController.dispose();
    errorController.close();
    super.dispose();
  }

  Future<void> _listengSMS() async {
    try {
      await SmsAutoFill().listenForCode;
      streamController = SmsAutoFill().code.listen((data) {
        bloc.textEditingController.text = data;
      }, onDone: () {}, onError: (error) {});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    dialCode = Localizations.localeOf(context).countryCode;
    final MediaQueryData data = MediaQuery.of(context);
    return BlocConsumer<PhoneAuthenticationBloc, PhoneAuthenticationState>(
      listener: (previous, current) async {
        if (current.error!) {
          Dialogs.alert(
            context,
            onPressed: () {
              context.read<PhoneAuthenticationBloc>().add(PhoneAuthCodeResetError());
              Navigator.pop(context);
              bloc.textEditingController.clear();
            },
            title: 'Código incorrecto',
            description: "Por favor Ingrese el código de confirmación correcto",
          );
        }
        if (current.errorCreate == true) {
          await Dialogs.alert(
            context,
            title: 'Algo salió mal',
            description: 'Inténtalo de nuevo más tarde',
            dismissible: false,
            okText: 'Ok',
            onPressed: () async {
              Navigator.pop(context);
              bloc.add(PhoneAuthError());
            },
          );
        }
      },
      builder: (context, state) {
        if (!state.verifiedNumber!) {
          return _phoneNumberSubmitWidget(context, data, state);
        } else {
          return _codeVerificationWidget(context, data, state);
        }
      },
    );
  }

  Widget _phoneNumberSubmitWidget(context, MediaQueryData data, PhoneAuthenticationState state) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              bottom: 30,
            ),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 30),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 8.0.h,
                          ),
                          Text(
                            S.of(context).welcomePhoneLogin,
                            style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                          ),
                          const SizedBox(
                            height: 54,
                          ),
                          Text(
                            S.of(context).messagePhoneLogin,
                            style: TextStyle(fontSize: 12.0.sp, color: const Color(0xff707070)),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<CountryRegister>(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(18.5, 16, 18.5, 16),
                                    labelText: '',
                                  ),
                                  value: _selectedDeparment,
                                  items: _dropdownMenuItems,
                                  onChanged: (departments) {},
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (value.length == 8) {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    }
                                  },
                                  obscureText: false,
                                  maxLength: 8,
                                  focusNode: number,
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText: 'Ej. 77123456', counterText: "", hintStyle: TextStyle(color: Color(0xff707070))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedButton(
                        loading: state.loading,
                        onPressed: () {
                          _verifyPhoneNumber(context);
                        },
                        label: 'Continuar',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: !state.loading!,
                        child: RoundedButton(
                          backgroundColor: const Color(0xffFAFAFA),
                          borderColor: const Color(0xffD9D9D9),
                          textColor: Colors.black,
                          onPressed: () {
                            userPreference.guestMode = true;
                            NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);

                          },
                          label: S.of(context).skip,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getOnlyPhoneNumber(String internationalizedPhoneNumber, String dialCode) {
    return internationalizedPhoneNumber.substring(dialCode.length);
  }

  onChangeDropdownItem(CountryRegister selectedDeparment, BuildContext context) {}
  Widget _codeVerificationWidget(BuildContext context, MediaQueryData data, PhoneAuthenticationState state) {
    final padding = data.padding;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - padding.top,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8.0.h,
              ),
              Text(
                S.of(context).messagePhoneSms,
                style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
              ),
              SizedBox(
                height: 8.0.h,
              ),
              Text(
                S.of(context).messagePhoneSmsBody,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16.0, color: Color(0xff707070), height: 1.5),
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Flexible(
                    child: Wrap(
                      children: [
                        Text(
                          '${_countryCodeController.text + " " + _phoneNumberController.text} ',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        GestureDetector(
                          child: Text(
                            '¿Número equivocado?',
                            style: GoogleFonts.montserrat(fontSize: 12.0.sp, color: primaryColor, fontWeight: FontWeight.w400),
                          ),
                          onTap: () {
                            NavigatorExtension.pushAndRemoveUntil(const LoginPhoneNumberView(), context);

                            // context.read<PhoneAuthenticationBloc>().add(PhoneAuthWrongNumber());
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: formKey,
                child: PinCodeTextField(
                  autoDisposeControllers: false,
                  appContext: context,
                  pastedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    locale: Locale('es', 'ES'),
                  ),
                  length: 6,
                  obscureText: false,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: false,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 5) {
                      return "completa tu código de 6 digitos";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(11),
                    fieldHeight: 56,
                    selectedColor: primaryColor,
                    inactiveColor: Colors.grey[350],
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.grey[350],
                    activeColor: primaryColor,
                    activeFillColor: hasError ? Colors.white : primaryColor,
                  ),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    locale: Locale('es', 'ES'),
                  ),
                  cursorColor: primaryColor,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: bloc.textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 5,
                    )
                  ],
                  onCompleted: (code) {
                    if (code.length == 6) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      BlocProvider.of<PhoneAuthenticationBloc>(context).add(PhoneDetectCode(smsCode: code));
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: state.completedTicker! && state.duration! >= 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Wrap(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'No me llega el código de verificación al celular ',
                                  style: TextStyle(fontSize: 12.0.sp, color: const Color(0xff707070), height: 1.5),
                                  children: [
                                    TextSpan(
                                      text: 'chatear con una operadora',
                                      style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          var message =
                                              "${greetingMessage()}, no me llega el código de verificación al celular ${_phoneNumberController.text}";
                                          var url = "whatsapp://send?phone=+59176699597&text=$message";
                                          launchInBrowser(url, context);
                                        },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const Center(child: TimerText()),
              const SizedBox(
                height: 30,
              ),
              RoundedButton(
                loading: state.loading,
                onPressed: () => _verifySMS(context),
                label: 'Continuar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    FocusScope.of(context).unfocus();

    FocusScope.of(context).requestFocus(FocusNode());
    if (!_validateNumber()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        padding: EdgeInsets.only(left: 0.0, right: 0.0),
        behavior: SnackBarBehavior.fixed,
        content: Padding(
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            child: Text(
              'Número celular inválido',
            )),
        duration: Duration(
          seconds: 2,
        ),
      ));
      return;
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      context: context,
      builder: (ctx) {
        return BlocProvider<PhoneAuthenticationBloc>.value(
          value: BlocProvider.of<PhoneAuthenticationBloc>(context),
          child: Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vamos a verificar el número de teléfono',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff242424),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                Text(
                  _countryCodeController.text + " " + _phoneNumberController.text,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff242424),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                Text(
                  '¿Deseas continuar o quieres modificarlo?',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff242424),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                        backgroundColor: const Color(0xffFAFAFA),
                        borderColor: const Color(0xffD9D9D9),
                        textColor: Colors.black,
                        // loading: state.formStatus is FormSubmitting ? true : false,
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).requestFocus(number);
                        },
                        label: 'Editar',
                      ),
                    ),
                    const SizedBox(
                      width: 19,
                    ),
                    Expanded(
                      child: RoundedButton(
                        // loading: state.formStatus is FormSubmitting ? true : false,
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<PhoneAuthenticationBloc>(context).add(
                            PhoneAuthLogin(
                              username: _countryCodeController.text + _phoneNumberController.text,
                            ),
                          );
                        },
                        label: 'Continuar',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _validateNumber() {
    if (_phoneNumberController.text.trim().length < 7 || _phoneNumberController.text.trim().length > 8) return false;
    if (_phoneNumberController.text[0] == '6' || _phoneNumberController.text[0] == '7') return true;
    return false;
  }

  void _verifySMS(BuildContext context) {
    BlocProvider.of<PhoneAuthenticationBloc>(context).add(PhoneAuthCodeVerified());

    // PhoneAuthLogin(password: )
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  void resendCode(BuildContext context) {
    BlocProvider.of<PhoneAuthenticationBloc>(context).add(
      ResendCode(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PhoneAuthenticationState state = context.watch<PhoneAuthenticationBloc>().state;
    // final minutesStr =
    //     ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (state.duration! % 60).floor().toString().padLeft(2, '0');
    if (state.completedTicker! && state.duration! >= 0) {
      return RoundedButton(
        onPressed: () {
          resendCode(context);
          // Navigator.push( context, MaterialPageRoute(builder: (context) => PageLanguage()), );
          // Navigator.pushNamed(context, 'theme');
          // Navigator.pushNamed(context, Routes.REGISTER);
        },
        label: 'Reenviar SMS',
        // label: S.of(context).task,
        textColor: primaryColor,
        fontSize: 12.0.sp,
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
      );
    } else if (state.completedTicker! && state.duration! < 0) {
      return Container();
    }
    return RichText(
      text:
          TextSpan(text: 'Reenviar SMS ', style: TextStyle(color: primaryColor, fontSize: 12.0.sp, fontWeight: FontWeight.w600), children: <TextSpan>[
        TextSpan(
          text: '(en $secondsStr seg.)',
          style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.normal),
        )
      ]),
    );
    // return Text(
    //   '$secondsStr',
    // );
  }
}
