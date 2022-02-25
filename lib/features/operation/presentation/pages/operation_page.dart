import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/operation/data/supcriptions/supcription_bloc_operation.dart';
import 'package:appdriver/features/operation/presentation/pages/task_operation_v2.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/dialogs.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/core/utils/utils.dart' show Responsive;
import 'package:appdriver/features/operation/data/models/operation_model.dart' as operation;
import 'package:appdriver/features/operation/presentation/bloc/operation_bloc.dart';
import 'package:appdriver/features/operation/presentation/pages/state_operation_page.dart';
import 'package:appdriver/features/operation/presentation/pages/travels_past_page.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/global_widgets/custom_success.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class OperationPage extends StatefulWidget {
  static const String routeName = "operation_page";

  const OperationPage({Key? key}) : super(key: key);

  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> with SingleTickerProviderStateMixin {
  late Responsive _responsive;
  bool _notificar = false;
  Map<PolylineId, Polyline> polylines = {};
  bool initMap = false;
  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor pinLocationIcon1;
  double CAMERA_ZOOM = 12;
  double CAMERA_TILT = 80;
  double CAMERA_BEARING = 30;
  LatLng SOURCE_LOCATION = const LatLng(-17.794245457944005, -63.186950719603765);
  operation.Stage? stageActual;
  OperationBloc bloc = sl<OperationBloc>();
  @override
  void initState() {
    super.initState();
    OperationSubcriptions.instance.init();
    OperationSubcriptions.instance.streamTask.listen((event) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Toca de nuevo para salir'),
              ),
              child: SuccessPage(
                title: 'Tarea subida exitosamente',
                description: 'Se ha subido la tarea exitosamente.',
                buttonText: 'Continuar',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      );
    });
    getBytesFromAsset('assets/carguio.png', 120).then((onValue) {
      pinLocationIcon = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/descarguio.png', 120).then((onValue) {
      pinLocationIcon1 = BitmapDescriptor.fromBytes(onValue);
    });
    transport();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/Logo2.png');
  }

  dynamic transport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var data = json.decode(prefs.getString('transportUnit')!);
    } catch (e) {
      print("Error");
    }
  }

  @override
  void dispose() {
    OperationSubcriptions.instance.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive.of(context);
    var data = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocProvider<OperationBloc>(
            create: (context) => bloc..add(LoadOperationEvent()),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.all(0.0),
                color: Colors.white,
                width: _responsive.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                    width: _responsive.width,
                    color: Colors.white,
                    child: BlocListener<OperationBloc, OperationState>(
                      listenWhen: (previous, current) => previous.taskSuccess != current.taskSuccess,
                      listener: (context, state) {
                        if (state.taskSuccess!) {}
                      },
                      child: BlocBuilder<OperationBloc, OperationState>(
                        builder: (context, state) {
                          if (state.loading!) {
                            return Container(
                              padding: EdgeInsets.only(top: _responsive.hp(40)),
                              height: _responsive.hp(100),
                              child: Column(
                                children: const <Widget>[
                                  CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    backgroundColor: Colors.orange,
                                  ),
                                ],
                              ),
                            );
                          } else if (state.stages!.isEmpty) {
                            return Container(
                              padding: EdgeInsets.only(
                                top: _responsive.dp(40),
                                bottom: _responsive.dp(1.5),
                                left: _responsive.dp(1.5),
                                right: _responsive.dp(1.5),
                              ),
                              height: _responsive.hp(100),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomSubTitleWidget(
                                      text: 'No hay una operación asignada',
                                      size: 14.0.sp,
                                      padding: const EdgeInsets.only(left: 8.0),
                                      fontWeight: FontWeight.w500,
                                      margin: EdgeInsets.only(
                                        bottom: _responsive.dp(1.5),
                                      ),
                                    ),
                                    RoundedButton(
                                      onPressed: () async {
                                        NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
                                      },
                                      label: 'Volver a oportunidades',
                                      textColor: Colors.white,
                                      backgroundColor: primaryColor,
                                      borderColor: primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                Expanded(
                                  child: NestedScrollView(
                                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                                      return <Widget>[
                                        SliverAppBar(
                                          leading: GestureDetector(
                                            onTap: () {
                                              NavigatorExtension.pushAndRemoveUntil(const TravelPastPage(), context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.only(left: 10.0),
                                              child: IconSvgWidget(
                                                padding: EdgeInsets.all(10),
                                                size: 30,
                                                image: 'assets/icon-close.svg',
                                              ),
                                            ),
                                          ),
                                          elevation: 0,
                                          actions: [
                                            GestureDetector(
                                              onTap: () {
                                                _checkWhatsApp(state.operation?.authUsers?.phone ?? "76699597");
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: IconSvgWidget(
                                                  size: 40,
                                                  image: 'assets/whatsapp.svg',
                                                ),
                                              ),
                                            )
                                          ],
                                          automaticallyImplyLeading: false,
                                          expandedHeight: 40.0.h,
                                          floating: true,
                                          pinned: true,
                                          flexibleSpace: FlexibleSpaceBar(
                                            centerTitle: true,
                                            title: SABT(
                                              child: CustomTitleWidget(
                                                title: 'Operación en curso',
                                                size: 18.0.sp,
                                                padding: EdgeInsets.zero,
                                                margin: EdgeInsets.zero,
                                              ),
                                            ),
                                            background: _operationActive(context, state, data),
                                            collapseMode: CollapseMode.parallax,
                                          ),
                                        ),
                                      ];
                                    },
                                    body: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: false,
                                      controller: bloc.refreshController,
                                      onRefresh: () {
                                        bloc.add(RefreshOperation(isRefresh: true));
                                      },
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: TextButtonWidget(
                                                  padding: EdgeInsets.zero,
                                                  margin: EdgeInsets.zero,
                                                  title: 'Ver detalle',
                                                  size: 10.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  onPressed: () {
                                                    Navigator.pushNamed(context, 'show_operation', arguments: state);
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: CustomSubTitleWidget(
                                                  text: 'Estado de la operación',
                                                  size: 14.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  margin: const EdgeInsets.only(
                                                    bottom: 20,
                                                  ),
                                                ),
                                              ),
                                              StateOperationPage(stages: state.stages),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: CustomSubTitleWidget(
                                                  text: 'Mis tareas',
                                                  size: 14.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  margin: const EdgeInsets.only(top: 20),
                                                ),
                                              ),
                                              TaskOperationV2(
                                                operation: state,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _operationActive(BuildContext context, OperationState operationState, double paddinTop) {
    CameraPosition kGooglePlex = CameraPosition(
      zoom: CAMERA_ZOOM,
      target: SOURCE_LOCATION,
    );
    if (operationState.myLocation != null) {
      kGooglePlex = CameraPosition(
        target: LatLng(operationState.myLocation!.lat!, operationState.myLocation!.lng!),
        zoom: CAMERA_ZOOM,
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
    var padd = 40.0.h;
    if (!_notificar) {
      return Container(
        width: _responsive.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  width: _responsive.width,
                  height: padd,
                  child: BlocBuilder<OperationBloc, OperationState>(
                    buildWhen: (OperationState previous, OperationState current) => previous.polylines != current.polylines,
                    builder: (context, state) {
                      return GoogleMap(
                        markers: operationState.markers!.values.toSet(),
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                          ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
                          ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()))
                          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
                        polylines: Set<Polyline>.of(polylines.values),
                        zoomControlsEnabled: true,
                        compassEnabled: false,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: kGooglePlex,
                        onMapCreated: (GoogleMapController controller) async {
                          bloc.setMapController(controller);
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) {
                              List<double> lngs1 = [];
                              List<double> lats1 = [];
                              if (operationState.markers != null) {
                                if (operationState.markers!.isNotEmpty) {
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
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: () => bloc.goTo(),
                    child: const Icon(
                      Icons.gps_fixed,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  void _checkWhatsApp(String number) {
    checkWhatsApp(number).then((bool resp) {
      if (!resp) {
        SnackBarWidget.show(context: context, description: 'Sin conexión');
      }
    }).catchError((error) {
      SnackBarWidget.show(context: context, description: 'Sin conexión');
    });
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file;
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition? _position;
  bool? _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType();
    bool visible = settings == null || settings.currentExtent < settings.minExtent + 50;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _visible! ? 1 : 0,
      child: _visible! ? widget.child : null,
    );
  }
}
