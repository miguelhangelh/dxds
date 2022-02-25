import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
import 'package:appdriver/features/profile/presentation/pages/account/contract_profile_page.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/features/operation/presentation/bloc/operation_bloc.dart';
import 'package:appdriver/features/operation/presentation/pages/operation_page.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:appdriver/global_widgets/travels/widget_item_general_opportunity.dart';
class TravelPastPage extends StatefulWidget {
  static const String routeName = "travels_past";
  const TravelPastPage({Key? key}) : super(key: key);

  @override
  _TravelPastPageState createState() => _TravelPastPageState();
}

class _TravelPastPageState extends State<TravelPastPage> {
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  OperationBloc bloc = sl<OperationBloc>();
  UserPreference userPreference = UserPreference();
  @override
  void initState() {
    super.initState();
    bloc.add(GetTravelsPastEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: const CustomSubTitleWidget(
            text: 'Operaciones',
            color: Colors.black,
            size: 24, //13px
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SafeArea(child: BlocBuilder<OperationBloc, OperationState>(
          builder: (context, state) {
            var operation = userPreference.operation;

            if (state.loading!) {
              return Column(
                children: const [
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state.travelsPast != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  state.travelsPast!.futureTravel != null ? itemTravelFuture(state.travelsPast!.futureTravel!) : const SizedBox.shrink(),
                  state.travelsPast!.currentTravel != null ? itemTravelCurrentTravel(state.travelsPast!.currentTravel) : const SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomSubTitleWidget(
                      text: 'Operaciones pasadas (${state.travelsPast!.travelsPast!.length})',
                      color: const Color(0xFF707070),
                      size: 16, //13px
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      controller: bloc.refreshController,
                      onRefresh: () {
                        bloc.add(GetTravelsPastEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        itemCount: state.travelsPast!.travelsPast!.length,
                        itemBuilder: (BuildContext context, int index) {
                          travel.TravelModel travelItem = state.travelsPast!.travelsPast![index];
                          return itemTravel(travelItem);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            if (operation != null) {
              return itemTravelCurrentTravelOperation(operation);
            }
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
                  CustomSubTitleWidget(
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    text: 'No tienes operaciones en este momento',
                    color: Colors.black,
                    size: 16.0.sp,
                    //13px
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Text(
                      '(Reintentar)',
                      style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                    ),
                    onTap: () {
                      bloc.add(GetTravelsPastEvent());
                    },
                  )
                ],
              ),
            );
          },
        )),
      ),
    );
  }

  Widget itemTravelFuture(travel.TravelModel travelItem) {
    var timeNow = DateTime.now();
    var timelocal = travelItem.dates!.loadingDate!.toLocal();
    double inDays = timeNow.difference(timelocal).inHours / 24;
    var timeData = inDays.round();
    var colorsuccess = const Color(0xffD1EAD9);
    return GestureDetector(
      onTap: () async {
        var operation = userPreference.operation;
        if (operation == null) {
          await showModalBottomSheet(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 100,
                      color: const Color(0xffe2e8f0),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '¿Deseas iniciar tu operación?',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
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
                              Navigator.pop(context);
                            },
                            label: S.of(context).skip,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: RoundedButton(
                            onPressed: () {
                              analytics.logEvent(name: 'iniciar_operacion');
                              UserModel user = userPreference.getUser;
                              if (!user.signedContract) {
                                Navigator.pop(context);
                                NavigatorExtension.pushAndRemoveUntil(const ContractProfilePage(), context);
                              } else {
                                Navigator.pop(context);
                                NavigatorExtension.pushAndRemoveUntil(const OperationPage(), context);

                              }
                            },
                            label: 'Continuar',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // Navigator.pushNamed(context, OperationPage.routeName);
          NavigatorExtension.pushAndRemoveUntil(const OperationPage(), context);

        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colorsuccess,
            border: Border.all(color: colorsuccess),
          ),
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CustomSubTitleWidget(
                        text: 'Próxima operación',
                        color: Colors.black,
                        size: 16, //13px
                        fontWeight: FontWeight.w600,
                      ),
                      CustomSubTitleWidget(
                        text: 'En ${timeData.abs()} días',
                        color: const Color(0xff5D5D5D),
                        size: 12, //13px
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xff2DAA58),
                  ),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white, border: Border.all(color: colorsuccess)),
                child: WidgetItemGeneralOpportunity(travelItem: travelItem),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTravelCurrentTravel(travel.TravelModel? travelItem) {
    var colorsuccess = const Color(0xffD1EAD9);
    return GestureDetector(
      onTap: () {
        NavigatorExtension.pushAndRemoveUntil(const OperationPage(), context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colorsuccess,
            border: Border.all(color: colorsuccess),
          ),
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSubTitleWidget(
                    text: 'Operación en curso',
                    color: Colors.black,
                    size: 12.0.sp, //13px
                    fontWeight: FontWeight.w600,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xff2DAA58),
                  ),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white, border: Border.all(color: colorsuccess)),
                child: WidgetItemGeneralOpportunity(travelItem: travelItem),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTravelCurrentTravelOperation(op.Operation travelItem) {
    var colorsuccess = const Color(0xffD1EAD9);
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, OperationPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colorsuccess,
            border: Border.all(color: colorsuccess),
          ),
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSubTitleWidget(
                    text: 'Operación en curso',
                    color: Colors.black,
                    size: 12.0.sp, //13px
                    fontWeight: FontWeight.w600,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xff2DAA58),
                  ),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(color: colorsuccess),
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      const CustomSubTitleWidget(
                                        text: "Bs",
                                        size: 20,
                                        fontWeight: FontWeight.w600,
                                        margin: EdgeInsets.only(right: 5.0),
                                      ),
                                      CustomSubTitleWidget(
                                        text: travelItem.freightValues!.freightOffered!.value.toString(),
                                        size: 20,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CustomSubTitleWidget(
                                text: 'Valor de flete',
                                size: 8.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF707070),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.75,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                width: constraints.maxWidth * 0.5,
                                // color: Colors.red,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1.0,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              size: 11.0,
                                            ),
                                          ),
                                          Container(
                                            height: 6.5,
                                            width: 1.5,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                          ),
                                          Container(
                                            height: 6.5,
                                            width: 1.5,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                          ),
                                          Container(
                                            height: 6.5,
                                            width: 1.5,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                          ),
                                          Container(
                                            height: 6.5,
                                            width: 1.5,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                          ),
                                          Container(
                                            height: 6.5,
                                            width: 1.5,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 4.0,
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1.0,
                                                color: Colors.black,
                                              ),
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                              size: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 5.0,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomSubTitleWidget(
                                                  text: 'ORIGEN',
                                                  color: const Color(0xFF989898),
                                                  size: 8.0.sp, //13px
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                CustomSubTitleWidget(
                                                  text: travelItem.route!.origin!.cityOrigin, //'Santa Cruz'
                                                  color: const Color(0xFF000000),
                                                  size: 10.0.sp,
                                                  maxLines: 2,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                CustomSubTitleWidget(
                                                  text: outputFormat.format(travelItem.dates!.loadingDate!),
                                                  color: const Color(0xFF989898),
                                                  size: 8.0.sp, //13px
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomSubTitleWidget(
                                                  text: 'DESTINO',
                                                  color: const Color(0xFF989898),
                                                  size: 8.0.sp, //13px
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                CustomSubTitleWidget(
                                                  text: travelItem.route!.destination!.cityDestination, //'La Paz'
                                                  color: const Color(0xFF000000),
                                                  size: 10.0.sp,
                                                  maxLines: 2,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                CustomSubTitleWidget(
                                                  text: outputFormat.format(travelItem.dates!.deliveryDate!),
                                                  color: const Color(0xFF989898),
                                                  size: 8.0.sp, //13px
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: constraints.maxWidth * 0.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomSubTitleWidget(
                                            text: 'PESO',
                                            color: const Color(0xFF989898),
                                            size: 8.0.sp, //13px
                                            fontWeight: FontWeight.w600,
                                          ),
                                          CustomSubTitleWidget(
                                            text: '${travelItem.weightUnit!.value} ${travelItem.weightUnit!.abbreviation}.', //'Santa Cruz'
                                            color: const Color(0xFF000000),
                                            size: 10.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomSubTitleWidget(
                                            text: 'CATEGORÍA',
                                            color: const Color(0xFF989898),
                                            size: 8.0.sp, //13px
                                            fontWeight: FontWeight.w600,
                                          ),
                                          CustomSubTitleWidget(
                                            text: travelItem.categoryLoad!.name, //'Santa Cruz'
                                            color: const Color(0xFF000000),
                                            size: 10.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    );
                    //TODO: ACA ES EL OTRO ITEM DE OPERACION
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTravel(travel.TravelModel travelItem) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(
          color: const Color(0xffD9D9D9),
        ),
      ),
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
            height: 210,
            width: double.infinity,
            child: WidgetItemGeneralOpportunity(
              travelItem: travelItem,
            ),
          ),
          Visibility(
            visible: travelItem.rating != null,
            replacement: Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xffD9D9D9).withOpacity(0.3),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No tiene una calificación',
                    style: GoogleFonts.montserrat(
                      fontSize: 10.0.sp,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            child: Column(
              children: [
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffD9D9D9),
                ),
                SizedBox(
                  height: 100,
                  child: itemRating(context, travelItem),
                )
              ],
            ),
          )
          // GestureDetector(
          //   onTap: () async {
          //     await showModalBottomSheet(
          //       isScrollControlled: false,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
          //       ),
          //       context: context,
          //       builder: (BuildContext context) {
          //         return BlocProvider.value(
          //           value: bloc..add(GetRatingLoadingOrder(travel: travelItem)),
          //           child: Padding(
          //             padding: const EdgeInsets.only(top: 10.0, left: 0, right: 0, bottom: 0),
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Container(
          //                   height: 5,
          //                   width: 100,
          //                   color: const Color(0xffe2e8f0),
          //                 ),
          //                 SizedBox(
          //                   height: 20,
          //                 ),
          //                 CustomSubTitleWidget(
          //                   text: 'Calificación',
          //                   size: 14.0.sp,
          //                   padding: const EdgeInsets.only(left: 0.0),
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //                 BlocBuilder<OperationBloc, OperationState>(
          //                   builder: (context, state) {
          //                     if (state.loadingRating) {
          //                       return SizedBox(
          //                         height: 100,
          //                         child: Center(
          //                           child: CircularProgressIndicator(
          //                             backgroundColor: Colors.white,
          //                             valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
          //                           ),
          //                         ),
          //                       );
          //                     }
          //                     if (state.rating != null) {
          //                       return SizedBox(
          //                         height: 160,
          //                         child: itemRating(context, state.rating),
          //                       );
          //                     } else {
          //                       return SizedBox(
          //                         height: 100,
          //                         child: Center(
          //                           child: Text(
          //                             'No cuenta con calificación',
          //                             textAlign: TextAlign.left,
          //                             maxLines: 2,
          //                             style: GoogleFonts.montserrat(
          //                               fontSize: 10.0.sp,
          //                               color: Colors.black,
          //                               fontWeight: FontWeight.w400,
          //                             ),
          //                           ),
          //                         ),
          //                       );
          //                     }
          //                   },
          //                 )
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'Ver calificación',
          //       style: GoogleFonts.montserrat(
          //         fontSize: 10.0.sp,
          //         color: primaryColor,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Container itemRating(BuildContext context, travel.TravelModel travelItem) {
    return Container(
      // margin: const EdgeInsets.only(top: 30, bottom: 30),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: Offset(0, 2), // changes position of shadow
        //   ),
        // ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSubTitleWidget(
              padding: const EdgeInsets.only(left: 1),
              textAlign: TextAlign.right,
              text: 'DeltaX',
              color: Colors.black,
              size: 9.0.sp, //13px
              fontWeight: FontWeight.w500,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 15,
                    child: RatingBarIndicator(
                      rating: travelItem.rating?.value?.toDouble() ?? 0.0,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: primaryColor,
                      ),
                      itemCount: 5,
                      itemSize: 15.0,
                      unratedColor: primaryColor.withAlpha(70),
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 15,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomSubTitleWidget(
                        textAlign: TextAlign.right,
                        text: outputFormat.format(travelItem.rating?.account?.createDate?.toLocal() ?? DateTime.now())[0].toUpperCase() +
                            outputFormat.format(travelItem.rating?.account?.createDate?.toLocal() ?? DateTime.now()).substring(1),
                        color: const Color(0xFF989898),
                        size: 8.0.sp, //13px
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            CustomSubTitleWidget(
              padding: const EdgeInsets.only(left: 3),
              text: travelItem.rating?.commentary ?? "Sin comentarios",
              color: const Color(0xFF989898),
              maxLines: 3,
              size: 8.0.sp, //13px
              fontWeight: FontWeight.w400,
            )
          ],
        ),
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  FilterWidget({
    Key? key,
  }) : super(key: key);
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: double.infinity,
      height: 27,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              const Text(
                'Filtrar por: ',
                style: TextStyle(fontSize: 16, color: Color(0xff242424), fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 7,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 27, maxHeight: 27, minWidth: 70),
                child: TextButton(
                  style: TextButton.styleFrom(
                    side: const BorderSide(width: 1, color: Color(0xff242424)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    primary: Colors.blue,
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    // UserPreference userPreference = UserPreference();
                    // userPreference.setTravel = null;
                    //             userPreference.setTravelPostulation = null;
                    await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 1000)),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            brightness: Brightness.light,
                            colorScheme: const ColorScheme.light(
                              primary: primaryColor,
                            ),
                            cardColor: primaryColor,
                            highlightColor: primaryColor,
                            splashColor: primaryColor,
                            dialogBackgroundColor: Colors.blue[900],
                            primaryColor: primaryColor,
                            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                  },
                  child: Text(
                    'Fecha',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color(0xff242424),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 27, maxHeight: 27, minWidth: 95),
                child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: Color(0xff242424)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.red)),
                      primary: Colors.blue,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      backgroundColor: Colors.transparent),
                  onPressed: () {},
                  child: Text(
                    'Categoría ',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color(0xff242424),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 27, maxHeight: 27, minWidth: 100),
                child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: Color(0xff242424)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.red)),
                      primary: Colors.blue,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      backgroundColor: Colors.transparent),
                  onPressed: () async {},
                  child: Text(
                    'Más filtros',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color(0xff242424),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
