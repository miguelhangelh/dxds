import 'package:flutter/material.dart';
import 'package:appdriver/core/utils/utils.dart' show Responsive;
import 'package:appdriver/features/operation/data/models/operation_model.dart' as operat;
import 'package:appdriver/global_widgets/global_widget.dart' show CustomSubTitleWidget;

class StateOperationPage extends StatefulWidget {
  final List<operat.Stage>? stages;
  StateOperationPage({Key? key, required this.stages}) : super(key: key);

  @override
  _StateOperationPageState createState() => _StateOperationPageState();
}

class _StateOperationPageState extends State<StateOperationPage> {
  late Responsive _responsive;
  ScrollController _controllerStateOperation = new ScrollController();
  int _indexSelected = -1;
  bool stageDone = false;
  bool finalized = false;
  @override
  void initState() {
    super.initState();
  }

  _activeStage() {
    int _index = -1;
    for (var index = 0; index < widget.stages!.length; index++) {
      int quantityDoneTask = 0;
      var tasks = widget.stages![index].tasks!;
      for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].action.isNotEmpty) {
          quantityDoneTask++;
        }
      }
      if (quantityDoneTask == tasks.length) {
        _index = index;
      }
    }
    _indexSelected = _index;
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive.of(context);
    return Container(
      width: _responsive.width,
      padding: const EdgeInsets.only(
        top: 0.0,
        bottom: 0.0,
        right: 0.0,
      ),
      height: 70.0,
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.stages!.length,
        controller: _controllerStateOperation,
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          // this._activeStage();
          final _state = widget.stages![index];
          return Column(
            children: [_loadStateOperation(_state, index)],
          );
        },
      ),
    );
  }

  Widget _loadStateOperation(operat.Stage state, int index) {
    if (index + 1 == widget.stages!.length) {
      return SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    //  await  _controllerStateOperation.animateTo(  (97.0 * index) ,
                    //     curve: Curves.linear, duration: Duration(milliseconds: 2000, )
                    //   );
                    // state.tasks.contains('action') = !state.tasks.contains('action');
                    // setState(() {

                    // });
                  },
                  child: Container(
                      padding: const EdgeInsets.only(
                        left: 7.0,
                      ),
                      child: Container(
                        width: 38.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: ((_validateState(state, index) ? Colors.black : Colors.transparent)),
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                            width: 2.0,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: ((_validateState(state, index) ? Colors.white : Colors.transparent)),
                        ),
                      )

                      // Icon(
                      //     (_validateState(state, index) ? Icons.check_circle : Icons.radio_button_unchecked),
                      //     color: (_validateState(state, index)
                      //         ? Colors.black
                      //         : ((_indexSelected + 1 == index))
                      //             ? Colors.black
                      //             : const Color(0xFF989898)),
                      //     size: 40.0,
                      //   ),
                      ),
                )
              ],
            ),
                   const SizedBox(
              height: 7,
            ),
            CustomSubTitleWidget(
              text: state.name,
              size: 11,
              padding: const EdgeInsets.only(left: 2.0),
              fontWeight: (_validateState(state, index) ? FontWeight.w600 : FontWeight.w500),
              color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  //  await  _controllerStateOperation.animateTo(  (97.0 * index) ,
                  //    curve: Curves.linear, duration: Duration(milliseconds: 2000, )
                  //    );

                  // state.tasks.contains('action') = !sstate.tasks.contains('action');
                  setState(() {});
                },
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 7.0,
                    ),
                    child: Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: ((_validateState(state, index) ? Colors.black : Colors.transparent)),
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                          width: 2.0,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: ((_validateState(state, index) ? Colors.white : Colors.transparent)),
                      ),
                    )
                    // Icon(
                    //     (_validateState(state, index)
                    //         ? Icons.check_circle
                    //         : Icons.radio_button_unchecked),
                    //     color: (_validateState(state, index)
                    //         ? Colors.black
                    //         : ((_indexSelected + 1 == index))
                    //             ? Colors.black
                    //             : const Color(0xFF989898)),
                    //     size: 40.0,
                    //   ),
                    ),
              ),
              Container(
                color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                height: 2.5,
                width: 7.0,
              ),
              Container(
                width: 4,
              ),
              Container(
                color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                height: 2.5,
                width: 7.0,
              ),
              Container(
                width: 4,
              ),
              Container(
                color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                height: 2.5,
                width: 7.0,
              ),
              Container(
                width: 4,
              ),
              Container(
                color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                height: 2.5,
                width: 7.0,
              ),
              Container(
                width: 4,
              ),
              Container(
                color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                height: 2.5,
                width: 7.0,
              ),
              Container(
                width: 4,
              ),
              Container(
                color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
                height: 2.5,
                width: 7.0,
              ),
            ],
          ),
                   const SizedBox(
            height: 7,
          ),
          CustomSubTitleWidget(
            text: state.name,
            size: 11,
            padding: const EdgeInsets.only(left: 0.0),
            fontWeight: (_validateState(state, index) ? FontWeight.w600 : FontWeight.w500),
            color: (_validateState(state, index) ? Colors.black : const Color(0xFF989898)),
          ),
        ],
      ),
    );
  }

  bool _validateState(operat.Stage state, int index) {
    finalized = false;
    List<operat.Task> tasks = state.tasks!;
    int quantityDoneTask = 0;
    var stages = widget.stages!;
    operat.Stage? next;
    operat.Stage? prev;
    operat.Stage current = state;
    bool nextStateTaskIsEmpty = true;
    bool prevStateTaskIsEmpty = true;

    if (index - 1 > -1) {
      prev = stages[index - 1];
      prevStateTaskIsEmpty = prev.tasks!.isEmpty;
    }
    if (index + 1 < stages.length) {
      next = stages[index + 1];
      nextStateTaskIsEmpty = next.tasks!.isEmpty;
    }
    var task = stages[index].tasks!;
    var stateLast = stages.last;
    var stateFirst = stages.first;
    var currentStateTaskIsEmpty = task.isEmpty;
    // print('PREV: ${prev?.name} NO_TIENE_TAREAS : $prevStateTaskIsEmpty');
    // print('CURRENT: ${current.name} NO_TIENE_TAREAS : $currentStateTaskIsEmpty');
    // print('NEXT: ${next?.name} NOT_TIENE_TAREAS : $nextStateTaskIsEmpty');
    int quantityDondeState = 0;
    widget.stages!.forEach((state) {
      var isTask = state.tasks!.isEmpty;
      var isCompleteCurrent = false;
      isCompleteCurrent = state.tasks?.every((element) => element.action.isNotEmpty) ?? false;
      if (isCompleteCurrent || isTask) {
        quantityDondeState++;
      }
    });
    if (quantityDondeState == widget.stages!.length) {
      finalized = true;
    }
    if (!finalized) {
      var isCompleteCurrentLast = stateLast.tasks?.any((element) => element.action.isNotEmpty) ?? false;
      if (isCompleteCurrentLast) {
        if (current.id == stateLast.id) {
          var isCompleteCurrentLast = stateLast.tasks?.every((element) => element.action.isNotEmpty) ?? false;
          if (isCompleteCurrentLast) {
            return true;
          }
          return false;
        }
        return true;
      }
      // var isCompleteCurrent = false;
      // if (current.tasks!.isNotEmpty) {
      //   isCompleteCurrent = current.tasks?.every((element) => element.action.isNotEmpty) ?? false;
      // }
      // if (isCompleteCurrent) {
      //   return true;
      // }
      // return false;

      ///todo: EL ACTUAL TIENE TAREAS , EL SIGUIENTE NO TIENE TAREAS, no existe anterior
      if (currentStateTaskIsEmpty == false && nextStateTaskIsEmpty == true && next != null && prev == null) {
        var isCompleteCurrent = current.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        if (isCompleteCurrent) {
          return true;
        }
        return false;
      }
      if (currentStateTaskIsEmpty == true && nextStateTaskIsEmpty == false && next != null && prev == null) {
        // if(current.tasks!.isNotEmpty){
        var isCompleteNext = next.tasks!.every((element) => element.action.isNotEmpty);
        if (isCompleteNext) {
          return true;
        }
        return false;
      }
      if (currentStateTaskIsEmpty == false && nextStateTaskIsEmpty == false && next != null && prev == null) {
        var isCompleteCurrent = current.tasks!.every((element) => element.action.isNotEmpty);
        if (isCompleteCurrent) {
          return true;
        }
        return false;
      }

      ///TODO:EL ESTADO ANTERIOR NO TIENE TAREAS, EL ACTUAL NO TIENE TAREAS , EL SIGUIENTE NO TIENE TAREAS
      else if (prevStateTaskIsEmpty == true && currentStateTaskIsEmpty == true && nextStateTaskIsEmpty == true && next != null && prev != null) {
        return true;
      }

      ///TODO:EL ESTADO ANTERIOR TIENE TAREAS, EL ACTUAL TIENE TAREAS , EL SIGUIENTE NO TIENE TAREAS
      else if (prevStateTaskIsEmpty == false && currentStateTaskIsEmpty == false && nextStateTaskIsEmpty == true && next != null && prev != null) {
        var isCompleteCurrent = current.tasks!.every((element) => element.action.isNotEmpty);
        var isCompletePrev = prev.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        if (isCompleteCurrent && isCompletePrev) {
          return true;
        }
        return false;
      } else if (prevStateTaskIsEmpty == true && currentStateTaskIsEmpty == false && nextStateTaskIsEmpty == true && next != null && prev != null) {
        var isCompleteCurrent = current.tasks!.every((element) => element.action.isNotEmpty);
        if (isCompleteCurrent) {
          return true;
        }
        return false;
      }

      ///TODO:EL ESTADO ANTERIOR TIENE TAREAS, EL ACTUAL TIENE TAREAS , EL SIGUIENTE TIENE TAREAS
      else if (prevStateTaskIsEmpty == false && currentStateTaskIsEmpty == false && nextStateTaskIsEmpty == false && next != null && prev != null) {
        var isCompleteCurrent = current.tasks!.every((element) => element.action.isNotEmpty);
        var isCompletePrev = prev.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        if (isCompleteCurrent && isCompletePrev) {
          return true;
        }
        return false;
      }

      ///TODO:EL ESTADO ANTERIOR TIENE TAREAS, EL ACTUAL no TIENE TAREAS , EL SIGUIENTE no TIENE TAREAS
      else if (prevStateTaskIsEmpty == false && currentStateTaskIsEmpty == true && nextStateTaskIsEmpty == true && next != null && prev != null) {
        // var isCompletePrev = prev.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        // if (isCompletePrev) {
        //   return true;
        // }
        return false;
      }

      ///TODO:EL ESTADO ANTERIOR TIENE TAREAS, EL ACTUAL TIENE TAREAS , EL SIGUIENTE TIENE TAREAS
      else if (prevStateTaskIsEmpty == true && currentStateTaskIsEmpty == true && nextStateTaskIsEmpty == false && next != null && prev != null) {
        var isCompleteNext = next.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        if (isCompleteNext) {
          return true;
        }
        return false;
      }
      //TODO:EL ESTADO ANTERIOR TIENE TAREAS, EL ACTUAL  TIENE TAREAS , EL SIGUIENTE NO TIENE TAREAS
      else if (currentStateTaskIsEmpty && nextStateTaskIsEmpty && next != null && prev != null) {
        var isCompleteNext = next.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        var isCompletePrev = prev.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        if (isCompleteNext && isCompletePrev) {
          return true;
        }
        return false;
      }

      ///todo: EL ACTUAL TIENE TAREAS , EL anterior NO TIENE TAREAS, no existe siguiente
      else if (currentStateTaskIsEmpty == false && prevStateTaskIsEmpty == true && next == null && prev != null) {
        var isCompleteCurrent = current.tasks!.every((element) => element.action.isNotEmpty);
        var isCompletePrev = prev.tasks?.every((element) => element.action.isNotEmpty) ?? false;
        if (isCompletePrev && isCompleteCurrent) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    }
    return finalized;
  }
}
//   bool _validateState(operat.Stage state, int index) {
//     List<operat.Task> tasks = state.tasks!;
//
//     int quantityDoneTask = 0;
//     // tasks.every((element) => element.action.)
//     for (var i = 0; i < state.tasks!.length; i++) {
//       operat.Task task =  state.tasks![i];
//       if(index == 0){
//         if (task.action.isNotEmpty) {
//           operat.Action action = task.action.last;
//           if (action.dateAction != null ) {
//             quantityDoneTask++;
//           }
//         }
//       }
//
//     }
//     // tasks.forEach((task) {
//     //
//     // });
//
//     if (quantityDoneTask == tasks.length) {
//       _indexSelected = index;
//       return true;
//     }
//     return false;
//   }
// }
