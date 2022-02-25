part of 'operation_bloc.dart';

abstract class OperationEvent {}

class AddTasksEvent extends OperationEvent {}

class UpdateTaskLocal extends OperationEvent {}

class AddGeofences extends OperationEvent {}

class LoadOperationEvent extends OperationEvent {}

class RefreshOperation extends OperationEvent {
  final bool isRefresh;

  RefreshOperation({this.isRefresh = false});
}

class GetTravelsPastEvent extends OperationEvent {}

class MyLocationUpdateEvent extends OperationEvent {
  final LatLng? location;

  MyLocationUpdateEvent({this.location});
}

class MyLocationEvent extends OperationEvent {
  final LatLng? location;

  MyLocationEvent({this.location});
}

class AddFileEventUpdate extends OperationEvent {
  final List<String> file;
  final String? idStage;
  final String? idTask;

  final String? loadingOrderId;
  final op.Task task;
  AddFileEventUpdate({
    required this.file,
    required this.idStage,
    required this.idTask,
    required this.loadingOrderId,
    required this.task,
  });

  @override
  List<Object?> get props => [
        file,
        idStage,
        idTask,
        task,
        loadingOrderId,
      ];
}

class AddFileEventPending extends OperationEvent {
  final List<String>? file;
  final String? idStage;
  final String? idTask;
  final String? loadingOrderId;
  final op.Task? task;
  AddFileEventPending({
    this.file,
    required this.idStage,
    required this.idTask,
    required this.loadingOrderId,
    required this.task,
  });

  @override
  List<Object?> get props => [
        file,
        idStage,
        idTask,
        task,
        loadingOrderId,
      ];
}

class AddFileEvent extends OperationEvent {
  final List<String> file;
  final String? idStage;
  final String? idTask;

  final String? loadingOrderId;
  final op.Task? task;
  AddFileEvent({
    required this.file,
    required this.idStage,
    required this.idTask,
    required this.loadingOrderId,
    required this.task,
  });

  @override
  List<Object?> get props => [
        file,
        idStage,
        idTask,
        task,
        loadingOrderId,
      ];
}

class MarkedGeofence extends OperationEvent {
  final bg.GeofenceEvent event;
  MarkedGeofence(this.event);
}

class UpdateTaskStage extends OperationEvent {}

class NotifyCheckPoints extends OperationEvent {}

class ClosedSuccess extends OperationEvent {}

class GetRatingLoadingOrder extends OperationEvent {
  final TravelModel? travel;
  GetRatingLoadingOrder({this.travel});
}
