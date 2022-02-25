import 'package:appdriver/core/utils/font_styles.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdriver/core/notifications_locale/local_notification.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/features_transport_unit_model.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/bloc/transport_unit/transport_unit_bloc.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/transport_type.dart';
import 'package:sizer/sizer.dart';

class TransportUnitFeaturesPage extends StatefulWidget {
  const TransportUnitFeaturesPage({Key? key}) : super(key: key);

  @override
  _TransportUnitFeaturesPageState createState() => _TransportUnitFeaturesPageState();
}

class _TransportUnitFeaturesPageState extends State<TransportUnitFeaturesPage> {
  TransportUnitType? selected;
  TransportUnitBloc bloc = sl<TransportUnitBloc>();
  TextEditingController yearController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  bool lightTheme = true;
  Color currentColor = Colors.limeAccent;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  DateTime? selectDate;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];
  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) => setState(() => currentColors = colors);

  int? selectedIndex;
  Value? _selectedValue;
  final List<FeaturesTransportUnitModel> _selectedFeatures = [];
  List<String> features = ["Not relevant", "Illegal", "Spam", "Offensive", "Uncivil"];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: 'registro_caracteristicas_unidad_transporte');
    bloc.stream.listen((state) {
      if (state.formStatus is SubmissionSuccess) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);
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
      body: BlocProvider(
        create: (context) => bloc..add(TransportUnitGetAllRegisterFeatures()),
        child: BlocConsumer<TransportUnitBloc, TransportUnitState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.loading!) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.0.h,
                    ),
                    Text(
                      'Características de tu camión',
                      style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Selecciona una o más características de tu camión',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: const Color(0xff242424),
                      ),
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
                ),
              );
            } else if (state.featuresTransportUnit!.isNotEmpty) {
              // var stateSelect = context.select((TransportUnitBloc value) => value.state);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8.0.h,
                    ),
                    Text(
                      'Características de tu camión',
                      style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Selecciona una o más características de tu camión',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: const Color(0xff242424),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: MultiSelectChipField(
                          key: _multiSelectKey,
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          title: const Text('Porfavor selecciona uno o más Características de tu camión'),
                          showHeader: false,
                          scroll: false,
                          chipColor: Colors.transparent,
                          selectedChipColor: primaryColor,
                          chipShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0), side: const BorderSide(width: 1, color: Color(0xff242424))),
                          items: state.featuresTransportUnit!
                              .map((feature) => MultiSelectItem<FeaturesTransportUnitModel>(feature, feature.name!))
                              .toList(),
                          textStyle: const TextStyle(color: Colors.black, fontSize: 14),
                          itemBuilder: (item, state) {
                            // return your custom widget here
                            return _buildItem(item as MultiSelectItem<FeaturesTransportUnitModel>, context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          child: Builder(builder: (context) {
                            return RoundedButton(
                              loading: state.formStatus is FormSubmitting ? true : false,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                List<FeaturesTransportUnitModel> requiresForCarrier = [];
                                var features = state.featuresTransportUnit!.toList();
                                for (var element in features) {
                                  if ((element.requireForCarrier != null && element.requireForCarrier!)) {
                                    var a = _selectedFeatures.contains(element);
                                    if (!a) {
                                      requiresForCarrier.add(element);
                                    }
                                  }
                                }
                                if (requiresForCarrier.isNotEmpty) {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Las siguientes características  son requeridas, desea continuar?',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff242424),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(top: 30),
                                                child: ListView.builder(
                                                  // set the scrollDirection here
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: requiresForCarrier.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (_, i) => Wrap(
                                                    direction: Axis.horizontal,
                                                    spacing: 10.0,
                                                    runSpacing: 20.0,
                                                    children: [
                                                      Text(
                                                        requiresForCarrier[i].name!,
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0xff707070),
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                                                      bloc.add(TransportUnitFeatureSubmitted(features: _selectedFeatures));
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
                                  userPreference.guestMode = false;
                                  bloc.add(TransportUnitFeatureSubmitted(features: _selectedFeatures));
                                }
                              },
                              label: 'Continuar',
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(behavior: SnackBarBehavior.floating, content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildItem(MultiSelectItem<FeaturesTransportUnitModel> item, BuildContext contextB) {
    return Builder(builder: (contextBuilder) {
      return Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.only(right: 4, top: 2, bottom: 2),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: _selectedFeatures.contains(item.value) ? Colors.transparent : Colors.black),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15.0),
              bottom: Radius.circular(15.0),
            ),
          ),
          avatar: _selectedFeatures.contains(item.value)
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              : null,
          label: Container(
            child: _selectedFeatures.contains(item.value)
                ? RichText(
                    text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: item.label + " : ",
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      TextSpan(text: getName(item), style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ))
                : Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: _selectedFeatures.contains(item.value)
                        ? const TextStyle(color: Colors.white, fontSize: 14)
                        : const TextStyle(color: Colors.black, fontSize: 14),
                  ),
          ),
          selected: _selectedFeatures.contains(item.value),
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
                                    'Seleccione un valor para ${item.value.name}',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16, color: _selectedValue != null ? const Color(0xff242424) : Colors.red, fontWeight: FontWeight
                                        .w500),
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
                                          backgroundColor: const Color(0xffFAFAFA),
                                          borderColor: const Color(0xffD9D9D9),
                                          textColor: Colors.black,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _selectedValue = null;
                                            selectedIndex = null;
                                            _selectedFeatures.remove(item.value);
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
                                            if (_formKey1.currentState!.validate()) {
                                              _selectedFeatures.add(item.value);
                                              if (_selectedValue != null) {
                                                for (var element in _selectedFeatures) {
                                                  for (var element in element.values!) {
                                                    if (element.id == _selectedValue!.id) {
                                                      element.selected = true;
                                                    }
                                                  }
                                                }
                                                Navigator.pop(context);
                                                setState(() {});
                                                bloc.add(TransportUnitFeaturesSelect());
                                                _selectedValue = null;
                                                selectedIndex = null;
                                              } else {
                                                _showSnackBar(contextB, 'Selecciona una Característica');
                                              }
                                            }
                                          },
                                          label: 'Continuar',
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
                if (_selectedFeatures.isEmpty) {
                  selectedIndex = null;
                  _selectedValue = null;
                }
              } else {
                _selectedFeatures.add(item.value);
                setState(() {});
              }
            } else {
              selectedIndex = null;
              for (var element in _selectedFeatures) {
                for (var element in element.values!) {
                  if (element.id == _selectedValue?.id) {
                    element.selected = false;
                  }
                }
              }
              _selectedFeatures.remove(item.value);
              setState(() {});
            }
          },
        ),
      );
    });
  }

  String? getName(MultiSelectItem<FeaturesTransportUnitModel> item) {
    String? name = '';
    if (_selectedFeatures.isNotEmpty) {
      for (var element in _selectedFeatures) {
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
}
