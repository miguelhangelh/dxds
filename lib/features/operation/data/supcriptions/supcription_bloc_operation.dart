
import 'dart:async';

class OperationSubcriptions {
  
  OperationSubcriptions._internal();
  static OperationSubcriptions _instance = OperationSubcriptions._internal();
  static OperationSubcriptions get instance => _instance;


  // ignore: close_sinks
  StreamController<Map?> _controllerNotification = StreamController.broadcast();
  StreamController<bool> _controllerTaskSuccess = StreamController.broadcast();
  Stream<Map?> get stream => _controllerNotification.stream;
  Stream<bool> get streamTask => _controllerTaskSuccess.stream;
  set streamAdd(Map? task) => _controllerNotification.sink.add(task);
  set streamTaskAdd(bool task) => _controllerTaskSuccess.sink.add(task);

  init(){
    _controllerTaskSuccess  = StreamController.broadcast();
  }
  void closeStream() {
    _controllerTaskSuccess.close();
  }
}
