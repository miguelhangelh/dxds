import 'package:appdriver/core/utils/animation.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/dialogs.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/operation/presentation/bloc/operation_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as operation;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'operation_camera_task.dart';

class TaskOperationV2 extends StatefulWidget {
  final OperationState operation;
  const TaskOperationV2({Key? key, required this.operation}) : super(key: key);

  @override
  _TaskOperationV2State createState() => _TaskOperationV2State();
}

class _TaskOperationV2State extends State<TaskOperationV2> {
  @override
  Widget build(BuildContext context) {
    OperationState stages = widget.operation;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.white,
      child: ListView.builder(
        itemCount: stages.tasks!.length,
        padding: const EdgeInsets.only(left: 20, top: 20),
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var item = stages.tasks![index];
          var isCurrent = isCurrentTask(item, stages);
          if (isCurrent) {
            return buildCurrentTask(context, item, stages, index);
          } else {
            var tasks = stages.tasksLocal!.toList();
            var taskValidate = tasks.firstWhereOrNull((element) => item.id == element.id);
            if (taskValidate != null) {
              if (taskValidate.state == 2) {
                return GestureDetector(
                  onTap: () async {
                    await uploadFilePending(context, item, taskValidate);
                  },
                  child: buildItemTask(item, index, stages, taskValidate.state),
                );
              } else {
                return buildItemTask(item, index, stages, taskValidate.state);
              }
            } else {
              if (item.action.isNotEmpty) {
                return buildItemTask(item, index, stages, 0);
              }
            }
          }
          return Container();
        },
      ),
    );
    // late operation.Task currentTask;
    // List<operation.Stage> stages = widget.operation.stages!.toList();
    // for (final element in stages) {
    //   var name = element.tasks!.firstWhereOrNull((task) {
    //     if (task.action.isNotEmpty) {
    //       var last = task.action.last;
    //       if (last.validation?.approve == false) {
    //         return true;
    //       }
    //       return false;
    //     } else {
    //       return true;
    //     }
    //   });
    //   if (name != null) {
    //     currentTask = name;
    //     break;
    //   }
    // }
    // tasklist.add(currentTask);
    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   height: MediaQuery.of(context).size.height,
    //   padding: const EdgeInsets.only(right: 20),
    //   color: Colors.white,
    //   child: ListView.builder(
    //     itemCount: widget.operation.tasks!.length,
    //     padding: const EdgeInsets.only(left: 20, top: 20),
    //     scrollDirection: Axis.vertical,
    //     physics: BouncingScrollPhysics(),
    //     itemBuilder: (BuildContext context, int index) {
    //       var item = widget.operation.tasks![index];
    //       if(isCurrentTask(item)){
    //         return GestureDetector(
    //           onTap: () {
    //             await uploadFile(context);
    //           },
    //           child: Container(
    //             height: 60,
    //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //             margin: const EdgeInsets.only(bottom: 20),
    //             decoration: BoxDecoration(
    //               color: isCurrentTask(item) ? primaryColor : Colors.black,
    //               borderRadius: BorderRadius.circular(15.0),
    //             ),
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Text(
    //                       item.name ?? "",
    //                       style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Icon(
    //                       Icons.send,
    //                       color: Colors.white,
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       }else{
    //
    //       }
    //      return Container();
    //     },
    //   ),
    // );
  }

  bool isCurrentTask(operation.Task item, stages) {
    var currentTask = stages.currentTask;
    if (currentTask != null) {
      if (item.id == currentTask.id) {
        return true;
      }
      return false;
    }
    return false;
  }

  Color getColorTask(state) {
    late Color color = Colors.white;
    if (state == 1) {
      color = const Color(0xffF3F1F5);
    }
    if (state == 0) {
      color = const Color(0xffF3F1F5);
    }
    if (state == 2) {
      color = const Color(0xfff7e7a5);
    }
    return color;
  }

  IconData getIconTask(state) {
    late IconData color = Icons.timelapse;
    if (state == 1) {
      color = color;
    }
    if (state == 0) {
      color = Icons.done;
    }
    if (state == 2) {
      color = Icons.warning_amber_outlined;
    }
    return color;
  }

  String getStateTask(state) {
    String stateText = "Pendiente";
    if (state == 1) {
      stateText = stateText;
    }
    if (state == 0) {
      stateText = "Tarea realizada ";
    }
    if (state == 2) {
      stateText = "Tarea pendiente ";
    }
    return stateText;
  }

  bool isLastIndex(index, list) {
    if (index == list.length - 1) {
      return false;
    }
    return true;
  }

  String getDateAction(operation.Task task) {
    final outputFormat = DateFormat("EEEE d, MMMM");
    var a = DateTime.now();
    var lastA = task.action.isNotEmpty;
    if (lastA) {
      var lastAc = task.action.last;
      var as = lastAc.dateAction!.toLocal();
      var ac = outputFormat.format(as);
      String formattedDate = DateFormat.jm().format(as);
      // var string = outputFormat.parse(formattedDate, true).toLocal();
      return ac;
    }
    return "";
  }

  bool rejected(operation.Task name) {
    if (name.action.isNotEmpty) {
      var last = name.action.last;
      if (last.validation?.approve == false) {
        return true;
      }
    }
    return false;
  }

  String rejectedComment(operation.Task name) {
    if (name.action.isNotEmpty) {
      var last = name.action.last;
      if (last.validation?.approve == false) {
        return last.comment ?? "";
      }
    }
    return "";
  }

  bool finalizedOperation(List<operation.Task> list) {
    bool finalized = false;
    // var finalized = list.every((task) {
    //   if (task.action.isNotEmpty) {
    //     var lastAction = task.action.last;
    //     if (lastAction.validation?.approve == false) {
    //       return false;
    //     }
    //   } else if (task.action.isEmpty) {
    //     return false;
    //   } else {
    //     return true;
    //   }
    //   return false;
    // });
    // return finalized;
    for (final task in list) {
      if (task.action.isNotEmpty) {
        var lastAction = task.action.last;
        if (lastAction.validation?.approve == false) {
          finalized = false;
          break;
        } else {
          finalized = true;
        }
      } else if (task.action.isEmpty) {
        finalized = false;
        break;
      } else {
        finalized = true;
      }
    }
    return finalized;
  }

  buildCurrentTask(BuildContext context, operation.Task item, OperationState stages, int index) {
    return GestureDetector(
      onTap: () async {
        await uploadFile(context, item, stages.currentStage);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZoomIn(
            child: Tooltip(
              message: "Enviar tarea",
              child: Container(
                height: rejected(item) ? 100 : 80,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.name ?? "",
                              style: TextStyle(color: Colors.white, fontSize: 12.0.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Visibility(
                          visible: rejected(item),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 15.0.sp,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                RoundedButton(
                                  label: 'Ver comentario…',
                                  fullWidth: false,
                                  padding: EdgeInsets.zero,
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 30,
                                  textColor: Colors.white,
                                  borderColor: Colors.transparent,
                                  onPressed: () async {
                                    await showModalBottomSheetComments(context, item);
                                    // _launchInBrowser(widget.newItem.link!, context);
                                  },
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        SizedBox(width: 10),
                        Icon(Icons.send, color: Colors.white),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(visible: isLastIndex(index, stages.tasks!), child: buildPoints()),
        ],
      ),
    );
  }

  Column buildItemTask(operation.Task item, int index, OperationState stages, state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZoomIn(
          child: Tooltip(
            message: getStateTask(state),
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: finalizedOperation(stages.tasks!) ? const EdgeInsets.only(left: 0) : const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: getColorTask(state),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name ?? "",
                            style: TextStyle(color: Colors.black, fontSize: 12.0.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Visibility(
                        replacement: Container(),
                        visible: state == 0,
                        child: Row(
                          children: [
                            Text(
                              getDateAction(item),
                              style: TextStyle(color: Colors.black, fontSize: 10.0.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        replacement: Container(),
                        visible: state == 2,
                        child: Row(
                          children: [
                            Text(
                              "Pendiente",
                              style: TextStyle(color: Colors.black, fontSize: 10.0.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        getIconTask(state),
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(visible: isLastIndex(index, stages.tasks!), child: buildPoints()),
      ],
    );
  }

  Container buildPoints() {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(left: 60),
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: SizedBox(
        height: 25,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              children: List.generate(
                (constraints.constrainWidth() / 50).floor(),
                (index) => SizedBox(
                  height: 2.5,
                  width: 2.5,
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xff7F7C82), shape: BoxShape.circle),
                  ),
                ),
              ),
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            );
          },
        ),
      ),
    );
  }

  Future showModalBottomSheetComments(BuildContext context, operation.Task task) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    width: 100,
                    color: const Color(0xffababab),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    rejectedComment(task),
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff242424),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> uploadFilePending(
    BuildContext context,
      operation.Task item,
      TaskLocal taskLocal,
  ) async {
    if (taskLocal.allowFiles!) {
      await showModalCameraPending(context, taskLocal,item);
    } else {
      await ModalBottomSheet.show(
        context: context,
        isScrollControlled: true,
        children: <Widget>[
          Container(
            height: 5,
            width: 100,
            color: const Color(0xffe2e8f0),
          ),
          const SizedBox(height: 20),
          CustomSubTitleWidget(
            text: 'Actividad Actual',
            size: 14.0.sp,
            padding: const EdgeInsets.only(left: 0.0),
            fontWeight: FontWeight.w500,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
          ),
          Text(
            item.name ?? "",
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          CustomTextArea(
            textController: BlocProvider.of<OperationBloc>(context).textComments,
            label: 'Observaciones (Opcional)',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RoundedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<OperationBloc>().add(
                          AddFileEventPending(
                            idStage: taskLocal.idStage,
                            loadingOrderId: taskLocal.loadingOrderId,
                            idTask: taskLocal.id,
                            task: item,
                          ),
                        );
                    await Dialogs.alert(
                      context,
                      title: 'Advertencia',
                      description: 'Acabas de omitir la tarea, por favor no te olvides de realizarla cuando cumplas con los requisitos',
                    );
                  },
                  label: 'Omitir',
                  backgroundColor: const Color(0xffFAFAFA),
                  borderColor: const Color(0xffD9D9D9),
                  textColor: Colors.black,
                ),
              ),
              const SizedBox(width: 19),
              Expanded(
                child: RoundedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<OperationBloc>().add(AddFileEventUpdate(
                          idStage: taskLocal.id,
                          file: [],
                          loadingOrderId: taskLocal.loadingOrderId,
                          idTask: taskLocal.id,
                          task: item,
                        ));
                  },
                  label: 'Continuar',
                ),
              )
            ],
          ),
        ],
      );
      // bloc.add(AddFileEvent(
      //   idStage: stageActual.id,
      //   file: [],
      //   loadingOrderId: stageActual.loadingOrderId,
      //   idTask: stageActual.tasks.firstWhere((element) => element.action.isEmpty).id,
      //   task: stageActual.tasks.firstWhere((element) => element.action.isEmpty, orElse: () => null),
      // ));
    }
    //
  }

  Future<void> uploadFile(
    BuildContext context,
    operation.Task item,
    operation.Stage? currentStage,
  ) async {
    if (item.allowFiles!) {
      await showModalCamera(context, item);
    } else {
      await ModalBottomSheet.show(
        context: context,
        isScrollControlled: true,
        children: <Widget>[
          Container(
            height: 5,
            width: 100,
            color: const Color(0xffe2e8f0),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomSubTitleWidget(
            text: 'Actividad Actual',
            size: 14.0.sp,
            padding: const EdgeInsets.only(left: 0.0),
            fontWeight: FontWeight.w500,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
          ),
          Text(
            item.name ?? "",
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          CustomTextArea(
            textController: context.read<OperationBloc>().textComments,
            label: 'Observaciones (Opcional)',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RoundedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<OperationBloc>().add(
                          AddFileEventPending(
                            idStage: currentStage?.id,
                            loadingOrderId: currentStage?.loadingOrderId,
                            idTask: item.id,
                            task: item,
                          ),
                        );
                    await Dialogs.alert(
                      context,
                      title: 'Advertencia',
                      description: 'Acabas de omitir la tarea, por favor no te olvides de realizarla cuando cumplas con los requisitos',
                    );
                  },
                  label: 'Omitir',
                  backgroundColor: const Color(0xffFAFAFA),
                  borderColor: const Color(0xffD9D9D9),
                  textColor: Colors.black,
                ),
              ),
              const SizedBox(
                width: 19,
              ),
              Expanded(
                child: RoundedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<OperationBloc>().add(AddFileEvent(
                          idStage: currentStage?.id,
                          file: [],
                          loadingOrderId: currentStage?.loadingOrderId,
                          idTask: item.id,
                          task: item,
                        ));
                  },
                  label: 'Continuar',
                ),
              )
            ],
          ),
        ],
      );
      // bloc.add(AddFileEvent(
      //   idStage: stageActual.id,
      //   file: [],
      //   loadingOrderId: stageActual.loadingOrderId,
      //   idTask: stageActual.tasks.firstWhere((element) => element.action.isEmpty).id,
      //   task: stageActual.tasks.firstWhere((element) => element.action.isEmpty, orElse: () => null),
      // ));
    }
    //
  }

  Future<void> showModalCamera(BuildContext context, operation.Task item) async {
    var taskCurrent = widget.operation.currentTask;
    ModalBottomSheet.show(
      context: context,
      children: <Widget>[
        Container(
          height: 5,
          width: 100,
          color: const Color(0xffe2e8f0),
        ),
        const SizedBox(height: 20),
        CustomSubTitleWidget(
          text: 'Actividad Actual',
          size: 14.0.sp,
          padding: const EdgeInsets.only(left: 0.0),
          fontWeight: FontWeight.w500,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        Text(
          taskCurrent?.name ?? "",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 19,
        ),
        CustomTextArea(
          textController: context.read<OperationBloc>().textComments,
          label: 'Observaciones (Opcional)',
        ),
        const SizedBox(height: 19),
        Row(
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<OperationBloc>().add(
                          AddFileEventPending(
                            idStage: widget.operation.currentStage!.id,
                            loadingOrderId: widget.operation.currentStage!.loadingOrderId,
                            idTask: taskCurrent?.id,
                            task: taskCurrent,
                          ),
                        );
                    await Dialogs.alert(
                      context,
                      title: 'Advertencia',
                      description: 'Acabas de omitir la tarea, por favor no te olvides de realizarla cuando cumplas con los requisitos',
                    );
                  },
                  child: const Icon(Icons.next_plan, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Omitir',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: true,
                    );
                    if (result != null) {
                      List<String> files = List<String>.from(result.paths.where((element) => element != null));
                      context.read<OperationBloc>().add(AddFileEvent(
                            idStage: widget.operation.currentStage!.id,
                            file: files,
                            loadingOrderId: widget.operation.currentStage!.loadingOrderId,
                            idTask: taskCurrent?.id,
                            task: taskCurrent,
                          ));
                    } else {}
                  },
                  child: const Icon(Icons.add_to_photos, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Galería',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute<TakePictureScreen>(
                        builder: (_) => BlocProvider.value(
                          value: context.read<OperationBloc>(),
                          child: TakePictureScreen(stageActual: widget.operation.currentStage, task: taskCurrent, ),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Cámara',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> showModalCameraPending(BuildContext context,TaskLocal taskLocal  , operation.Task item) async {
    var taskCurrent = widget.operation.currentTask;
    ModalBottomSheet.show(
      context: context,
      children: <Widget>[
        Container(
          height: 5,
          width: 100,
          color: const Color(0xffe2e8f0),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomSubTitleWidget(
          text: 'Actividad Actual',
          size: 14.0.sp,
          padding: const EdgeInsets.only(left: 0.0),
          fontWeight: FontWeight.w500,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        Text(
          item.name ?? "",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 19,
        ),
        CustomTextArea(
          textController: context.read<OperationBloc>().textComments,
          label: 'Observaciones (Opcional)',
        ),
        const SizedBox(
          height: 19,
        ),
        Row(
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    await Dialogs.alert(
                      context,
                      title: 'Advertencia',
                      description: 'Acabas de omitir la tarea, por favor no te olvides de realizarla cuando cumplas con los requisitos',
                    );
                  },
                  child: const Icon(Icons.next_plan, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Omitir',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: true,
                    );
                    if (result != null) {
                      List<String> files = List<String>.from(result.paths.where((element) => element != null));
                      context.read<OperationBloc>().add(AddFileEventUpdate(
                            idStage: taskLocal.id,
                            file: files,
                            loadingOrderId:taskLocal.loadingOrderId,
                            idTask: taskLocal.id,
                            task: item,
                          ));
                    } else {}
                  },
                  child: const Icon(Icons.add_to_photos, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Galería',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute<TakePictureScreen>(
                        builder: (_) => BlocProvider.value(
                          value: context.read<OperationBloc>(),
                          child: TakePictureScreen(
                            taskLocal: taskLocal,
                            task: item,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    primary: primaryColor, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Cámara',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
