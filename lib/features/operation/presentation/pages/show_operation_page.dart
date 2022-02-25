import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:appdriver/extensions_methos_global/opportunity/opportunity_currency_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/utils/utils.dart';
import 'package:appdriver/features/operation/presentation/bloc/operation_bloc.dart';
import 'package:appdriver/features/operation/presentation/pages/stylemap.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:sizer/sizer.dart';

class ShowOperationPage extends StatefulWidget {
  static const String routeName = 'show_operation';

  const ShowOperationPage({Key? key}) : super(key: key);

  @override
  _ShowOperationPageState createState() => _ShowOperationPageState();
}

class _ShowOperationPageState extends State<ShowOperationPage> {
  late Responsive _responsive;
  late OperationState operationState;
  Map<PolylineId, Polyline> polylines = {};
  bool initMap = false;

  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIcon1;
  Completer<GoogleMapController> _completer = Completer();
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  double cameraZoom = 12;
  double cameraTilt = 80;
  double cameraBearing = 30;
  LatLng sourceLocation = const LatLng(-17.794245457944005, -63.186950719603765);
  @override
  Widget build(BuildContext context) {
    _responsive = Responsive.of(context);
    operationState = ModalRoute.of(context)!.settings.arguments as OperationState;
    CameraPosition kGooglePlex = CameraPosition(
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing,
      target: sourceLocation,
    );
    if (operationState.myLocation != null) {
      kGooglePlex = CameraPosition(
        target: LatLng(operationState.myLocation!.lat!, operationState.myLocation!.lng!),
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
      );
    }
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: operationState.polylines,
      width: 4,
    );
    polylines[id] = polyline;
    return Scaffold(
      appBar: AppBar(
        title: CustomSubTitleWidget(
          text: 'Detalle de operación',
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: _responsive.width,
          height: _responsive.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: SizedBox(
              width: _responsive.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: _responsive.width,
                    height: 300,
                    child: GoogleMap(
                      markers: operationState.markers!.values.toSet(),
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
                        ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()))
                        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
                      polylines: Set<Polyline>.of(polylines.values),
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) async {
                        if (_completer.isCompleted) {
                          _completer = Completer();
                        }
                        // firstInitMaps= false;
                        controller.setMapStyle(jsonEncode(styleMaps));
                        _completer.complete(controller);
                        WidgetsBinding.instance!.addPostFrameCallback(
                          (_) {
                            List<double> lngs1 = [];
                            List<double> lats1 = [];
                            operationState.markers!.forEach((key, value) {
                              lngs1.add(value.position.longitude);
                            });
                            operationState.markers!.forEach((key, value) {
                              lats1.add(value.position.latitude);
                            });
                            double topMost = lngs1.reduce(max);
                            double leftMost = lats1.reduce(min);
                            double rightMost = lats1.reduce(max);
                            double bottomMost = lngs1.reduce(min);

                            LatLngBounds bounds = LatLngBounds(
                              northeast: LatLng(rightMost, topMost),
                              southwest: LatLng(leftMost, bottomMost),
                            );
                            controller.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                bounds,
                                100,
                              ),
                            );
                            controller.showMarkerInfoWindow(const MarkerId('origin_marker'));
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    width: _responsive.width,
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      children: <Widget>[
                        CustomSubTitleWidget(
                          text: OpportunityCurrencyExtension.titleCurrencyOperation(operationState.operation!),

                          ///TODO:AQUI HAY QUE CAMBIAR BS
                          size: 16.0.sp,
                          fontWeight: FontWeight.w600,
                          margin: const EdgeInsets.only(right: 5.0),
                          padding: const EdgeInsets.only(
                            left: 20.0,
                          ),
                        ),
                        CustomSubTitleWidget(
                          text: OpportunityCurrencyExtension.titlePriceCurrencyOperation(operationState.operation!),
                          size: 16.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  CustomSubTitleWidget(
                    text: 'Valor de flete',
                    size: 8.0.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF707070),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: _responsive.width! - 25,
                          height: 100.0,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.0,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: const Icon(Icons.location_on, size: 14.0),
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
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.0,
                                          color: Colors.black,
                                        ),
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: const Icon(Icons.location_on, color: Colors.white, size: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomSubTitleWidget(
                                            text: 'ORIGEN',
                                            color: const Color(0xFF989898),
                                            size: 8.0.sp, //13pxx
                                            fontWeight: FontWeight.w600,
                                          ),
                                          CustomSubTitleWidget(
                                            text: operationState.route!.origin!.cityOrigin, //'Santa Cruz'
                                            color: const Color(0xFF000000),
                                            size: 10.0.sp,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w600,
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
                                            // text: _operationState.route.route.destination.department.name, //'La Paz'
                                            text: operationState.route!.destination!.cityDestination,

                                            color: const Color(0xFF000000),
                                            size: 10.0.sp,
                                            maxLines: 2,
                                            fontWeight: FontWeight.w600,
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
                      ],
                    ),
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _detailOperation(
                            title: 'FECHA DE CARGA',
                            prefix: Container(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                              ),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 12.0.sp, //16px
                                color: Colors.black,
                              ),
                            ),
                            description: outputFormat.format(operationState.operation!.dates!.loadingDate!)[0].toUpperCase() +
                                outputFormat
                                    .format(operationState.operation!.dates!.loadingDate!)
                                    .substring(1), //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: _detailOperation(
                            title: 'FECHA DE DESCARGA',
                            prefix: Container(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                              ),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 12.0.sp, //16/16px
                                color: Colors.black,
                              ),
                            ),
                            description: outputFormat.format(operationState.operation!.dates!.deliveryDate!)[0].toUpperCase() +
                                outputFormat
                                    .format(operationState.operation!.dates!.deliveryDate!)
                                    .substring(1), //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFFD9D9D9),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                      left: 20.0,
                      right: 5.0,
                    ),
                    height: 1.5,
                    width: _responsive.width,
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _detailOperation(
                            title: 'DIRECCIÓN DE CARGA',
                            prefix: Container(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                              ),
                              child: Icon(
                                Icons.directions_outlined,
                                size: 12.0.sp, //16px
                                color: Colors.black,
                              ),
                            ),
                            description: operationState.operation?.route?.origin?.direction ??
                                "Sin dirección", //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _detailOperation(
                            title: 'DIRECCIÓN DE DESCARGA',
                            prefix: Container(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                              ),
                              child: Icon(
                                Icons.directions_outlined,
                                size: 12.0.sp, //16/16px
                                color: Colors.black,
                              ),
                            ),
                            description: operationState.operation?.route?.destination?.directionDestination ??
                                "Sin dirección", //_operationState.loadingOrders[0].dates.loadingDate.day.toString()  ,//'Martes 6, Mayo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFFD9D9D9),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                      left: 20.0,
                      right: 5.0,
                    ),
                    height: 1.5,
                    width: _responsive.width,
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _detailOperation(
                              title: 'PESO',
                              description: operationState.loadingOrders?.weightUnit != null
                                  ? operationState.loadingOrders!.weightUnit!.value.toString() +
                                      ' ' +
                                      operationState.loadingOrders!.weightUnit!.abbreviation!
                                  : "" //'4.5 Tn',
                              ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: _detailOperation(
                              title: 'CATEGORÍA',
                              // description: _operationState.loadingOrders[0].categoryLoad.name,

                              description: operationState.operation?.categoryLoad?.name ?? ""),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _detailOperation(
                              title: 'TIPO DE TRANSPORTE',
                              // description: _operationState.typeTransportUnit[0].name,
                              description: 'Camión Abierto'
                              //  description: operationState.operation.typeTransportUnitLabel == null
                              //      ? 'Camión Abierto'
                              //      : operationState.operation.typeTransportUnitLabel.toString(),
                              ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: _detailOperation(
                            title: 'CANTIDAD',
                            description: '1',
                            // description: _operationState.loadingOrders[0].operationId.typeTransportUnit.length.toString() + ' Camión',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _responsive.width,
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 5.0,
                    ),
                    margin: EdgeInsets.only(
                      top: _responsive.dp(1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: _detailOperation(title: 'DISTANCIA APROX.', description: '${(operationState.operation!.distanceTravel!.name)}'),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Visibility(
                          visible: operationState.operation!.freightValues!.freightOffered!.invoice!,
                          child: Expanded(
                            child: Container(
                              child: _detailOperation(title: 'FACTURADO', description: 'Sí'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _responsive.dp(5.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailOperation({String title = '', String description = '', Widget? prefix}) {
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
            Expanded(
              child: CustomSubTitleWidget(
                padding: const EdgeInsets.only(
                  right: 5.0,
                ),
                text: description,
                color: const Color(0xFF000000),
                size: 10.0.sp, //18px
                fontWeight: FontWeight.w400,
                margin: EdgeInsets.only(
                  top: _responsive.dp(0.25),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
