import 'package:appdriver/core/utils/font_styles.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/profile/widget_dropdown_button_field.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/widget_text_form_field.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_type_page.dart';
import 'package:appdriver/features/profile/presentation/widgets/departments.dart';
import 'package:appdriver/generated/l10n.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class PrincipalProfilePage extends StatefulWidget {
  const PrincipalProfilePage({Key? key}) : super(key: key);

  @override
  _PrincipalProfilePageState createState() => _PrincipalProfilePageState();
}

class _PrincipalProfilePageState extends State<PrincipalProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ProfileBloc bloc = sl<ProfileBloc>();
  final UserPreference userPreference = UserPreference();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final TextEditingController _controllerBirthDate = TextEditingController();
  late List<Departments> _companies;
  List<DropdownMenuItem<Departments>>? _dropdownMenuItems;
  Departments? _selectedDeparment;

  @override
  void initState() {
    super.initState();
    // FirebaseCrashlytics.instance.crash();
    analytics.logEvent(name: 'registro_datos_personales');
    _companies = Departments.getDepartments();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedDeparment = _dropdownMenuItems![0].value;
    bloc.stream.listen((state) {
      if (state.formStatus is SubmissionSuccess) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          NavigatorExtension.pushAndRemoveUntil(const TransportUnitTypePage(), context);

        });
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      bloc.add(ProfileExtensionDniChanged(departments: _selectedDeparment));
    });
  }

  profile(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('profile', value);
  }

  List<DropdownMenuItem<Departments>> buildDropdownMenuItems(List deparments) {
    List<DropdownMenuItem<Departments>> items = [];
    for (Departments department in deparments as Iterable<Departments>) {
      items.add(
        DropdownMenuItem(
          value: department,
          child: Text(department.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Departments? selectedDeparment, BuildContext context) {
    context.read<ProfileBloc>().add(ProfileExtensionDniChanged(departments: selectedDeparment));
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = userPreference.getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<ProfileBloc>(
        create: (context) => bloc,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: _profileForm(user),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _profileForm(UserModel user) {
    String documentIdData = "";
    DateTime? birthDate;
    String extension = "";

    documentIdData = user.profile?.documentId?.split("_").first ?? "";
    extension = user.profile?.documentId?.split("_").last ?? "";
    _selectedDeparment = _dropdownMenuItems!.firstWhereOrNull((element) => element.value!.id == extension)?.value;
    birthDate = user.profile?.birthDate;

    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 8.0.h,
                    ),
                    Text(
                      'Ingresa tus datos personales',
                      style: FontStyles.titleRegister.copyWith(letterSpacing: -1.02),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _firstNameField(user.profile?.firstName ?? ""),
                    const SizedBox(
                      height: 19,
                    ),
                    _lastNameField(user.profile?.lastName ?? ""),
                    const SizedBox(
                      height: 19,
                    ),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _documentIdField(documentIdData),
                            ),
                            const SizedBox(
                              width: 19,
                            ),
                            Expanded(
                              flex: 4,
                              child: _documentIdExtensionField(extension),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    _birthDateField(birthDate),
                  ],
                ),
                const SizedBox(
                  height: 19,
                ),
                Row(
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
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
                                onPressed: () async {
                                  NavigatorExtension.pushAndRemoveUntil(const OpportunityPage(), context);

                                },
                                label: S.of(context).skip,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _signUpButton(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _firstNameField(String firstName) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return TextFormFieldGeneric(
        initialValue: firstName,
        labelText: 'Nombres(s)',
        textCapitalization: TextCapitalization.sentences,
        validator: (value) => state.isValidFirstName ? null : 'Este campo es requerido',
        onChanged: (value) => context.read<ProfileBloc>().add(ProfileFirstNameChanged(firstName: value)),
      );
    });
  }

  Widget _lastNameField(String value) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return TextFormFieldGeneric(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        initialValue: value,
        labelText: 'Apellido(s)',
        validator: (value) => state.isValidLastName ? null : 'Este campo es requerido',
        onChanged: (value) => context.read<ProfileBloc>().add(ProfileLastNameChanged(lastName: value)),
      );
    });
  }

  Widget _documentIdField(String documentIdData) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return TextFormFieldGeneric(
        keyboardType: TextInputType.number,
        initialValue: documentIdData,
        labelText: 'CI',
        validator: (value) => state.isValidDocumentId ? null : 'Este campo es requerido',
        onChanged: (value) => context.read<ProfileBloc>().add(ProfileDocumentIdChanged(documentId: value)),
      );
    });
  }

  Widget _documentIdExtensionField(String extension) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return DropdownButtonFormFieldGeneric<Departments>(
        labelText: 'Complemento',
        value: _selectedDeparment,
        validator: (value) => state.isValidExtension ? null : 'Este campo es requerido',
        items: _dropdownMenuItems,
        onChanged: (departments) {
          onChangeDropdownItem(departments, context);
        },
      );
    });
  }

  Widget _birthDateField(DateTime? birthDate) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return GestureDetector(
        onTap: () => _selectDate(),
        child: AbsorbPointer(
          child: TextFormFieldGeneric(
            labelText: "Fecha de nacimiento",
            suffixIcon: const Icon(Icons.calendar_today),
            controller: _controllerBirthDate,
            validator: (value) => state.isValidBirthDate ? null : 'Este campo es requerido',
          ),
        ),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Expanded(
        child: RoundedButton(
          loading: state.formStatus is FormSubmitting ? true : false,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());

            if (_formKey.currentState!.validate()) {
              context.read<ProfileBloc>().add(ProfileSubmitted());
            }
          },
          label: 'Continuar',
        ),
      );
    });
  }

  _selectDate() async {
    await showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      builder: (context) {
        DateTime? tempPickedDate;
        return SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('omitir'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('continuar'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime(1980),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                    _controllerBirthDate.text = DateFormat('yyyy-MM-dd', 'es_ES').format(tempPickedDate!);
                    bloc.add(
                      ProfileBirthDateChanged(birthDate: DateFormat('yyyy-MM-dd', 'es_ES').format(tempPickedDate!)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
