// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:amplify_flutter/amplify.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'package:appdriver/core/share_prefs/user_pref.dart';
// import 'package:appdriver/core/utils/colors.dart';
// import 'package:appdriver/core/utils/functions.dart';
// import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
// import 'package:appdriver/global_widgets/global_widget.dart';
// import 'package:appdriver/injection_container.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:hand_signature/signature.dart';
// import 'package:sizer/sizer.dart';
//
// class SignatureProfilePage extends StatefulWidget {
//   const SignatureProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _SignatureProfilePageState createState() => _SignatureProfilePageState();
// }
//
// class _SignatureProfilePageState extends State<SignatureProfilePage> {
//   final ProfileBloc bloc = sl<ProfileBloc>();
//   UserPreference userPreference = UserPreference();
//   @override
//   void initState() {
//     super.initState();
//     bloc.add(DownloadPDF());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BlocProvider<ProfileBloc>(
//         create: (context) => bloc,
//         child: SafeArea(child: _profileForm()),
//       ),
//     );
//   }
//
//   Widget _profileForm() {
//     return BlocBuilder<ProfileBloc, ProfileState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Stack(
//                           children: <Widget>[
//                             Container(
//                               width: 100.0.w,
//                               height: 100.0.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(14),
//                                 color: Colors.white,
//                               ),
//                               constraints: const BoxConstraints.expand(),
//                               child: HandSignaturePainterView(
//                                 control: bloc.control,
//                                 width: 1.0,
//                                 maxWidth: 5.0,
//                                 type: SignatureDrawType.shape,
//                               ),
//                             ),
//                             Positioned(
//                               top: 0,
//                               left: 0,
//                               child: Container(
//                                 width: 5,
//                                 height: 40,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: 0,
//                               left: 0,
//                               child: Container(
//                                 width: 40,
//                                 height: 5,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 40,
//                                 height: 5,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 5,
//                                 height: 40,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 5,
//                                 height: 40,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     bottomRight: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 40,
//                                 height: 5,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     bottomRight: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               child: Container(
//                                 width: 40,
//                                 height: 5,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               child: Container(
//                                 width: 5,
//                                 height: 40,
//                                 decoration: const BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(14),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: RoundedButton(
//                             backgroundColor: const Color(0xffFAFAFA),
//                             borderColor: const Color(0xffD9D9D9),
//                             textColor: Colors.black,
//                             // loading: state.formStatus is FormSubmitting ? true : false,
//                             onPressed: () async {
//                               bloc.control.clear();
//                             },
//                             label: 'Limpiar',
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: RoundedButton(
//                             onPressed: () async {
//                               ByteData? byte = await bloc.control.toImage();
//                               File filedata = await writeToFile(byte!);
//                               S3UploadFileOptions options = S3UploadFileOptions(
//                                 accessLevel: StorageAccessLevel.guest,
//                               );
//                               UploadFileResult resp =
//                                   await Amplify.Storage.uploadFile(key: 'MiguelFIRMA' + 'deltax', local: filedata, options: options);
//                             },
//                             label: 'Continuar',
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
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
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//             onLinkHandler: (String? uri) {
//             },
//             onPageChanged: (int? page, int? total) {
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//                   ? const Center(
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