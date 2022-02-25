import 'package:appdriver/core/utils/font_styles.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/bloc/transport_unit/transport_unit_bloc.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_data_page.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/transport_type.dart';

class TransportUnitTypePage extends StatefulWidget {
  const TransportUnitTypePage({Key? key}) : super(key: key);

  @override
  _TransportUnitTypePageState createState() => _TransportUnitTypePageState();
}

class _TransportUnitTypePageState extends State<TransportUnitTypePage> {
  TransportUnitType? selected;
  TransportUnitBloc bloc = sl<TransportUnitBloc>();
  TextEditingController yearController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  bool lightTheme = true;
  Color currentColor = Colors.limeAccent;
  DateTime? selectDate;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];
  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) => setState(() => currentColors = colors);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  int? selectedIndex;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async {
    bloc.add(TransportUnitGetBrandsTypesEvent());
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  List<String> features = ["Not relevant", "Illegal", "Spam", "Offensive", "Uncivil"];
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: 'registro_tipo_unidad_transporte');
    bloc.stream.listen((state) {
      if (state.formStatus is SubmissionSuccess) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          NavigatorExtension.pushAndRemoveUntil(const TransportUnitDataPage(), context);
        });
      }
    });
  }

  truck(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('truck', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
          child: BlocProvider(
            create: (context) => bloc..add(TransportUnitGetBrandsTypesEvent()),
            child: BlocConsumer<TransportUnitBloc, TransportUnitState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.loading!) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Text(
                        'Selecciona que tipo de camión tienes',
                        style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Text(
                        'Selecciona que tipo de camión tienes',
                        style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: false,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 19),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemExtent: 90.0,
                            itemCount: state.transportUnitTypes!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selected != null) {
                                      selected!.selected = false;
                                    }
                                    state.transportUnitTypes![index].selected = !state.transportUnitTypes![index].selected!;
                                  });
                                  selected = state.transportUnitTypes![index];
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: state.transportUnitTypes![index].selected == false ? Colors.transparent : const Color(0xFFfdf2e6),
                                    border: Border.all(
                                      width: 1,
                                      color: state.transportUnitTypes![index].selected == false ? const Color.fromRGBO(0, 0, 0, 0.12) : primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth * 0.8,
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 14,
                                                ),
                                                const Icon(Icons.local_shipping_outlined),
                                                // imageWidget(state.transportUnitTypes[index].path),
                                                const SizedBox(
                                                  width: 14,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    state.transportUnitTypes![index].name!,
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.montserrat(
                                                        color: state.transportUnitTypes![index].selected == true
                                                            ? Colors.black
                                                            : const Color(0xFF707070),
                                                        fontSize: 12.0.sp,
                                                        fontWeight:
                                                            state.transportUnitTypes![index].selected == true ? FontWeight.w600 : FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth * 0.2,
                                            child: state.transportUnitTypes![index].selected!
                                                ? const Icon(
                                                    Icons.radio_button_checked,
                                                    color: primaryColor,
                                                  )
                                                : const Icon(
                                                    Icons.radio_button_off,
                                                    color: Colors.grey,
                                                  ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          BlocBuilder<TransportUnitBloc, TransportUnitState>(
                            builder: (context, state) {
                              return Visibility(
                                visible: state.formStatus is FormSubmitting ? false : true,
                                child: Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    child: RoundedButton(
                                      backgroundColor: const Color(0xffFAFAFA),
                                      borderColor: const Color(0xffD9D9D9),
                                      textColor: Colors.black,
                                      fontSize: 12.0.sp,
                                      // loading: state.formStatus is FormSubmitting ? true : false,
                                      onPressed: () {
                                        NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);

                                      },
                                      label: S.of(context).skip,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: RoundedButton(
                              loading: state.formStatus is FormSubmitting ? true : false,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                if (selected != null) {
                                  bloc.add(
                                    TransportUniTypeSubmit(type: selected!.name),
                                  );
                                  // bloc.add(TransportUnitTypeChangePage(typeChange: true));
                                } else {
                                  _showSnackBar(context, 'Selecciona un tipo de camión');
                                }
                              },
                              label: 'Continuar',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector imageWidget(String path) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 108,
          minHeight: 108,
          maxWidth: 108,
          maxHeight: 108,
        ),
        // child: ClipRRect(
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
        //    child: Image.asset(path, fit: BoxFit.cover),
        // ),
        //
        //
        child: CachedNetworkImage(
          imageUrl: path,
          imageBuilder: (context, imageProvider) => Container(
            width: 108,
            height: 108.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                    backgroundColor: Colors.white, strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(behavior: SnackBarBehavior.floating, content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
