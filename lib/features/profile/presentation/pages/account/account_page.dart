import 'package:amplify_flutter/amplify.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subcription_bloc_authentication.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/profile/presentation/pages/account/contract_profile_page.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/phone_authentication_aws/presentation/pages/login_phone_number_view_1.dart';
import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:appdriver/features/profile/presentation/pages/account/profile_edit_page.dart';
import 'package:appdriver/features/profile/presentation/pages/account/transport_unit_edit_page.dart';
import 'package:appdriver/features/profile/presentation/pages/account/rating_account.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';

class HomeMainView extends StatefulWidget {
  static const routeName = 'home';

  const HomeMainView({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeMainView());
  }

  @override
  _HomeMainViewState createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> with WidgetsBindingObserver {
  bool? profile;
  bool? truck;
  final ProfileBloc bloc = sl<ProfileBloc>();
  final outputFormat = DateFormat('EEEE d, de MMMM', 'es_ES');

  @override
  void initState() {
    super.initState();
    bloc.add(ProfileGetUser());
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: CustomSubTitleWidget(
            text: 'Mi cuenta',
            color: Colors.black,
            size: 18.sp, //13px
            fontWeight: FontWeight.w600,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              size: 37,
              color: Colors.black,
            ),
            onPressed: () {
              NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
            },
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            int advancePercentageUser = 0;
            int advancePercentageTransport = 0;
            if (state.transportUnit != null) {
              advancePercentageTransport = (state.transportUnit!.advancePercentage! * 100).round();
            }
            if (state.user != null) {
              advancePercentageUser = (state.user!.advancePercentage! * 100).round();
            }
            if (state.loading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                ],
              );
            }
            if (state.user != null) {
              return SmartRefresher(
                enablePullDown: true,
                footer: ClassicFooter(
                  textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
                  noDataText: 'No hay más datos disponibles',
                  idleText: 'Desliza hacia arriba carga más',
                  canLoadingText: 'Suelte para cargar más',
                  loadingText: "Cargando...",
                ),
                enablePullUp: false,
                controller: bloc.refreshController,
                onRefresh: bloc.onRefresh,
                onLoading: bloc.onLoading,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: (state.user!.profile!.pathPhoto != null && state.user!.profile!.pathPhoto!.isNotEmpty),
                              replacement: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  image: const DecorationImage(
                                    image: ExactAssetImage('assets/user.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: photoHasToken(state.user?.profile?.pathPhoto ?? ""),
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFD9D9D9),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 0), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(11),
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFD9D9D9),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    image: const DecorationImage(
                                      image: ExactAssetImage('assets/user.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Miembro desde el ${DateFormat.yMMMMd('es_ES').format(state.user!.account!.createDate!)}',
                                  style: TextStyle(fontSize: 7.0.sp, color: const Color(0xff707070), fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${state.user!.profile?.firstName ?? "Invitado"} ${state.user!.profile?.lastName ?? ""}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14.0.sp, color: Colors.black, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: primaryColor,
                                      size: 13,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      userPreference.getUser.ratingPercentage ?? "0.0",
                                      style: TextStyle(fontSize: 8.0.sp, color: Colors.black, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Configuración',
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0.sp,
                          color: const Color(0xff707070),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundedButton(
                        height: 56,
                        onPressed: () async {
                          TypeRegister type = await checkUserPostulation();
                          if (type == TypeRegister.profileRegister) {
                            await showModalBottomSheetProfileRegister(context);
                            return;
                          } else if (type == TypeRegister.transportUnitType) {
                            await showModalBottomSheetTransportUnitType(context);
                          } else if (type == TypeRegister.transportUnitData) {
                            await showModalBottomSheetTransportUnitData(context);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute<ProfileEditPageView>(
                                builder: (_) => const ProfileEditPageView(),
                              ),
                            );
                          }
                        },
                        label: 'Datos Personales ',
                        label2: '(Al $advancePercentageUser%)',
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderColor: const Color(0xffD9D9D9),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundedButton(
                        height: 56,
                        onPressed: () async {
                          TypeRegister type = await checkUserPostulation();
                          if (type == TypeRegister.profileRegister) {
                            await showModalBottomSheetProfileRegister(context);
                            return;
                          } else if (type == TypeRegister.transportUnitType) {
                            await showModalBottomSheetTransportUnitType(context);
                          } else if (type == TypeRegister.transportUnitData) {
                            await showModalBottomSheetTransportUnitData(context);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute<ProfileEditPageView>(
                                builder: (_) => const TruckEditPageView(),
                              ),
                            );
                          }
                        },
                        label: 'Mi unidad ',
                        label2: '(Al $advancePercentageTransport%)',
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderColor: const Color(0xffD9D9D9),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundedButton(
                        height: 56,
                        onPressed: () async {
                          TypeRegister type = await checkUserPostulation();
                          if (type == TypeRegister.profileRegister) {
                            await showModalBottomSheetProfileRegister(context);
                            return;
                          } else if (type == TypeRegister.transportUnitType) {
                            await showModalBottomSheetTransportUnitType(context);
                          } else if (type == TypeRegister.transportUnitData) {
                            await showModalBottomSheetTransportUnitData(context);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute<ProfileEditPageView>(
                                builder: (_) => const RatingAccountPage(),
                              ),
                            );
                          }
                        },
                        label: 'Mis calificaciones ',
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderColor: const Color(0xffD9D9D9),
                      ),
                      // RoundedButton(
                      //   height: 56,
                      //   onPressed: () async {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute<ProfileEditPageView>(
                      //         builder: (_) => const ContractProfilePage(),
                      //       ),
                      //     );
                      //   },
                      //   label: 'Ver contrato',
                      //   textColor: Colors.black,
                      //   backgroundColor: Colors.transparent,
                      //   borderColor: const Color(0xffD9D9D9),
                      // ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: primaryColor,
                      size: 50,
                    ),
                    const CustomSubTitleWidget(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      text: 'No te encuentras registrado ¿deseas registrarte?',
                      color: Colors.black,
                      size: 20, //13px
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Text(
                        '(Registrarme)',
                        style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                      ),
                      onTap: () async {
                        NavigatorExtension.pushAndRemoveUntil(const LoginPhoneNumberView(), context);
                      },
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  const Statistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD9D9D9), width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ESTE MES',
                    style: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.w600, color: const Color(0xff5D5D5D)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, color: Color(0xff6dc78a)),
                      const SizedBox(
                        width: 14,
                      ),
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'BS.',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            TextSpan(text: '0', style: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD9D9D9), width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HISTÓRICO',
                    style: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.w600, color: const Color(0xff5D5D5D)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.trending_up_outlined, color: primaryColor),
                      const SizedBox(
                        width: 14,
                      ),
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'BS.',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            TextSpan(text: '0', style: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future showModalBottomSheetProfileRegister(BuildContext context) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tus datos personales están incompletos ¿deseas completarlo?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
                    },
                    label: S.of(context).skip,
                  ),
                ),
                const SizedBox(
                  width: 19,
                ),
                Expanded(
                  child: RoundedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      AuthenticationSubcriptions.instance.streamAdd = TypeRegister.profileRegister;
                    },
                    label: 'Si, completar',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future showModalBottomSheetTransportUnitType(BuildContext context) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No tienes un tipo de unidad de transporte ¿deseas completarlo?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
                    },
                    label: S.of(context).skip,
                  ),
                ),
                const SizedBox(
                  width: 19,
                ),
                Expanded(
                  child: RoundedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitType;
                    },
                    label: 'Si, completar',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future showModalBottomSheetTransportUnitData(BuildContext context) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tus datos de tu unidad de transporte están incompletos ¿deseas completarlo?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
                    },
                    label: S.of(context).skip,
                  ),
                ),
                const SizedBox(
                  width: 19,
                ),
                Expanded(
                  child: RoundedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitData;
                    },
                    label: 'Si, completar',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
