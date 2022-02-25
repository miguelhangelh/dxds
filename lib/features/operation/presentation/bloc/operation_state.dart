part of 'operation_bloc.dart';

class OperationState extends Equatable {
  final List<TaskLocal>? tasksLocal;
  final op.LoadingOrder? loadingOrders;
  final List<op.Stage>? stages;
  final op.Route? route;
  final bool? finished;
  final bool? taskSuccess;
  final op.Operation? operation;
  final op.Stage? currentStage;
  final op.Task? currentTask;
  final List<op.Task>? tasks;
  final Rating? rating;
  final bool? loading;
  final bool? loadingRating;
  final Map<MarkerId, Marker>? markers;
  final TravelsPastModel? travelsPast;
  final op.MyPosition? myLocation;
  final op.PolylineCoordinates? polylineCoordinates;
  final List<LatLng> polylines;
  const OperationState({
    this.loadingOrders,
    this.stages,
    this.operation,
    this.travelsPast,
    this.currentTask,
    this.tasks,
    this.rating,
    this.route,
    this.currentStage,
    this.taskSuccess,
    this.tasksLocal,
    this.finished,
    this.loadingRating,
    this.loading,
    this.polylineCoordinates,
    this.myLocation,
    this.polylines = const [],
    this.markers,
  });
  static OperationState get initialState => OperationState(
        tasksLocal: const [],
        stages: const [],
        travelsPast: null,
        route: null,
        tasks: null,
        currentStage: null,
        loadingOrders: null,
        operation: null,
        taskSuccess: false,
        loadingRating: false,
        loading: false,
        finished: false,
        myLocation: null,
        currentTask: null,
        polylines: const [],
        rating: null,
        markers: Map(),
        polylineCoordinates: null,
      );

  OperationState copyWith({
    List<TaskLocal>? tasksLocal,
    bool? finished,
    Map<MarkerId, Marker>? markers,
    op.Stage? Function()? currentStage,
    op.Task? Function()? currentTask,
    op.LoadingOrder? loadingOrders,
    Rating? rating,
    bool? loadingRating,
    List<op.Task>? tasks,
    List<op.Stage>? stages,
    op.Route? route,
    bool? loading,
    op.Operation? operation,
    op.MyPosition? myLocation,
    bool? taskSuccess,
    TravelsPastModel? travelsPast,
    List<LatLng>? polylines,
    op.PolylineCoordinates? polylineCoordinates,
  }) {
    return OperationState(
      tasksLocal: tasksLocal ?? this.tasksLocal,
      operation: operation ?? this.operation,
      currentTask: currentTask != null ? currentTask() : this.currentTask,
      rating: rating ?? this.rating,
      tasks: tasks ?? this.tasks,
      currentStage: currentStage != null ? currentStage() : this.currentStage,
      stages: stages ?? this.stages,
      loadingRating: loadingRating ?? this.loadingRating,
      taskSuccess: taskSuccess ?? this.taskSuccess,
      markers: markers ?? this.markers,
      finished: finished ?? this.finished,
      travelsPast: travelsPast ?? this.travelsPast,
      loading: loading ?? this.loading,
      route: route ?? this.route,
      loadingOrders: loadingOrders ?? this.loadingOrders,
      polylines: polylines ?? this.polylines,
      myLocation: myLocation ?? this.myLocation,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
    );
  }

  Map<String, dynamic> toMap() {
    if (operation != null) {
      userPreference.setOperation = json.encode(operation);
    }
    // print("TO MAP ${operation!.stages!.length}");
    return {
      'tasksLocal': tasksLocal?.map((x) => x.toJson()).toList(),
      'loadingOrders': loadingOrders == null ? null : loadingOrders!.toJson(),
      'stages': stages == null ? null : stages!.map((x) => x.toJson()).toList(),
      'tasks': tasks == null ? null : tasks!.map((x) => x.toJson()).toList(),
      'currentStage': currentStage == null ? null : currentStage!.toJson(),
      'currentTask': currentTask == null ? null : currentTask!.toJson(),
      'route': route == null ? null : route!.toJson(),
      'operation': operation == null ? null : operation!.toJson(),
      'travelsPast': travelsPast == null ? null : travelsPast!.toJson(),
      'finished': finished,
      'taskSuccess': taskSuccess,
      'rating': rating == null ? null : rating!.toJson(),
      'loading': loading,
      'loadingRating': loadingRating,
      'myLocation': myLocation == null ? null : myLocation!.toJson(),
      'polylineCoordinates': polylineCoordinates == null ? null : polylineCoordinates!.toJson(),
      'polylines': polylines.toList(),
      'markers': markers == null ? Map() : markers,
    };
  }

  factory OperationState.fromMap(Map<String, dynamic> map) {
    var data = map['polylines'] as List;
    Map<MarkerId, Marker> markers = Map<MarkerId, Marker>.from(map['markers']);
    List<LatLng> a = [];
    for (var element in data) {
      a.add(LatLng(element[0], element[1]));
    }
    return OperationState(
      tasksLocal: map['tasksLocal'] == null ? null : List<TaskLocal>.from(map['tasksLocal']?.map((x) => TaskLocal.fromJson(x))),
      loadingOrders: map["loadingOrder"] == null ? null : op.LoadingOrder.fromJson(map["loadingOrder"]),
      stages: map["stages"] == null ? null : List<op.Stage>.from(map['stages']?.map((x) => op.Stage.fromJson(x))),
      tasks: map["tasks"] == null ? null : List<op.Task>.from(map['tasks']?.map((x) => op.Task.fromJson(x))),
      route: map['route'] == null ? null : op.Route.fromJson(map['route']),
      finished: map['finished'],
      travelsPast: map['travelsPast'] == null ? null : TravelsPastModel.fromJson(map['travelsPast']),
      operation: map['operation'] == null ? null : op.Operation.fromJson(map['operation']),
      currentStage: map['currentStage'] == null ? null : op.Stage.fromJson(map['currentStage']),
      currentTask: map['currentTask'] == null ? null : op.Task.fromJson(map['currentTask']),
      taskSuccess: map['taskSuccess'],
      loading: map['loading'],
      loadingRating: map['loadingRating'],
      rating: map['rating'] == null ? null : Rating.fromJson(map['rating']),
      polylines: map['polylines'] == null ? [] : a,
      markers: map['markers'] == null ? Map() : markers,
      myLocation: map['myLocation'] == null ? null : op.MyPosition.fromJson(map['myLocation']),
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory OperationState.fromJson(String source) => OperationState.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        loadingOrders,
        stages,
        travelsPast,
        tasks,
        operation,
        route,
        rating,
        taskSuccess,
        tasksLocal,
        finished,
        currentStage,
        loading,
        polylineCoordinates,
        myLocation,
        polylines,
        markers,
      ];
}
