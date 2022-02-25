import 'dart:io';

import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/profile/widget_dropdown_button_field.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/profile/widget_photo.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/widget_text_form_field.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/bloc/transport_unit/transport_unit_bloc.dart';
import 'package:appdriver/features/profile/presentation/widgets/colors_model.dart';
import 'package:appdriver/features/profile/presentation/widgets/transport_type.dart';
import 'package:appdriver/global_widgets/csc_picker.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'account_page.dart';

class TruckEditPageView extends StatefulWidget {
  static const routeName = 'home';

  const TruckEditPageView({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const TruckEditPageView());
  }

  @override
  _TruckEditPageViewState createState() => _TruckEditPageViewState();
}

class _TruckEditPageViewState extends State<TruckEditPageView> with WidgetsBindingObserver {
  bool? profile;
  bool? truck;
  String countryValue = "";

  DateTime? selectDate;
  ColorsModel? _selectedValueColor;
  final List<ColorsModel> _defaultColors = ColorsModel.getColors().map((feature) => feature).toList();
  final _multiSelectKey = GlobalKey<FormFieldState>();
  Value? _selectedValue;
  final _formKey1 = GlobalKey<FormState>();
  int? selectedIndex;
  TextEditingController yearController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TransportUnitBloc bloc = sl<TransportUnitBloc>();
  late List<String> _fuelTypers;
  late List<String> _companiesGps;
  List<DropdownMenuItem<String>>? _dropdownMenuItems;
  List<DropdownMenuItem<String>>? _dropdownMenuItemsCompaniesGps;
  @override
  void initState() {
    super.initState();
    _fuelTypers = ['Diesel', 'Gasolina', 'Gas'];
    _companiesGps = [
      'Boltrack',
      'Monnet',
      'Localisat',
      'Inter Monitoreo',
      'Protel GPS',
      'Gps Bolivia',
      'UBICAR',
      'Disatel',
      'HYDRA',
      'CONSAT',
      'GPSBOL',
      'NAVIXY',
      'Otro',
    ];
    _dropdownMenuItems = buildDropdownMenuItems(_fuelTypers);
    _dropdownMenuItemsCompaniesGps = buildDropdownMenuIItemsCompaniesGps(_companiesGps);
    bloc.add(TransportUnitGet());
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
            text: 'Mi unidad',
            color: Colors.black,
            size: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 37,
              color: Colors.black,
            ),
            onPressed: () {
              NavigatorExtension.pushAndRemoveUntil(const HomeMainView(), context);

            },
          ),
        ),
        body: BlocBuilder<TransportUnitBloc, TransportUnitState>(
          builder: (context, state) {
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
                  )
                ],
              );
            }
            if (state.transportUnit != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LinearPercentIndicator(
                          animation: true,
                          animateFromLastPercent: true,
                          animationDuration: 2000,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: 200,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          lineHeight: 10.0,
                          percent: (state.transportUnit!.advancePercentage! > 1.0 ? 1.0 : state.transportUnit!.advancePercentage!),
                          backgroundColor: const Color(0xffD9D9D9),
                          progressColor: primaryColor,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                            'Completado al (${((state.transportUnit!.advancePercentage! > 1.0 ? 1.0 : state.transportUnit!.advancePercentage)! * 100).round()}%)',
                            style: const TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
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
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fotos de tu unidad ',
                                      style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    buildPhotos(context, state),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xffD9D9D9),
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                                buildDataReadOnly(state),
                                const SizedBox(
                                  height: 19,
                                ),
                                buildFeaturesAll(state, context),
                                const SizedBox(
                                  height: 19,
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xffD9D9D9),
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                                buildPhotoRuat(state),
                                const SizedBox(
                                  height: 19,
                                ),
                                buildPolicy(state),
                                const SizedBox(
                                  height: 19,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Visibility(
                      visible: (!state.editingTransportUnit! && !state.editingTransportUnitFeatures!),
                      replacement: _saveData(),
                      child: RoundedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        label: 'Regresar',
                        textColor: Colors.white,
                        backgroundColor: primaryColor,
                        borderColor: primaryColor,
                      ),
                    ),
                  )
                ],
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
                      text: 'No cuentas con una unidad de transporte ¿deseas registrarlo?',
                      color: Colors.black,
                      size: 20, //13px
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Text(
                        '(Registrar mi unidad)',
                        style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "transportunittype");
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

  Widget _saveData() {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return RoundedButton(
        loading: state.formStatus is FormSubmitting ? true : false,
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          await showModalBottomSheet(
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
                      '¿Está seguro de guardar datos de tu unidad?',
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
                            label: 'Cancelar',
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
                              bloc.add(TransportUnitSubmittedEditing());
                            },
                            label: 'Si, guardar',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        label: 'Guardar Cambios',
      );
    });
  }

  Column buildPhotoRuat(TransportUnitState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WidgetPhoto(
          header: true,
          width: double.infinity,
          height: 170,
          urlPhoto: state.transportUnit!.resources!.photoRuat ?? "",
          showModalTitle: 'Foto de RUAT',
          type: 'photoRuat',
          cameraPhoto: () async {
            Navigator.pop(context);
            final picker = ImagePicker();
            File _image;
            final pickedFile = await picker.pickImage(source: ImageSource.camera);
            if (pickedFile != null) {
              _image = File(pickedFile.path);
              bloc.add(TransportUnitUpdatePhoto(
                filePhoto: _image,
                type: 'photoRuat',
              ));
            }
          },
          removePhoto: () {
            Navigator.of(context).pop();
            bloc.add(TransportUnitRemoveResource(type: 'photoRuat', photoId: null));
          },
          galleryPhoto: () async {
            Navigator.pop(context);
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );
            if (result != null) {
              File file = File(result.files.single.path!);
              bloc.add(TransportUnitUpdatePhoto(
                filePhoto: file,
                type: 'photoRuat',
              ));
            } else {
              // User canceled the picker
            }
          },
        ),
      ],
    );
  }

  Widget buildPolicy(TransportUnitState state) {
    return WidgetPhoto(
      width: double.infinity,
      height: 170,
      header: true,
      urlPhoto: photoHasToken(state.transportUnit!.resources!.photoPolicy ?? ''),
      showModalTitle: 'Foto de PÓLIZA (Opcional)',
      type: 'photoPolicy',
      cameraPhoto: () async {
        Navigator.pop(context);
        final picker = ImagePicker();
        File _image;
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          bloc.add(TransportUnitUpdatePhoto(filePhoto: _image, type: 'photoPolicy'));
        }
      },
      removePhoto: () {
        Navigator.of(context).pop();
        bloc.add(TransportUnitRemoveResource(type: 'photoPolicy', photoId: null));
      },
      galleryPhoto: () async {
        Navigator.pop(context);
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null) {
          File file = File(result.files.single.path!);
          bloc.add(TransportUnitUpdatePhoto(filePhoto: file, type: 'photoPolicy'));
        }
      },
    );
  }

  Column buildFeaturesAll(TransportUnitState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Característica',
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: state.editingTransportUnitFeatures == false,
              replacement: GestureDetector(
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(TransportUnitFeaturesEditing(editing: false));
                },
              ),
              child: GestureDetector(
                child: Text(
                  'Editar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(TransportUnitFeaturesEditing(editing: true));
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 19,
        ),
        Visibility(
            visible: state.editingTransportUnitFeatures!,
            replacement: state.featuresTransportUnit!.isNotEmpty
                ? MultiSelectChipField(
                    key: _multiSelectKey,
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    title: const Text('Porfavor selecciona uno o más características de tu camión'),
                    showHeader: false,
                    scroll: false,
                    chipColor: Colors.transparent,
                    selectedChipColor: primaryColor,
                    chipShape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0), side: const BorderSide(width: 1, color: Color(0xff242424))),
                    items:
                        state.featuresTransportUnit!.map((feature) => MultiSelectItem<FeaturesTransportUnitModel>(feature, feature.name!)).toList(),
                    textStyle: const TextStyle(color: Colors.black, fontSize: 14),
                    itemBuilder: (item, formFieldStateItem) {
                      return _buildItem1(item as MultiSelectItem<FeaturesTransportUnitModel>, context, state.selectedFeatures!);
                    },
                  )
                : Container(),
            child: MultiSelectChipField(
              key: _multiSelectKey,
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              title: const Text('Porfavor selecciona uno o más características de tu camión'),
              showHeader: false,
              scroll: false,
              chipColor: Colors.transparent,
              selectedChipColor: primaryColor,
              chipShape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0), side: const BorderSide(width: 1, color: Color(0xff242424))),
              items: state.featuresTransportUnit!.map((feature) => MultiSelectItem<FeaturesTransportUnitModel>(feature, feature.name!)).toList(),
              textStyle: const TextStyle(color: Colors.black, fontSize: 14),
              itemBuilder: (item, formFieldStateItem) {
                return _buildItem(item as MultiSelectItem<FeaturesTransportUnitModel>, context, state.selectedFeatures!);
              },
            )),
      ],
    );
  }

  String? getName(MultiSelectItem<FeaturesTransportUnitModel> item, List<FeaturesTransportUnitModel> selectedFeatures) {
    String? name = '';
    if (selectedFeatures.isNotEmpty) {
      for (var element in selectedFeatures) {
        if (element.id == item.value.id) {
          for (var element1 in element.values!) {
            if (element1.selected!) {
              if (element.qualitative!) {
                name = element1.valueQualitative;
              } else {
                name = element1.valueQuantitative.toString();
              }
            }
          }
        }
      }
      return name;
    }
    return '';
  }

  Widget _buildItem1(MultiSelectItem<FeaturesTransportUnitModel> item, BuildContext contextB, List<FeaturesTransportUnitModel> selectedFeatures) {
    return Builder(builder: (contextBuilder) {
      return Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.only(right: 4, top: 2, bottom: 2),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: selectedFeatures.contains(item.value) ? Colors.transparent : Colors.black),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15.0),
              bottom: Radius.circular(15.0),
            ),
          ),
          avatar: null,
          label: Container(
            child: selectedFeatures.contains(item.value)
                ? RichText(
                    text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: item.label + " : ",
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      TextSpan(
                          text: getName(item, selectedFeatures),
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700)),
                    ],
                  ))
                : Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: selectedFeatures.contains(item.value)
                        ? const TextStyle(color: Colors.black, fontSize: 14)
                        : const TextStyle(color: Colors.black, fontSize: 14),
                  ),
          ),
          selected: selectedFeatures.contains(item.value),
          backgroundColor: Colors.white,
          selectedColor: Colors.grey[200],
          tooltip: 'Características',
          onSelected: (value) async {},
        ),
      );
    });
  }

  Widget _buildItem(MultiSelectItem<FeaturesTransportUnitModel> item, BuildContext contextB, List<FeaturesTransportUnitModel> selectedFeatures) {
    return Builder(builder: (contextBuilder) {
      return Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.only(right: 4, top: 2, bottom: 2),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: selectedFeatures.contains(item.value) ? Colors.transparent : Colors.black),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15.0),
              bottom: Radius.circular(15.0),
            ),
          ),
          avatar: selectedFeatures.contains(item.value)
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              : null,
          label: Container(
            child: selectedFeatures.contains(item.value)
                ? RichText(
                    text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: item.label + " : ",
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      TextSpan(
                          text: getName(item, selectedFeatures),
                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ))
                : Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: selectedFeatures.contains(item.value)
                        ? const TextStyle(color: Colors.white, fontSize: 14)
                        : const TextStyle(color: Colors.black, fontSize: 14),
                  ),
          ),
          selected: selectedFeatures.contains(item.value),
          backgroundColor: Colors.white70,
          selectedColor: primaryColor,
          onSelected: (value) async {
            if (value) {
              if (item.value.quantitative! || item.value.qualitative!) {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: false,
                  isDismissible: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                            child: Form(
                              key: _formKey1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _selectedValue == null
                                      ? Container(
                                          margin: const EdgeInsets.only(bottom: 19),
                                          child: const Icon(
                                            Icons.notification_important_outlined,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    'Seleccione un valor para ${item.value.name}',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        color: _selectedValue != null ? const Color(0xff242424) : Colors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 19,
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: item.value.values!.length,
                                      itemBuilder: (context, index) {
                                        var valueItem = item.value.values![index];
                                        return ListTile(
                                          leading:
                                              selectedIndex == index ? const Icon(Icons.check_circle_outline_outlined, color: Colors.black) : null,
                                          title: Text(item.value.qualitative! ? valueItem.valueQualitative! : valueItem.valueQuantitative.toString(),
                                              style: selectedIndex == index
                                                  ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                                                  : const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                          tileColor: selectedIndex == index ? const Color(0xfffdf2e6) : null,
                                          onTap: () {
                                            setState(() {
                                              _selectedValue = valueItem;
                                              selectedIndex = index;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 19,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RoundedButton(
                                          backgroundColor: Colors.transparent,
                                          borderColor: Colors.transparent,
                                          textColor: Colors.black,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            selectedFeatures.remove(item.value);
                                          },
                                          label: 'Cancelar',
                                        ),
                                      ),
                                      Expanded(
                                        child: RoundedButton(
                                          onPressed: () {
                                            if (_formKey1.currentState!.validate()) {
                                              selectedFeatures.add(item.value);
                                              if (_selectedValue != null) {
                                                for (var element in selectedFeatures) {
                                                  for (var element in element.values!) {
                                                    if (element.id == _selectedValue!.id) {
                                                      element.selected = true;
                                                    }
                                                  }
                                                }
                                                Navigator.pop(context);
                                                setState(() {});
                                                bloc.add(TransportUnitFeaturesSelect());
                                              }
                                            }
                                          },
                                          label: 'Guardar',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
                if (selectedFeatures.isEmpty) {
                  selectedIndex = null;
                  _selectedValue = null;
                }
              } else {
                selectedFeatures.add(item.value);
                setState(() {});
              }
            } else {
              var a = item.value.id;
              for (var element in selectedFeatures) {
                if (a == element.id) {
                  for (var element in element.values!) {
                    element.selected = false;
                  }
                }
              }
              selectedIndex = null;
              selectedFeatures.remove(item.value);
              setState(() {});
            }
            // if (widget.onTap != null) widget.onTap!(selectedFeatures);
          },
        ),
      );
    });
  }

  Column buildDataReadOnly(TransportUnitState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Datos de tu unidad ',
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: state.editingTransportUnit == false,
              replacement: GestureDetector(
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(ProfileTransportEditing(editing: false));
                },
              ),
              child: GestureDetector(
                child: Text(
                  'Editar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(ProfileTransportEditing(editing: true));
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Visibility(
            visible: state.editingTransportUnit == false,
            replacement: Column(
              children: [
                _typeField(),
                const SizedBox(
                  height: 7,
                ),
                _plateField(state.transportUnit!.plate),
                const SizedBox(
                  height: 7,
                ),
                _yearField(state.transportUnit!.year),
                const SizedBox(
                  height: 7,
                ),
                _colorField(),
                const SizedBox(
                  height: 7,
                ),
                _brandField(state.brands),
                const SizedBox(
                  height: 7,
                ),
                _countryField(state),
                const SizedBox(
                  height: 7,
                ),
                _fuelTypeField(state.transportUnit!.engine?.fuelType),
                const SizedBox(
                  height: 7,
                ),
                _engineField(state.transportUnit!.engine?.engine),
                const SizedBox(
                  height: 7,
                ),
                _companiesField(state.transportUnit!.companyGps),
                const SizedBox(
                  height: 7,
                ),
              ],
            ),
            child: Column(
              children: [
                formFieldCustom(state.transportUnit?.typeTransportUnit ?? "", 'Tipo de camión'),
                formFieldCustom(state.transportUnit?.plate ?? "", 'Placa'),
                formFieldCustom(state.transportUnit?.color ?? "", 'Color'),
                formFieldCustom(state.transportUnit?.year ?? "", 'Año'),
                formFieldCustom(state.transportUnit?.brand ?? "", 'Marca'),
                formFieldCustom(state.transportUnit?.country ?? "", 'País'),
                formFieldCustom(state.transportUnit?.engine?.engine ?? "", 'Motor'),
                formFieldCustom(state.transportUnit?.engine?.fuelType ?? "", 'Tipo de combustible'),
                formFieldCustom(state.transportUnit?.companyGps ?? "", 'Compañia GPS (opcional)'),
              ],
            )),
      ],
    );
  }

  CSCPicker _countryField(TransportUnitState state) {
    return CSCPicker(
      flagState: CountryFlag.DISABLE,
      dropdownItemStyle: GoogleFonts.montserrat(
        fontSize: 16,
        color: Colors.black,
      ),
      showCities: false,
      showStates: false,
      selectedItemStyle: GoogleFonts.montserrat(
        fontSize: 16,
        color: Colors.black,
      ),
      dropdownHeadingStyle: GoogleFonts.montserrat(
        fontSize: 16,
        color: Colors.black,
      ),
      selectedCountry: state.transportUnit!.country ?? "",
      dropdownDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      disabledDropdownDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      layout: Layout.vertical,
      defaultCountry: DefaultCountry.Bolivia,
      onCountryChanged: (value) {
        setState(() {
          countryValue = value!;
          bloc.add(TransportUnitCountry(country: value));
        });
      },
      onStateChanged: (value) {
        setState(() {
          //stateValue = value;
        });
      },
      onCityChanged: (value) {
        setState(() {
          //cityValue = value;
        });
      },
    );
  }

  Widget _plateField(String? initialValue) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return TextFormFieldGeneric(
        hintText: 'Ej: 8255HUB',
        labelText: 'Placa',
        enabled: false,
        underline: true,
        initialValue: initialValue,
        validator: (value) => state.isValidPlate ? null : 'Este campo es requerido',
        onChanged: (value) => context.read<TransportUnitBloc>().add(TransportUnitPlate(plate: value)),
      );
    });
  }

  Widget _engineField(String? initialValue) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return TextFormFieldGeneric(
        labelText: 'Motor',
        underline: true,
        initialValue: initialValue,
        validator: (value) => state.isValidPlate ? null : 'Este campo es requerido',
        onChanged: (value) => context.read<TransportUnitBloc>().add(TransportUnitEngine(engine: value)),
      );
    });
  }

  Widget _fuelTypeField(String? initialValue) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return DropdownButtonFormFieldGeneric<String>(
        labelText: 'Tipo de combustible',
        underline: true,
        value: _fuelTypers.firstWhereOrNull((element) => element == state.transportUnit?.engine?.fuelType),
        items: _dropdownMenuItems,
        onChanged: (departments) {
          onChangeDropdownItem(departments, context);
        },
      );
    });
  }

  Widget _companiesField(String? initialValue) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 7,
          ),
          initialValue == null
              ? Text("Seleccione una compañia de Gps", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400))
              : const SizedBox.shrink(),
          DropdownButtonFormFieldGeneric<String>(
            labelText: 'Empresa Gps (opcional)',
            underline: true,
            value: _companiesGps.firstWhereOrNull((element) => element == state.transportUnit?.companyGps),
            items: _dropdownMenuItemsCompaniesGps,
            onChanged: (departments) {
              onChangeDropdownItemCompanies(departments, context);
            },
          ),
        ],
      );
    });
  }

  Widget _yearField(String? year) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      yearController.value = yearController.value.copyWith(text: state.year!.isNotEmpty ? state.year : state.transportUnit!.year);
      return TextFormFieldGeneric(
        controller: yearController,
        underline: true,
        readOnly: true,
        labelText: 'Año',
        onTap: () async {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
            ),
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                width: double.infinity,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(DateTime.now().year - 200, 1),
                  lastDate: DateTime(DateTime.now().year),
                  initialDate: DateTime.now(),
                  selectedDate: selectDate == null ? DateTime.now() : selectDate!,
                  onChanged: (DateTime dateTime) {
                    bloc.add(TransportUnitYear(year: DateFormat('yyyy').format(dateTime)));
                    yearController.text = DateFormat('yyyy').format(dateTime);
                    Navigator.pop(context);
                    setState(() {
                      selectDate = dateTime;
                    });
                  },
                ),
              );
            },
          );
        },
        validator: (value) => state.isValidYear ? null : 'Este campo es requerido',
      );
    });
  }

  Widget _colorField() {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      colorController.value = colorController.value.copyWith(text: state.color!.isNotEmpty ? state.color : state.transportUnit!.color);
      return TextFormFieldGeneric(
        underline: true,
        controller: colorController,
        labelText: 'Color',
        suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
        readOnly: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          await showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
            ),
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context, setState) {
                return Container(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _selectedValueColor == null
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: const Icon(
                                    Icons.notification_important_outlined,
                                    color: Colors.red,
                                  ),
                                )
                              : Container(),
                          Text(
                            'Seleccione un color ',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: _selectedValueColor != null ? const Color(0xff242424) : Colors.red, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            itemCount: _defaultColors.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: _defaultColors[index].id == _selectedValueColor?.id
                                    ? Icon(Icons.circle, color: _selectedValueColor?.color)
                                    : null,
                                title: Text(_defaultColors[index].name,
                                    style: _defaultColors[index].id == _selectedValueColor?.id
                                        ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                                        : const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                onTap: () {
                                  // valueItem.selected = true;
                                  setState(() {
                                    // if (_selectedValue != null) {
                                    //   _selectedValue.selected = false;
                                    // }
                                    // valueItem.selected =
                                    //     !valueItem.selected;
                                    _selectedValueColor = _defaultColors[index];
                                    bloc.add(TransportUnitColor(color: _defaultColors[index].name));
                                    colorController.text = _defaultColors[index].name;
                                    // Navigator.pop(context);
                                    // selectedIndex = index;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundedButton(
                              backgroundColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              textColor: Colors.black,
                              // loading: state.formStatus is FormSubmitting ? true : false,
                              onPressed: () {
                                Navigator.pop(context);
                                _selectedValueColor = null;
                                bloc.add(TransportUnitColor(color: ''));
                                colorController.text = '';
                              },
                              label: 'Cancelar',
                            ),
                          ),
                          Expanded(
                            child: RoundedButton(
                              // loading: state.formStatus is FormSubmitting ? true : false,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: 'Guardar',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                    ],
                  ),
                );
              });
            },
          );
        },
        validator: (value) => state.isValidColor ? null : 'Este campo es requerido',
      );
    });
  }

  Widget _brandField(List<BrandModel>? brands) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return DropdownButtonFormFieldGeneric<BrandModel>(
        labelText: 'Marca',
        underline: true,
        value: brands!.firstWhereOrNull((element) => element.brand == state.transportUnit!.brand),
        items: brands.map<DropdownMenuItem<BrandModel>>((BrandModel value) {
          return DropdownMenuItem<BrandModel>(
            value: value,
            child: Row(
              children: [Text(value.brand!)],
            ),
          );
        }).toList(),
        onChanged: (value) {
          // onChangeDropdownItem(departments, context);
          bloc.add(TransportUnitBrandEvent(brand: value));
        },
      );
    });
  }

  Widget _typeField() {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(
      builder: (context, state) {
        return DropdownButtonFormFieldGeneric<TransportUnitType>(
          underline: true,
          value: state.transportUnitTypes!.firstWhereOrNull((element) => element.name == state.transportUnit!.typeTransportUnit),
          items: state.transportUnitTypes!.map<DropdownMenuItem<TransportUnitType>>((TransportUnitType value) {
            return DropdownMenuItem<TransportUnitType>(
              value: value,
              child: Row(
                children: [Text(value.name!)],
              ),
            );
          }).toList(),
          onChanged: (TransportUnitType? departments) {
            onChangeDropdownItemType(departments!, context);
          },
        );
      },
    );
  }

  Container buildPhotos(BuildContext context, TransportUnitState state) {
    return Container(
      height: 200,
      width: state.transportUnit!.resources!.photo!.isNotEmpty ? MediaQuery.of(context).size.width - 60 : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
      ),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: state.transportUnit!.resources!.photo!.length + 1,
        itemBuilder: (BuildContext context, int index) {
          var ultimo = state.transportUnit!.resources!.photo!.length;
          if (index == ultimo) {
            return addPhoto();
          }
          var photo = state.transportUnit!.resources!.photo![index];
          return WidgetPhoto(
            header: false,
            width: double.infinity,
            height: 200,
            urlPhoto: photoHasToken(photo.path!),
            showModalTitle: 'Foto de perfil',
            removePhoto: () {
              Navigator.of(context).pop();
              bloc.add(TransportUnitRemoveResource(type: 'photo', photoId: photo.id));
            },
            type: 'photo',
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<TransportUnitType>> buildDropdownMenuItemsType(List<TransportUnitType> fuelTypes) {
    List<DropdownMenuItem<TransportUnitType>> items = [];
    for (TransportUnitType fuelType in fuelTypes) {
      items.add(
        DropdownMenuItem(
          value: fuelType,
          child: Text(fuelType.name!),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> fuelTypes) {
    List<DropdownMenuItem<String>> items = [];
    for (String fuelType in fuelTypes) {
      items.add(
        DropdownMenuItem(
          value: fuelType,
          child: Text(fuelType),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDropdownMenuIItemsCompaniesGps(List<String> companies) {
    List<DropdownMenuItem<String>> items = [];
    for (String companie in companies) {
      items.add(
        DropdownMenuItem(
          value: companie,
          child: Text(companie),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(String? selectedFuelTypes, BuildContext context) {
    bloc.add(TransportUnitFuelType(fuelType: selectedFuelTypes));
  }

  onChangeDropdownItemCompanies(String? companySelected, BuildContext context) {
    bloc.add(TransportUnitCompanies(companies: companySelected));
  }

  onChangeDropdownItemType(TransportUnitType selectedFuelTypes, BuildContext context) {
    bloc.add(TransportUniType(type: selectedFuelTypes.name));
  }

  Widget addPhoto() {
    return WidgetPhoto(
      urlPhoto: "",
      width: double.infinity,
      height: 200,
      header: false,
      showModalTitle: 'Foto de tu camión',
      type: 'pathPhoto',
      cameraPhoto: () async {
        Navigator.pop(context);
        final picker = ImagePicker();
        File _image;
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          bloc.add(TransportUnitUpdatePhoto(filePhoto: _image, type: 'photo'));
        }
      },
      galleryPhoto: () async {
        Navigator.pop(context);
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null) {
          File file = File(result.files.single.path!);
          bloc.add(TransportUnitUpdatePhoto(filePhoto: file, type: 'photo'));
        } else {
          // User canceled the picker
        }
      },
    );
  }

  Widget formFieldCustom(String initialValue, String labelText) {
    return TextFormFieldGeneric(
      initialValue: initialValue,
      readOnly: true,
      enabled: false,
      labelText: labelText,
      underline: true,
    );
  }
}
