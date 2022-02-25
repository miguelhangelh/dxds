import 'package:appdriver/core/utils/dialogs.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/extensions_methos_global/opportunity/opportunity_currency_methods.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/global_widgets/travels/widget_item_general_opportunity.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/core/utils/utils.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subcription_bloc_authentication.dart';
import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/custom_success.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:sizer/sizer.dart';
import 'package:appdriver/extensions_methos_global/opportunity/opportunity_item.dart';

class DetailOpportunityPage extends StatefulWidget {
  static const String routeName = 'detail_oportunity';
  final bool notification;
  final bool isDetailNotification;
  final travel.TravelModel? travelItem;
  final String? travelId;
  const DetailOpportunityPage({
    Key? key,
    this.travelItem,
    this.notification = false,
    this.isDetailNotification = false,
    this.travelId,
  }) : super(key: key);

  @override
  _DetailOpportunityPageState createState() => _DetailOpportunityPageState();
}

class _DetailOpportunityPageState extends State<DetailOpportunityPage> {
  late Responsive _responsive;
  UserPreference userPreference = UserPreference();
  OpportunityBloc bloc = sl<OpportunityBloc>();
  Map<PolylineId, Polyline> polylines = {};
  double valueData = 0.0;
  TextEditingController freightValueController = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late PolylinePoints polylinePoints;
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: 'detalle_de_oportunidad').then((value) => print('success'));
    bloc.add(OpportunityGetById(
      travel: widget.travelItem,
      travelId: widget.travelId ?? widget.travelItem!.id,
      isDetailNotification: widget.isDetailNotification,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state.formStatus is SubmissionFailed) {
            Dialogs.alert(context, title: 'Advertencia', description: state.messages);
          }
        },
        builder: (context, state) {
          if (state.loading!) {
            return Scaffold(
              appBar: AppBar(
                title: CustomSubTitleWidget(
                  text: 'Oportunidad',
                  color: Colors.black,
                  size: 18.0.sp, //13px
                  fontWeight: FontWeight.w600,
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SafeArea(
                child: Column(
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
                ),
              ),
            );
          }
          if (state.successPostulation!) {
            return Scaffold(
              body: SuccessPage(
                title: 'Postulación exitosa',
                description: 'Nos pondremos en contacto contigo.',
                buttonText: 'Continuar',
                onPressed: () {
                  bloc.add(OpportunityClosedSuccess());
                  NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
                },
              ),
            );
          }
          if (state.confirmPostulation!) {
            return Scaffold(
              body: SuccessPage(
                title: 'Postulación confirmada',
                description: 'Su postulación ha sido confirmada.',
                buttonText: 'Continuar',
                onPressed: () {
                  bloc.add(OpportunityClosedSuccess());
                  NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
                },
              ),
            );
          }
          if (state.cancelPostulation!) {
            return Scaffold(
              body: SuccessPage(
                title: 'Postulación cancelada',
                description: 'Su postulación ha sido cancelada',
                buttonText: 'Continuar',
                onPressed: () {
                  NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
                },
              ),
            );
          }
          if (state.travelItem != null) {
            return Scaffold(
              appBar: AppBar(
                title: CustomSubTitleWidget(
                  text: 'Oportunidad',
                  color: Colors.black,
                  size: 18.0.sp, //13px
                  fontWeight: FontWeight.w600,
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: _responsive.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildDetailOpportunity(state),
                          BlocConsumer<OpportunityBloc, OpportunityState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              if (state.loading!) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: const [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return buildOpportunityRoundTrip(context, state);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildOpportunityRoundTrip(BuildContext context, OpportunityState state) {
    return Visibility(
      visible: state.travelsRoundTrips!.isNotEmpty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomTitleWidget(
            title: 'Oportunidades de retorno',
            size: 12.0.sp,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 210,
                  child: RefreshIndicator(
                    backgroundColor: primaryColor,
                    color: Colors.white,
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 2));
                      context.read<OpportunityBloc>().add(GetTravelsRoundTrip());
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.travelsRoundTrips!.length,
                      itemBuilder: (BuildContext context, int index) {
                        travel.TravelModel travelItem = state.travelsRoundTrips![index];
                        return GestureDetector(
                          onTap: () {},
                          child: itemTravel(travelItem, state.travelsRoundTrips!.length),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Column buildDetailOpportunity(OpportunityState state) {
    var transportUnitId = userPreference.transportUnit;
    travel.Postulation? postulation;
    if (state.travelItem!.postulation != null) {
      if (state.travelItem!.postulation!.isNotEmpty) {
        postulation = state.travelItem!.postulation!.firstWhere((element) => element.transportUnitId == transportUnitId!.id);
      }
    }

    _responsive = Responsive(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pricesStateButtons(postulation, state.travelItem),
        Container(
          margin: EdgeInsets.only(bottom: _responsive.dp(1.5)),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 9, right: 9, top: 25, bottom: 13),
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(color: primaryColor),
                ),
                child: WidgetItemGeneralOpportunity(
                  travelItem: state.travelItem,
                  isDetail: true,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 100.0.w - 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 25,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              color: primaryColor),
                          child: Center(
                            child: CustomSubTitleWidget(
                              text: 'Por ${state.travelItem!.company?.name}',
                              color: Colors.white,
                              size: 10.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                child: _detailOperation(
                  title: 'DESCRIPCIÓN',
                  description: state.travelItem!.comment, //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: _responsive.dp(1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _detailOperation(
                  title: 'FECHA CARGUÍO',
                  prefix: Icon(
                    Icons.calendar_today_outlined,
                    size: 12.0.sp,
                    color: Colors.black,
                  ),
                  description: state.travelItem!.dates?.indefiniteDate == true
                      ? "Fecha abierta"
                      : outputFormat.format(state.travelItem!.dates!.loadingDate!)[0].toUpperCase() +
                          outputFormat
                              .format(state.travelItem!.dates!.loadingDate!)
                              .substring(1), //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                ),
              ),
              Expanded(
                child: Container(
                  child: _detailOperation(
                    title: 'FECHA DESCARGUÍO',
                    prefix: Icon(
                      Icons.calendar_today_outlined,
                      size: 12.0.sp, //16px
                      color: Colors.black,
                    ),
                    description: state.travelItem!.dates?.indefiniteDate == true
                        ? "Fecha abierta"
                        : outputFormat.format(state.travelItem!.dates!.deliveryDate!)[0].toUpperCase() +
                            outputFormat
                                .format(state.travelItem!.dates!.deliveryDate!)
                                .substring(1), //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: const Color(0xFFD9D9D9),
          margin: EdgeInsets.only(
            top: _responsive.dp(1.5),
          ),
          height: 1.5,
          width: _responsive.width,
        ),
        Container(
          width: _responsive.width,
          margin: EdgeInsets.only(
            top: _responsive.dp(1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: _detailOperation(
                      title: 'PESO', description: '${state.travelItem!.weightUnit!.value} ${state.travelItem!.weightUnit!.abbreviation}.' //'4.5 Tn',
                      ),
                ),
              ),
              Expanded(
                child: Container(
                  child: _detailOperation(
                    title: 'CATEGORÍA',
                    description: state.travelItem!.categoryLoad!.name, //'Accesorios de movilidades'
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: _responsive.width,
          margin: EdgeInsets.only(
            top: _responsive.dp(1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: _detailOperation(
                    title: 'TIPO DE TRANSPORTE',
                    description: state.travelItem!.typeTransportUnitLabel == null
                        ? 'Camión Abierto'
                        : state.travelItem!.typeTransportUnitLabel.toString(), //'Nissan Condor',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: _detailOperation(
                    title: 'CANTIDAD',
                    description: (state.travelItem!.quantityTransportUnit ?? 0) <= 1
                        ? '${state.travelItem!.quantityTransportUnit ?? 0} Camión'
                        : '${state.travelItem!.quantityTransportUnit ?? 0} Camiones',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: _responsive.width,
          margin: EdgeInsets.only(
            top: _responsive.dp(1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: _detailOperation(title: 'DISTANCIA APROX.', description: '${(state.travelItem!.distanceTravel!.name)}'),
                ),
              ),
              Expanded(
                child: Container(
                  child: _detailOperation(
                      title: 'FACTURADO', description: (state.travelItem!.freightValues!.freightOffered!.invoice ?? false) ? 'Sí' : 'No'),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: state.travelItem!.features!.isNotEmpty,
          child: Container(
            color: const Color(0xFFD9D9D9),
            margin: EdgeInsets.only(
              top: _responsive.dp(1.5),
            ),
            height: 1.5,
            width: _responsive.width,
          ),
        ),
        Visibility(
          visible: state.travelItem!.features!.isNotEmpty,
          child: Container(
            margin: EdgeInsets.only(
              top: _responsive.dp(1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomSubTitleWidget(
                  text: 'tu unidad de transporte no cumple con las características requeridas para esta oportunidad'.toUpperCase(),
                  color: const Color(0xFF989898),
                  size: 12, //13px
                  fontWeight: FontWeight.w600,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 19,
                    ),
                    Visibility(
                      visible: state.travelItem!.features!.isNotEmpty,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: state.travelItem!.features!
                              .map((item) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      // border: Border.all(
                                      //   color: Colors.black,
                                      //   width: 0.5
                                      // ),
                                      // color: warningColor,
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: RichText(
                                        text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${item.name} : ',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                        ),
                                        TextSpan(
                                            text: item.valueQuantitative != null ? item.valueQuantitative.toString() : item.valueQualitative,
                                            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
                                      ],
                                    )),
                                  ))
                              .toList()
                              .cast<Widget>(),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        buttonsPostulations(postulation),
      ],
    );
  }

  Widget itemTravel(travel.TravelModel travelItem, int length) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 9, right: 9, top: 25, bottom: 13),
            height: 210,
            width: length <= 1 ? MediaQuery.of(context).size.width - 40 : MediaQuery.of(context).size.width * 0.80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              border: Border.all(color: primaryColor),
            ),
            child: WidgetItemGeneralOpportunity(
              travelItem: travelItem,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: 100.0.w - 40,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 25,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        color: primaryColor,
                      ),
                      child: Center(
                        child: CustomSubTitleWidget(
                          text: 'Por ${travelItem.company?.name}',
                          color: Colors.white,
                          size: 10.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          const Positioned(
            right: 5,
            top: 10,
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _detailOperation({String title = '', String? description = '', Widget? prefix}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomSubTitleWidget(
          text: title,
          color: const Color(0xFF989898),
          size: 8.0.sp, //13px
          fontWeight: FontWeight.w600,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (prefix == null) ? Container() : prefix,
            (prefix == null) ? Container() : const SizedBox(width: 5),
            Expanded(
              child: CustomSubTitleWidget(
                text: description,
                color: const Color(0xFF000000),
                size: 10.0.sp, //18px
                fontWeight: FontWeight.w400,
                margin: const EdgeInsets.only(
                  top: 3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buttonsPostulations(travel.Postulation? postulation) {
    ///CONFIRMAR POSTULACION
    if (postulation?.postulateDate != null && postulation?.acceptedDate != null && postulation?.confirmedDate == null) {
      return BlocBuilder<OpportunityBloc, OpportunityState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.only(
              top: _responsive.dp(2.5),
            ),
            child: Column(
              children: [
                RoundedButton(
                  loading: state.formStatus is FormSubmitting ? true : false,
                  // loading: state.formStatus is FormSubmitting ? true : false,
                  onPressed: () {
                    PostulationRequest postulationRequest = PostulationRequest();
                    postulationRequest.postulation = Postulation(
                      acceptedDate: postulation!.acceptedDate,
                      cancelledDate: postulation.confirmedDate,
                      confirmedDate: postulation.confirmedDate,
                      freightValue: postulation.freightValue,
                      id: postulation.id,
                      invoice: postulation.invoice,
                      postulateDate: postulation.postulateDate,
                      travelId: postulation.travelId,
                      typeCurrencyFreightId: postulation.typeCurrencyFreightId,
                    );

                    context.read<OpportunityBloc>().add(OpportunityPostulationConfirm(postulationRequest: postulationRequest));
                  },
                  label: 'Confirmar',
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  loading: state.formStatusCancelled is FormSubmitting ? true : false,
                  backgroundColor: const Color(0xffFAFAFA),
                  borderColor: const Color(0xffD9D9D9),
                  textColor: Colors.black,
                  // loading: state.formStatus is FormSubmitting ? true : false,
                  onPressed: () {
                    PostulationRequest postulationRequest = PostulationRequest();
                    postulationRequest.postulation = Postulation(
                      acceptedDate: postulation!.acceptedDate,
                      cancelledDate: postulation.confirmedDate,
                      confirmedDate: postulation.confirmedDate,
                      freightValue: postulation.freightValue,
                      id: postulation.id,
                      invoice: postulation.invoice,
                      postulateDate: postulation.postulateDate,
                      travelId: postulation.travelId,
                      typeCurrencyFreightId: postulation.typeCurrencyFreightId,
                    );

                    context.read<OpportunityBloc>().add(OpportunityPostulationCancelled(postulationRequest: postulationRequest));
                  },
                  label: 'Cancelar',
                ),
              ],
            ),
          );
        },
      );
    }

    if (postulation?.postulateDate == null && postulation?.acceptedDate == null && postulation?.confirmedDate == null) {
      return BlocBuilder<OpportunityBloc, OpportunityState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.only(
              top: _responsive.dp(2.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    loading: state.formStatus is FormSubmitting ? true : false,
                    // loading: state.formStatus is FormSubmitting ? true : false,
                    onPressed: () async {
                      analytics.logEvent(
                        name: 'postular_oportunidad',
                      );
                      TypeRegister type = await checkUserPostulation();
                      if (type == TypeRegister.login) {
                        await showModalBottomSheetLogin(context);
                      } else if (type == TypeRegister.profileRegister) {
                        await showModalBottomSheetProfileRegister(context);
                        return;
                      } else if (type == TypeRegister.transportUnitType) {
                        await showModalBottomSheetTransportUnitType(context);
                      } else if (type == TypeRegister.transportUnitData) {
                        await showModalBottomSheetTransportUnitData(context);
                      } else {
                        if (state.travelItem!.freightValues!.freightOffered!.value != null) {
                          freightValueController.text = state.travelItem!.freightValues!.freightOffered!.value.toString();
                          await showModalBottomSheetPostulation(context, state.travelItem!);
                          if (valueData > state.travelItem!.freightValues!.freightOffered!.value!) {
                            valueData = 0;
                          }
                        } else {
                          await showModalBottomSheetPostulationNot(context, state.travelItem!);
                        }
                      }
                    },
                    label: 'Postular',
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    ///CANCELAR
    if (postulation?.postulateDate != null &&
        postulation?.acceptedDate == null &&
        postulation?.confirmedDate == null &&
        postulation?.rejectDate == null &&
        postulation?.cancelledDate == null) {
      return BlocBuilder<OpportunityBloc, OpportunityState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.only(
              top: _responsive.dp(2.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    loading: state.formStatusCancelled is FormSubmitting ? true : false,
                    // loading: state.formStatus is FormSubmitting ? true : false,
                    backgroundColor: const Color(0xffFAFAFA),
                    borderColor: const Color(0xffD9D9D9),
                    textColor: Colors.black,
                    onPressed: () {
                      PostulationRequest postulationRequest = PostulationRequest();
                      postulationRequest.postulation = Postulation(
                        acceptedDate: postulation!.acceptedDate,
                        cancelledDate: postulation.confirmedDate,
                        confirmedDate: postulation.confirmedDate,
                        freightValue: postulation.freightValue,
                        id: postulation.id,
                        invoice: postulation.invoice,
                        postulateDate: postulation.postulateDate,
                        travelId: postulation.travelId,
                        typeCurrencyFreightId: postulation.typeCurrencyFreightId,
                      );
                      context.read<OpportunityBloc>().add(OpportunityPostulationCancelled(postulationRequest: postulationRequest));
                    },
                    label: 'Cancelar',
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (postulation?.postulateDate != null &&
        postulation?.acceptedDate == null &&
        postulation?.confirmedDate == null &&
        postulation?.rejectDate == null &&
        postulation?.cancelledDate != null) {
      return BlocBuilder<OpportunityBloc, OpportunityState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.only(
              top: _responsive.dp(2.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    loading: state.formStatus is FormSubmitting ? true : false,
                    onPressed: () {
                      PostulationRequest postulationRequest = PostulationRequest();
                      postulationRequest.postulation = Postulation(
                        acceptedDate: postulation!.acceptedDate,
                        cancelledDate: postulation.confirmedDate,
                        confirmedDate: postulation.confirmedDate,
                        freightValue: postulation.freightValue,
                        id: postulation.id,
                        invoice: postulation.invoice,
                        postulateDate: postulation.postulateDate,
                        travelId: postulation.travelId,
                        typeCurrencyFreightId: postulation.typeCurrencyFreightId,
                      );
                      context.read<OpportunityBloc>().add(OpportunityPostulationAdd(postulationRequest: postulationRequest));
                    },
                    label: 'postular cancelada',
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Future showModalBottomSheetPostulation(BuildContext context, travel.TravelModel travelItem) {
    var freightOffered = travelItem.freightValues!.freightOffered;
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 100,
                      color: const Color(0xffababab),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Postular a oportunidad',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff242424),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: valueData > freightOffered!.value!,
                      child: Column(
                        children: [
                          Text(
                            'No puedes ofertar arriba de ${freightOffered.value.toString()} ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'modifica tu oferta',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: freightValueController,
                      decoration: InputDecoration(labelText: 'Oferta tu precio en ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            valueData = double.parse(value);
                          });
                        } else {
                          setState(() {
                            valueData = 0;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    Column(
                      children: [
                        RoundedButton(
                          borderColor: Colors.transparent,
                          onPressed: valueData <= freightOffered.value!
                              ? () {
                                  var freightOffered = travelItem.freightValues?.freightOffered;
                                  if (freightOffered != null) {
                                    Navigator.of(context).pop();
                                    PostulationRequest postulationRequest = PostulationRequest();
                                    Postulation postulation = postulationRequest.postulation = Postulation();
                                    postulation.typeCurrencyFreightId = freightOffered.typeCurrencyOfferedId;
                                    postulation.travelId = travelItem.id;
                                    postulation.invoice = freightOffered.invoice;
                                    if (freightOffered.typeUnitMeasurement == null) {
                                      postulation.abbreviationTypeCurrency = freightOffered.abbreviationTypeCurrency;
                                    } else {
                                      postulation.abbreviationUnit = freightOffered.abbreviationUnit;
                                      postulation.typeMeasurementUnit = freightOffered.typeMeasurementUnit;
                                      postulation.abbreviationTypeCurrency = freightOffered.abbreviationTypeCurrency;
                                      postulation.typeUnitMeasurement = freightOffered.typeUnitMeasurement;
                                    }
                                    if (valueData > 0) {
                                      postulation.freightValue = valueData;
                                      bloc.add(OpportunityPostulationAdd(postulationRequest: postulationRequest));
                                    } else {
                                      postulation.freightValue = freightOffered.value;
                                      bloc.add(OpportunityPostulationAdd(postulationRequest: postulationRequest));
                                    }
                                  }
                                }
                              : null,
                          label: getTextOffered(freightOffered, valueData, travelItem),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            RoundedButton(
                              backgroundColor: const Color(0xffFAFAFA),
                              borderColor: const Color(0xffD9D9D9),
                              textColor: Colors.black,
                              // loading: state.formStatus is FormSubmitting ? true : false,
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  valueData = 0;
                                });
                              },
                              label: 'Cancelar',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future showModalBottomSheetPostulationNot(BuildContext context, travel.TravelModel travelItem) {
    var freightOffered = travelItem.freightValues!.freightOffered;
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    width: 100,
                    color: const Color(0xffababab),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Postular a oportunidad',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff242424),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Column(
                    children: [
                      RoundedButton(
                        borderColor: Colors.transparent,
                        onPressed: () {
                          Navigator.of(context).pop();
                          PostulationRequest postulationRequest = PostulationRequest();
                          var freightOffered = travelItem.freightValues?.freightOffered;
                          if (freightOffered != null) {
                            PostulationRequest postulationRequest = PostulationRequest();
                            Postulation postulation = postulationRequest.postulation = Postulation();
                            postulation.typeCurrencyFreightId = freightOffered.typeCurrencyOfferedId;
                            postulation.travelId = travelItem.id;
                            postulation.invoice = freightOffered.invoice;
                            if (freightOffered.typeUnitMeasurement == null) {
                              postulation.abbreviationTypeCurrency = freightOffered.abbreviationTypeCurrency;
                            } else {
                              postulation.abbreviationUnit = freightOffered.abbreviationUnit;
                              postulation.typeMeasurementUnit = freightOffered.typeMeasurementUnit;
                              postulation.abbreviationTypeCurrency = freightOffered.abbreviationTypeCurrency;
                              postulation.typeUnitMeasurement = freightOffered.typeUnitMeasurement;
                            }
                            bloc.add(OpportunityPostulationAdd(postulationRequest: postulationRequest));
                          }
                        },
                        label: "Postular",
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          RoundedButton(
                            backgroundColor: const Color(0xffFAFAFA),
                            borderColor: const Color(0xffD9D9D9),
                            textColor: Colors.black,
                            // loading: state.formStatus is FormSubmitting ? true : false,
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                valueData = 0;
                              });
                            },
                            label: 'Cancelar',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future showModalBottomSheetLogin(BuildContext context) {
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
                'No puedes postular a esta oportunidad ¿deseas registrarte?',
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
                      // loading: state.formStatus is FormSubmitting ? true : false,
                      onPressed: () {
                        Navigator.of(context).pop();
                        AuthenticationSubcriptions.instance.streamAdd = TypeRegister.login;
                      },
                      label: 'Si, registrarme',
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

  Future showModalBottomSheetTransportUnitFeatures(BuildContext context) {
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
                'No tienes características de tu unidad de transporte ¿deseas completarlo?',
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
                        AuthenticationSubcriptions.instance.streamAdd = TypeRegister.transportUnitFeatures;
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

  Widget pricesStateButtons(travel.Postulation? postulation, travel.TravelModel? travelItem) {
    double value = 0;
    double valueOperator = 0;
    if (postulation?.freightValue != null) {
      value = postulation!.freightValue!;
    }
    if (postulation?.freightValueOperator != null) {
      valueOperator = postulation!.freightValueOperator!;
    }
    if (postulation?.postulateDate != null && postulation?.acceptedDate != null && postulation?.confirmedDate == null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xffd1eada),
          border: Border.all(color: const Color(0xffd1eada)),
        ),
        margin: EdgeInsets.only(
          bottom: _responsive.dp(1.5),
        ),
        padding: const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.black),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubTitleWidget(
                    text: 'Postulación aprobada',
                    size: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: value > 0 || valueOperator > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSubTitleWidget(
                              text: userPreference.getUser.profile?.firstName ?? "",
                              color: Colors.black,
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w500,
                            ),
                            CustomSubTitleWidget(
                              text: valueOperator > 0 ? 'Monto por:' : 'Postulaste por:',
                              color: Colors.black,
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: value > 0 || valueOperator > 0,
                        child: Row(
                          children: [
                            CustomSubTitleWidget(
                              text: getTextPostulation(postulation!, travelItem!),
                              color: Colors.black,
                              size: 16.0.sp, //13px
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
    if (postulation?.postulateDate != null && postulation?.acceptedDate != null && postulation?.confirmedDate != null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: successColor.withOpacity(0.08),
          border: Border.all(color: successColor.withOpacity(0.08)),
        ),
        margin: EdgeInsets.only(
          bottom: _responsive.dp(1.5),
        ),
        padding: const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.black),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubTitleWidget(
                    text: 'Postulación confirmada',
                    size: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: value > 0 || valueOperator > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSubTitleWidget(
                              text: userPreference.getUser.profile?.firstName ?? "",
                              color: Colors.black,
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w500,
                            ),
                            CustomSubTitleWidget(
                              text: valueOperator > 0 ? 'Monto por:' : 'Postulaste por:',
                              color: Colors.black,
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: value > 0 || valueOperator > 0,
                        child: Row(
                          children: [
                            CustomSubTitleWidget(
                              text: getTextPostulation(postulation!, travelItem!),
                              color: Colors.black,
                              size: 16.0.sp, //13px
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomSubTitleWidget(
                              text: OpportunityCurrencyExtension.titleCurrency(false, travelItem),
                              color: Colors.black,
                              size: 12.0.sp, //13px
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else if (postulation?.postulateDate == null &&
        postulation?.acceptedDate == null &&
        postulation?.confirmedDate == null &&
        postulation?.rejectDate == null &&
        postulation?.cancelledDate == null) {
      return Container();
    } else if (postulation?.postulateDate != null &&
        postulation?.acceptedDate == null &&
        postulation?.confirmedDate == null &&
        postulation?.rejectDate == null &&
        postulation?.cancelledDate == null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: warningColor.withOpacity(0.08),
          border: Border.all(color: warningColor.withOpacity(0.08)),
        ),
        margin: EdgeInsets.only(
          bottom: _responsive.dp(1.5),
        ),
        padding: const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.black),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubTitleWidget(
                    text: 'Postulación en revisión',
                    size: 11.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: value > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSubTitleWidget(
                              text: userPreference.getUser.profile?.firstName ?? "",
                              color: Colors.black,
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w500,
                            ),
                            CustomSubTitleWidget(
                              text: 'Postulaste por:',
                              color: Colors.black,
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: value > 0,
                        child: Row(
                          children: [
                            CustomSubTitleWidget(
                              text: postulation!.freightValue.toString(),
                              color: Colors.black,
                              size: 14.0.sp, //13px
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomSubTitleWidget(
                              text: OpportunityCurrencyExtension.titleCurrency(false, travelItem!),
                              color: Colors.black,
                              size: 12.0.sp, //13px
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else if (postulation?.postulateDate != null &&
        postulation?.acceptedDate == null &&
        postulation?.confirmedDate == null &&
        postulation?.rejectDate == null &&
        postulation?.cancelledDate != null) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2DAA58)),
          CustomSubTitleWidget(
            text: 'Postulación cancelada',
            size: 12.0.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  String getTextPostulation(travel.Postulation postulation, travel.TravelModel travelItem) {
    double value = 0;
    double valueOperator = 0;
    if (postulation.freightValue != null) {
      value = postulation.freightValue!;
    }

    if (postulation.freightValueOperator != null) {
      valueOperator = postulation.freightValueOperator!;
    }
    if (valueOperator > 0) {
      if (postulation.typeUnitMeasurementOperator == null) {
        return '$valueOperator ${postulation.abbreviationTypeCurrencyOperator}';
      }
      return '$valueOperator ${postulation.abbreviationTypeCurrencyOperator}/${postulation.abbreviationUnitOperator}';
    }
    return '$value ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}';
  }
}

String getTextOffered(travel.FreightOffered? freightOffered, double valueData, travel.TravelModel travelItem) {
  if (valueData > 0 && valueData <= freightOffered!.value!) {
    return "Aceptar por $valueData ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}";
  } else if (valueData > 0 && valueData > freightOffered!.value!) {
    return "Aceptar por ${freightOffered.value} ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}";
  } else {
    return "Aceptar por ${freightOffered!.value} ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}";
  }
}
