import 'package:appdriver/core/utils/dialogs.dart';
import 'package:appdriver/core/utils/font_styles.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/profile/widget_dropdown_button_field.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/widget_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/brand_model.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/bloc/transport_unit/transport_unit_bloc.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_features_page.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/colors_model.dart';
import '../../../widgets/transport_type.dart';

class TransportUnitDataPage extends StatefulWidget {
  const TransportUnitDataPage({Key? key}) : super(key: key);

  @override
  _TransportUnitDataPageState createState() => _TransportUnitDataPageState();
}

class _TransportUnitDataPageState extends State<TransportUnitDataPage> {
  TransportUnitType? selected;
  TransportUnitBloc bloc = sl<TransportUnitBloc>();
  TextEditingController yearController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool lightTheme = true;
  Color currentColor = Colors.limeAccent;
  DateTime? selectDate;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];
  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) => setState(() => currentColors = colors);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final List<ColorsModel> _defaultColors = ColorsModel.getColors().map((feature) => feature).toList();
  int? selectedIndex;
  ColorsModel? _selectedValueColor;
  List<String> features = ["Not relevant", "Illegal", "Spam", "Offensive", "Uncivil"];
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: 'registro_unidad_de_transporte');

    //bloc.add(TransportUnitTypesGet());//
    bloc.stream.listen((state) {
      if (state.formStatus is SubmissionSuccess) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          userPreference.guestMode = false;
          NavigatorExtension.pushAndRemoveUntil(const TransportUnitFeaturesPage(), context);

        });
      }
      if (state.formStatus is SubmissionFailed) {
        Dialogs.alert(
          context,
          title: 'Advertencia',
          onPressed: () {
            Navigator.pop(context);
            bloc.add(TransportUnitResetForm());
          },
          description: state.messages,
          itemCustom: CupertinoDialogAction(
            textStyle: TextStyle(
              color: primaryColor,
              fontSize: 10.0.sp,
              fontWeight: FontWeight.w400,
            ),
            onPressed: () {
              Navigator.pop(context);
              var url = "whatsapp://send?phone=+59178477371&text=${greetingMessage()}, mi placa ${state.plate} esta duplicada.";
              _launchInBrowser(url, context);
            },
            child: const Text('Whatsapp'),
          ),
        );
      }
    });
  }

  truck(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('truck', value);
  }

  Future<void> _launchInBrowser(String url, context) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return BlocProvider(
      create: (context) => bloc..add(TransportUnitGetBrandsTypesEvent()),
      child: BlocConsumer<TransportUnitBloc, TransportUnitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.loading!) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
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
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - padding.top,
                  width: MediaQuery.of(context).size.width,
                  child: _profileForm(state),
                ),
              ),
            );
          }
        },
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
      // Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage(transport[index].patch),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _profileForm(TransportUnitState state) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8.0.h,
                    ),
                    Text(
                      'Ingresa los datos de tu camión',
                      style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _plateField(),
                    const SizedBox(
                      height: 19,
                    ),
                    _yearField(),
                    const SizedBox(
                      height: 19,
                    ),
                    _colorField(),
                    const SizedBox(
                      height: 19,
                    ),
                    _storageCapacityField(state.brands),
                    const SizedBox(
                      height: 19,
                    ),
                  ],
                ),
              ),
            ),
            // _numberOfShaftsField(),

            Row(
              children: [
                // BlocBuilder<TransportUnitBloc, TransportUnitState>(
                //   builder: (context, state) {
                //     return Visibility(
                //       visible: state.formStatus is FormSubmitting ? false : true,
                //       child: Expanded(
                //         child: Container(
                //           margin: const EdgeInsets.only(right: 30),
                //           child: RoundedButton(
                //             backgroundColor: const Color(0xffFAFAFA),
                //             borderColor: const Color(0xffD9D9D9),
                //             textColor: Colors.black,
                //             // loading: state.formStatus is FormSubmitting ? true : false,
                //             onPressed: () async {
                //               Navigator.pushAndRemoveUntil(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (BuildContext context) => Scaffold(
                //                       body: DoubleBackToCloseApp(
                //                           snackBar: const SnackBar(
                //                             content: Text('Toca de nuevo para salir'),
                //                           ),
                //                           child: OpportunityPage()),
                //                     ),
                //                   ),
                //                   (Route<dynamic> route) => false);
                //             },
                //             label: S.of(context).skip,
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
                _signUpButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _plateField() {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return TextFormFieldGeneric(
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A-Z0-9 ]")),
        ],
        labelText: 'Placa',
        validator: (value) => state.isValidPlate ? null : 'Este campo es requerido',
        onChanged: (value) => context.read<TransportUnitBloc>().add(TransportUnitPlate(plate: value)),
      );
    });
  }

  Widget _yearField() {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return TextFormFieldGeneric(
        controller: yearController,
        labelText: 'Año',
        readOnly: true,
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
                  // save the selected date to _selectedDate DateTime variable.
                  // It's used to set the previous selected date when
                  // re-showing the dialog.
                  selectedDate: selectDate == null ? DateTime.now() : selectDate!,
                  onChanged: (DateTime dateTime) {
                    // close the dialog when year is selected.
                    bloc.add(TransportUnitYear(year: DateFormat('yyyy').format(dateTime)));
                    yearController.text = DateFormat('yyyy').format(dateTime);
                    Navigator.pop(context);
                    setState(() {
                      selectDate = dateTime;
                    });
                    // Do something with the dateTime selected.
                    // Remember that you need to use dateTime.year to get the year
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
      return TextFormFieldGeneric(
        controller: colorController,
        readOnly: true,
        labelText: 'Color de la cabina',
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
                              : const SizedBox.shrink(),
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

  Widget _storageCapacityField(List<BrandModel>? brands) {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return DropdownButtonFormFieldGeneric<BrandModel>(
        labelText: 'Marca',
        validator: (value) => state.isValidBrand ? null : 'Este campo es requerido',
        items: brands!.map<DropdownMenuItem<BrandModel>>((BrandModel value) {
          return DropdownMenuItem<BrandModel>(
            value: value,
            child: Row(
              children: [Text(value.brand!)],
            ),
          );
        }).toList(),
        onChanged: (value) {
          bloc.add(TransportUnitBrandEvent(brand: value));
        },
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<TransportUnitBloc, TransportUnitState>(builder: (context, state) {
      return Expanded(
        child: RoundedButton(
          loading: state.formStatus is FormSubmitting ? true : false,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (_formKey.currentState!.validate()) {
              userPreference.guestMode = false;
              context.read<TransportUnitBloc>().add(TransportUnitSubmitted());
            }
          },
          label: 'Continuar',
        ),
      );
    });
  }
}
