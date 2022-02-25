import 'dart:io';

import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/profile/widget_dropdown_button_field.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/profile/widget_photo.dart';
import 'package:appdriver/features/profile/presentation/pages/widgets/widget_text_form_field.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:appdriver/global_widgets/csc_picker.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../widgets/departments.dart';
import 'package:sizer/sizer.dart';

import 'account_page.dart';

class ProfileEditPageView extends StatefulWidget {
  static const routeName = 'home';

  const ProfileEditPageView({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ProfileEditPageView());
  }

  @override
  _ProfileEditPageViewState createState() => _ProfileEditPageViewState();
}

class _ProfileEditPageViewState extends State<ProfileEditPageView> with WidgetsBindingObserver {
  bool? profile;
  bool? truck;
  ProfileBloc bloc = sl<ProfileBloc>();
  List<DropdownMenuItem<Departments>>? _dropdownMenuItems;
  Departments? _selectedDeparment;
  late List<Departments> _deparments;
  String? countryValue = "";
  String? stateValue = "";
  final _formKey = GlobalKey<FormState>();
  String? cityValue = "";
  String address = "";
  FocusNode? myFocusNode;
  final UserPreference _prefsUser = UserPreference();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController documentIdController = TextEditingController();
  TextEditingController taxIdController = TextEditingController();
  TextEditingController extensionDocumentIdController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController personReferenceController = TextEditingController();
  TextEditingController phoneReferenceController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _deparments = Departments.getDepartments();
    _dropdownMenuItems = buildDropdownMenuItems(_deparments);
    bloc.add(ProfileGetUser());
    DateTime? birthDate = _prefsUser.getUserMenu?.profile?.birthDate;
    if (birthDate != null) {
      birthDateController.text = DateFormat('yyyy-MM-dd', 'es_ES').format(birthDate);
    }
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    myFocusNode!.dispose();
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
            text: 'Mi perfil',
            color: Colors.black,
            size: 18.sp, //13px
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
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            double? advancePercentageUser = 0;
            String phone = "";
            String documentIdData = "";
            String birthDate = "";
            String extension = "";
            if (state.user != null) {
              advancePercentageUser = state.user!.advancePercentage! > 1.0 ? 1.0 : state.user!.advancePercentage!;
              phone = state.user!.auth!.countryCode! + " " + state.user!.auth!.phone!;
              documentIdData = state.user!.profile?.documentId?.split("_").first ?? "";
              extension = state.user!.profile?.documentId?.split("_").last ?? "";
              _selectedDeparment = _dropdownMenuItems!.firstWhereOrNull((element) => element.value!.id == extension)?.value;
              birthDate = state.user!.profile?.birthDate != null ? DateFormat('dd/MM/yyyy').format(state.user!.profile!.birthDate!) : "";
            }
            if (state.loading) {
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
            if (state.user != null) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            percent: advancePercentageUser,
                            backgroundColor: const Color(0xffD9D9D9),
                            progressColor: primaryColor,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Completado al (${(advancePercentageUser * 100).round()}%)',
                            style: TextStyle(fontSize: 8.0.sp, color: primaryColor, fontWeight: FontWeight.w400),
                          )
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
                              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildPhotoProfile(state),
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
                                  Visibility(
                                    visible: state.editingProfile == false,
                                    replacement: buildDataProfile(state, phone, documentIdData, birthDate, extension),
                                    child: buildDataProfileReadOnly(state, phone, documentIdData, birthDate, extension),
                                  ),
                                  const SizedBox(
                                    height: 19,
                                  ),
                                  const SizedBox(
                                    height: 19,
                                  ),
                                  buildAddress(state),
                                  const SizedBox(
                                    height: 19,
                                  ),
                                  photosDocument(state),
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
                                  buildPhotoLicense(state),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (!state.editingProfile! && !state.editingAdress!),
                      replacement: Padding(
                        child: _saveData(),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
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
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Column buildDataProfileReadOnly(ProfileState state, String phone, String documentId, String birthDate, String extension) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Datos personales ',
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: state.editingProfile == false,
              replacement: GestureDetector(
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  myFocusNode!.unfocus();
                  bloc.add(ProfileEditing(editing: false));
                },
              ),
              child: GestureDetector(
                child: Text(
                  'Editar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(ProfileEditing(editing: true));
                  myFocusNode!.requestFocus();
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        formFieldCustom(state.user!.profile?.firstName ?? "", 'Nombre(s)'),
        formFieldCustom(state.user!.profile?.lastName ?? "", 'Apellido(s)'),
        formFieldCustom(birthDate, 'Fecha de cumpleaños'),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: formFieldCustom(documentId, 'Carnet'),
            ),
            const SizedBox(
              width: 19,
            ),
            Expanded(
              flex: 2,
              child: formFieldCustom(extension, 'Extensión'),
            ),
          ],
        ),
        formFieldCustom(state.user!.profile?.taxId, 'NIT'),
        const SizedBox(
          height: 19,
        ),
        Text(
          'Información de referencia',
          style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 19,
        ),
        formFieldCustom(state.user!.profile?.personReference, 'Contacto de referencia'),
        formFieldCustom(state.user!.profile?.phoneReference, 'Teléfono de referencia'),
      ],
    );
  }

  Widget buildDataProfile(ProfileState state, String phone, String documentId, String birthDate, String extension) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Datos personales ',
                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
              ),
              Visibility(
                visible: state.editingProfile == false,
                replacement: GestureDetector(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    myFocusNode!.unfocus();
                    bloc.add(ProfileEditing(editing: false));
                  },
                ),
                child: GestureDetector(
                  child: Text(
                    'Editar',
                    style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    bloc.add(ProfileEditing(editing: true));
                    myFocusNode!.requestFocus();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          _firstNameField(state.user!.profile?.firstName),
          _lastNameField(state.user!.profile?.lastName),
          _birthDateField(state.user!.profile?.birthDate),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _documentIdField(documentId),
              ),
              const SizedBox(
                width: 19,
              ),
              Expanded(
                flex: 2,
                child: _documentIdExtensionField(),
              ),
            ],
          ),
          _taxIdField(state.user!.profile?.taxId),
          const SizedBox(
            height: 19,
          ),
          Text(
            'Información de referencia',
            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 19,
          ),
          _personReferenceField(state.user!.profile?.personReference),
          _phoneReferenceField(state.user!.profile?.phoneReference),
        ],
      ),
    );
  }

  Widget photosDocument(ProfileState state) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Fotos de carnet',
            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 19,
          ),
          Row(
            children: [
              WidgetPhoto(
                header: false,
                hasTitle: true,
                title: 'Anverso',
                width: constraints.maxWidth * 0.475,
                urlPhoto: state.user?.resources?.photoDocumentIdFront ?? "",
                showModalTitle: 'Foto de carnet anverso',
                type: 'photoDocumentIdFront',
                cameraPhoto: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  File _image;
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                    bloc.add(ProfileUpdateDocumentFront(filePhoto: _image));
                  }
                },
                removePhoto: () {
                  Navigator.of(context).pop();
                  bloc.add(ProfileRemoveResource(type: 'photoDocumentIdFront'));
                },
                galleryPhoto: () async {
                  Navigator.pop(context);
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    bloc.add(ProfileUpdateDocumentFront(filePhoto: file));
                  } else {
                    // User canceled the picker
                  }
                },
              ),
              SizedBox(width: constraints.maxWidth * 0.05),
              WidgetPhoto(
                header: false,
                hasTitle: true,
                title: 'Reverso',
                width: constraints.maxWidth * 0.475,
                urlPhoto: state.user?.resources?.photoDocumentIdReverse ?? "",
                showModalTitle: 'Foto de carnet reverso',
                type: 'photoDocumentIdReverse',
                cameraPhoto: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  File _image;
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                    bloc.add(ProfileUpdateDocumentBack(filePhoto: _image));
                  }
                },
                removePhoto: () {
                  Navigator.of(context).pop();
                  bloc.add(ProfileRemoveResource(type: 'photoDocumentIdReverse'));
                },
                galleryPhoto: () async {
                  Navigator.pop(context);
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    bloc.add(ProfileUpdateDocumentBack(filePhoto: file));
                  } else {
                    // User canceled the picker
                  }
                },
              ),
            ],
          )
        ],
      );
    });
  }

  Widget buildPhotoProfile(ProfileState state) {
    return WidgetPhoto(
      urlPhoto: state.user?.profile?.pathPhoto ?? "",
      showModalTitle: 'Foto de perfil',
      type: 'pathPhoto',
      cameraPhoto: () async {
        Navigator.pop(context);
        final picker = ImagePicker();
        File _image;
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          bloc.add(ProfileUpdatePathPhoto(filePhoto: _image));
        }
      },
      removePhoto: () {
        Navigator.of(context).pop();
        bloc.add(ProfileRemoveResource(type: 'pathPhoto'));
      },
      galleryPhoto: () async {
        Navigator.pop(context);
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null) {
          File file = File(result.files.single.path!);
          bloc.add(ProfileUpdatePathPhoto(filePhoto: file));
        } else {
          // User canceled the picker
        }
      },
    );
  }

  Widget buildPhotoLicense(ProfileState state) {
    return WidgetPhoto(
      urlPhoto: state.user?.resources?.photoLicenseDrivers ?? "",
      showModalTitle: 'Foto de licencia de conducir ',
      type: 'photoLicenseDrivers',
      cameraPhoto: () async {
        Navigator.pop(context);
        final picker = ImagePicker();
        File _image;
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          bloc.add(ProfileUpdateDocumentLicence(filePhoto: _image));
        }
      },
      removePhoto: () {
        Navigator.of(context).pop();
        bloc.add(ProfileRemoveResource(type: 'photoLicenseDrivers'));
      },
      galleryPhoto: () async {
        Navigator.pop(context);
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null) {
          File file = File(result.files.single.path!);
          bloc.add(ProfileUpdateDocumentLicence(filePhoto: file));
        }
      },
    );
  }

  Column buildAddress(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Datos de tu dirección',
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            Visibility(
              visible: state.editingAdress == false,
              replacement: GestureDetector(
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(ProfileAdressEditing(editing: false));
                },
              ),
              child: GestureDetector(
                child: Text(
                  'Editar',
                  style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  bloc.add(ProfileAdressEditing(editing: true));
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 19,
        ),
        Visibility(
          visible: state.editingAdress == false,
          child: Column(
            children: [
              formFieldCustom(state.user!.address?.country, 'País'),
              formFieldCustom(state.user!.address?.states, 'Departamento'),
              formFieldCustom(state.user!.address?.city, 'Ciudad'),
              formFieldCustom(state.user!.address?.street, 'Calle'),
            ],
          ),
        ),
        Visibility(
          visible: state.editingAdress == true,
          child: Column(
            children: [
              CSCPicker(
                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                dropdownItemStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                ),
                selectedItemStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                ),
                dropdownHeadingStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                ),
                selectedState: state.user!.address?.states ?? '',
                selectedCity: state.user!.address?.city ?? '',
                selectedCountry: state.user!.address?.country ?? '',
                dropdownDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
                disabledDropdownDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
                layout: Layout.vertical,
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                  bloc.add(ProfileCountyChanged(country: value));
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value;
                  });
                  bloc.add(ProfileStatesChanged(states: value));
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value;
                  });
                  bloc.add(ProfileCityChanged(city: value));
                },
              ),
              _streetField(state.user!.address?.street),
              // _postalCodeField(state.user!.address?.postalCode),
            ],
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<Departments>> buildDropdownMenuItems(List deparments) {
    List<DropdownMenuItem<Departments>> items = [];
    for (Departments department in deparments as Iterable<Departments>) {
      items.add(
        DropdownMenuItem(
          value: department,
          child: Text(department.id),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Departments? selectedDeparment, BuildContext context) {
    context.read<ProfileBloc>().add(ProfileExtensionDniChanged(departments: selectedDeparment));
  }

  Widget formFieldCustom(String? initialValue, String labelText) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return TextFormFieldGeneric(
          labelText: labelText,
          underline: true,
          readOnly: true,
          enabled: false,
          initialValue: initialValue,
        );
      },
    );
  }

  Widget _firstNameField(String? initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormFieldGeneric(
          labelText: 'Nombre(s)',
          underline: true,
          initialValue: initialValue,
          validator: (value) => state.isValidFirstName ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(ProfileFirstNameChanged(firstName: value)),
        );
      },
    );
  }

  Widget _streetField(String? initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormFieldGeneric(
          initialValue: initialValue,
          underline: true,
          labelText: 'Calle',
          validator: (value) => state.isValidFirstName ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(ProfileStreetChanged(street: value)),
        );
      },
    );
  }

  Widget _lastNameField(String? initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormFieldGeneric(
          initialValue: initialValue,
          labelText: 'Apellido(s)',
          underline: true,
          validator: (value) => state.isValidLastName ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(ProfileLastNameChanged(lastName: value)),
        );
      },
    );
  }

  Widget _saveData() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
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
                      '¿Está seguro de guardar datos de tu perfil?',
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
                            onPressed: () {
                              Navigator.of(context).pop();
                              bloc.add(ProfileUpdateProfileSubmitted(departments: _selectedDeparment));
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

  Widget _personReferenceField(String? initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        // personReferenceController.text = state.personReference;
      },
      builder: (context, state) {
        return TextFormFieldGeneric(
          initialValue: initialValue,
          underline: true,
          labelText: 'Contacto de referencia',
          hintText: 'Ej: Tu esposa.',
          validator: (value) => state.isValidLastName ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(
                ProfilePersonReference(personReference: value),
              ),
        );
      },
    );
  }

  Widget _phoneReferenceField(String? initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormFieldGeneric(
          labelText: 'Teléfono de referencia',
          underline: true,
          initialValue: initialValue,
          validator: (value) => state.isValidLastName ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(ProfilePhoneReference(phoneReference: value)),
        );
      },
    );
  }

  Widget _taxIdField(String? initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormFieldGeneric(
          labelText: 'Nit',
          initialValue: initialValue,
          underline: true,
          validator: (value) => state.isValidLastName ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(ProfileLastTaxId(taxId: value)),
        );
      },
    );
  }

  Widget _documentIdField(String initialValue) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return TextFormFieldGeneric(
          keyboardType: TextInputType.number,
          initialValue: initialValue,
          labelText: 'Carnet de identidad',
          underline: true,
          validator: (value) => state.isValidDocumentId ? null : 'Este campo es requerido',
          onChanged: (value) => context.read<ProfileBloc>().add(ProfileDocumentIdChanged(documentId: value)),
        );
      },
    );
  }

  Widget _documentIdExtensionField() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return DropdownButtonFormFieldGeneric<Departments>(
          labelText: 'Extención',
          underline: true,
          items: _dropdownMenuItems,
          value: state.extensionDocumentId ?? _selectedDeparment,
          onChanged: (departments) {
            onChangeDropdownItem(departments, context);
          },
        );
      },
    );
  }

  Widget _birthDateField(DateTime? birthDate) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.editingProfile!) {
          return GestureDetector(
            onTap: () => _selectDate(),
            child: AbsorbPointer(
              child: TextFormFieldGeneric(
                labelText: 'Fecha de nacimiento',
                underline: true,
                controller: birthDateController,
                validator: (value) => state.isValidBirthDate ? null : 'Este campo es requerido',
              ),
            ),
          );
        } else {
          return TextFormFieldGeneric(
            readOnly: true,
            underline: true,
            enabled: false,
            initialValue: DateFormat('yyyy-MM-dd', 'es_ES').format(birthDate!),
            labelText: 'Fecha de nacimiento',
          );
        }
      },
    );
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
                child: SizedBox(
                  child: CupertinoDatePicker(
                    initialDateTime: _prefsUser.getUser.profile!.birthDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                      birthDateController.text = DateFormat('yyyy-MM-dd', 'es_ES').format(tempPickedDate!);
                      bloc.add(ProfileBirthDateChanged(birthDate: DateFormat('yyyy-MM-dd', 'es_ES').format(tempPickedDate!)));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget formFieldCustom1(String initialValue, String labelText) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return TextFormFieldGeneric(
        initialValue: initialValue,
        readOnly: true,
        underline: true,
        labelText: labelText,
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              initialValue.isNotEmpty ? 'Verificado' : 'No verificado',
              style: TextStyle(fontSize: 14, color: initialValue.isNotEmpty ? const Color(0xff33C766) : Colors.red, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        enabled: false,
      );
    });
  }
}
