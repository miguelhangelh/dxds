import 'dart:async';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/font_styles.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/notification/presentation/widgets/web_view_news.dart';
import 'package:appdriver/features/operation/presentation/pages/operation_page.dart';
import 'package:appdriver/features/profile/presentation/bloc/form_submission_status.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:sizer/sizer.dart';

class ContractProfilePage extends StatefulWidget {
  const ContractProfilePage({Key? key}) : super(key: key);

  @override
  _ContractProfilePageState createState() => _ContractProfilePageState();
}

class _ContractProfilePageState extends State<ContractProfilePage> {
  final ProfileBloc bloc = sl<ProfileBloc>();
  UserPreference userPreference = UserPreference();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    bloc.stream.listen(
      (state) {
        if (state.formStatus is SubmissionSuccess) {
          NavigatorExtension.pushAndRemoveUntil(const OperationPage(), context);
        }
      },
    );
    // bloc.add(DownloadPDF());
  }

  @override
  Widget build(BuildContext context) {
    final String nombre = userPreference.getUser.profile?.firstName ?? "";
    final String apellido = userPreference.getUser.profile?.lastName ?? "";
    final String documentIdData = userPreference.getUser.profile?.documentId?.split("_").first ?? "";
    var url = 'https://www.deltaxbeta.com/contract/$nombre $apellido/$documentIdData/$documentIdData';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // For both Android + iOS

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider<ProfileBloc>(
          create: (context) => bloc,
          child: SafeArea(child: _profileForm(url)),
        ),
      ),
    );
  }

  Widget _profileForm(String url) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: WebViewContainer(
                        url: url,
                      ),
                    ),
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text("He leído y acepto las condiciones"),
                            value: state.signedContract,
                            onChanged: (newValue) {
                              bloc.add(ProfileSignedContract(signedContract: newValue!));
                            },
                            controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state.signedContract!,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          _signUpButton(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Expanded(
        child: RoundedButton(
          loading: state.formStatus is FormSubmitting ? true : false,
          onPressed: () {
            // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
            bloc.add(ProfileContractSubmitted());
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => const Scaffold(
            //         body: DoubleBackToCloseApp(
            //           snackBar: SnackBar(
            //             content: Text('Toca de nuevo para salir'),
            //           ),
            //           child: SignatureProfilePage(),
            //         ),
            //       ),
            //     ),
            //     (Route<dynamic> route) => false);
          },
          label: 'Continuar',
        ),
      );
    });
  }

  // Widget _showButton(BuildContext context) {
  //   return SafeArea(
  //     child: TextButton(
  //       child: Text('Already have an account? Sign in.'),
  //       onPressed: () => context.read<AuthCubit>().showLogin(),
  //     ),
  //   );
  // }
  _selectDate() async {
    await showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      builder: (context) {
        DateTime? tempPickedDate;
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('omitir'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('continuar'),
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
                child: Container(
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime(1980),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                      bloc.add(
                        ProfileBirthDateChanged(birthDate: DateFormat('yyyyMMdd', 'es_ES').format(tempPickedDate!)),
                      );
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
}
//
// class PDFScreen extends StatefulWidget {
//   final String? path;
//
//   PDFScreen({Key? key, this.path}) : super(key: key);
//
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             enableSwipe: true,
//             swipeHorizontal: true,
//             autoSpacing: false,
//             pageFling: true,
//             pageSnap: true,
//             defaultPage: currentPage!,
//             fitPolicy: FitPolicy.BOTH,
//             preventLinkNavigation: false, // if set to true the link is handled in flutter
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//             onLinkHandler: (String? uri) {
//               print('goto uri: $uri');
//             },
//             onPageChanged: (int? page, int? total) {
//               print('page change: $page/$total');
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//                   ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : Container()
//               : Center(
//                   child: Text(errorMessage),
//                 )
//         ],
//       ),
//       floatingActionButton: FutureBuilder<PDFViewController>(
//         future: _controller.future,
//         builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//           if (snapshot.hasData) {
//             return FloatingActionButton.extended(
//               label: Text("Go to ${pages! ~/ 2}"),
//               onPressed: () async {
//                 print(pages! ~/ 2);
//                 await snapshot.data!.setPage(pages! ~/ 2);
//               },
//             );
//           }
//
//           return Container();
//         },
//       ),
//     );
//   }
// }
