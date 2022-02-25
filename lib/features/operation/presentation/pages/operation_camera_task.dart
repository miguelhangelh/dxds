import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
import 'package:appdriver/features/operation/presentation/bloc/operation_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../../main.dart';

class TakePictureScreen extends StatefulWidget {
  final op.Stage? stageActual;
  final op.Task? task;
  final TaskLocal? taskLocal;
  const TakePictureScreen({Key? key, this.stageActual, this.task, this.taskLocal}) : super(key: key);
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<XFile> images = [];
  bool isRecoring = false;
  Future<void>? cameraValue;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  @override
  void initState() {
    super.initState();
    var cameraFront = cameras.firstWhereOrNull((camera) => camera.lensDirection == CameraLensDirection.back);
    if (cameraFront != null) {
      _controller = CameraController(cameraFront, ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CachedNetworkImage widgetImage(XFile file) {
    return CachedNetworkImage(
      imageUrl: file.path,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFD9D9D9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(11),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child:
                CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 5.0, valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
          ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  op.Task? currentTask() {
    var name = widget.stageActual!.tasks!.firstWhereOrNull((element) {
      if (element.action.isNotEmpty) {
        var last = element.action.last;
        if (element.action.isEmpty || last.validation?.approve == false) {
          return true;
        }
        return false;
      } else {
        return true;
      }
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Container(
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
                          CustomSubTitleWidget(
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            text: "Requiere permisos para la camara",
                            color: Colors.black,
                            size: 16.0.sp,
                            //13px
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: Text(
                              '(Reintentar)',
                              style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                            ),
                            onTap: () {
                              _controller = CameraController(
                                // Get a specific camera from the list of available cameras.
                                cameras.first,

                                // Define the resolution to use.
                                ResolutionPreset.medium,
                              );
                              // Next, initialize the controller. This returns a Future.
                              // _controller = CameraController(cameras[0], ResolutionPreset.medium);
                              _initializeControllerFuture = _controller.initialize();
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ));
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_controller),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ),
          Positioned(
            bottom: 110,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.transparent,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,

                padding: const EdgeInsets.only(left: 20),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 1,
                //   childAspectRatio: 1,
                //   mainAxisSpacing: 5,
                //   crossAxisSpacing: 5,
                // ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      images.removeAt(index);
                      setState(() {});
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: primaryColor,
                          // ),
                          borderRadius: const BorderRadius.all(Radius.circular(14)),
                          image: DecorationImage(
                            image: FileImage(File(images[index].path)),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: IconButton(
                            icon: Icon(
                              flash ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                              });
                              // var a = _controller.getMaxZoomLevel();
                              flash ? _controller.setFlashMode(FlashMode.always) : _controller.setFlashMode(FlashMode.off);
                            }),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onLongPress: () async {
                            // await _controller.startVideoRecording();
                            // setState(() {
                            //   isRecoring = true;
                            // });
                          },
                          onLongPressUp: () async {
                            // XFile videopath =
                            // await _controller.stopVideoRecording();
                            // setState(() {
                            //   isRecoring = false;
                            // });
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => VideoViewPage(
                            //           path: videopath.path,
                            //         )));
                          },
                          onTap: () async {
                            try {
                              await _initializeControllerFuture;
                              final image = await _controller.takePicture();
                              images.add(image);
                              setState(() {
                                images = images;
                              });
                            } catch (_) {}
                          },
                          child: isRecoring
                              ? const Icon(
                                  Icons.radio_button_on,
                                  color: Colors.red,
                                  size: 80,
                                )
                              : const Icon(
                                  Icons.panorama_fish_eye,
                                  color: Colors.white,
                                  size: 70,
                                ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    "Toca para tomar foto",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: images.isNotEmpty,
            child: Positioned(
              bottom: 210,
              right: 20,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    List<String> files = [];
                    images.forEach((element) {
                      files.add(element.path);
                    });

                    if (widget.taskLocal != null) {
                      // var current = currentTask();
                      context.read<OperationBloc>().add(AddFileEventUpdate(
                            idStage: widget.taskLocal!.idStage,
                            file: files,
                            loadingOrderId: widget.taskLocal!.loadingOrderId,
                            idTask: widget.taskLocal!.id,
                            task: widget.task!,
                          ));
                    } else {
                      // op.Task taskNew = op.Task(
                      //   id: widget.task!.id,
                      //   action: [],
                      //   allow: null,
                      //   allowFiles: widget.task!.allowFiles,
                      //   changeStage: widget.task!.changeStage,
                      //   emailNotification: widget.task!.emailNotification,
                      //   name: widget.task!.name,
                      //   order: widget.task!.order,
                      //   pushNotification: widget.task!.pushNotification,
                      //   smsNotification: widget.task!.pushNotification,
                      //   viewCarrier: widget.task!.viewCarrier,
                      //   viewClient: widget.task!.viewClient,
                      //   taskId: widget.task!.taskId,
                      // );
                      context.read<OperationBloc>().add(
                            AddFileEvent(
                              idStage: widget.stageActual!.id,
                              file: files,
                              loadingOrderId: widget.stageActual!.loadingOrderId,
                              idTask: widget.task!.id,
                              task: widget.task!,
                            ),
                          );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            color: primaryColor,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 25,
                          )),
                      Positioned(
                        right: 10,
                        bottom: 8,
                        child: Text(
                          images.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget removeResource(List<XFile> images, index, type) {
    return FloatingActionButton(
      heroTag: index ?? "",
      child: const Icon(
        Icons.close,
        color: Colors.red,
      ),
      onPressed: () async {
        images.removeAt(index);
        setState(() {});
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      backgroundColor: Colors.white,
      mini: true,
      elevation: 5.0,
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: const Text(''),
    );
  }
}
