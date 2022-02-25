part of 'conectivity_bloc.dart';

class ConnectivityState {
  final bool online;
  final bool offline;
  final bool connecting;
  final bool successTask;

  ConnectivityState({
    this.online = true,
    this.offline = false,
    this.connecting = true,
    this.successTask = false,
  });

  ConnectivityState copyWith({
    bool? online,
    bool? offline,
    bool? connecting,
    bool? successTask,
  }) =>
      ConnectivityState(
        online: online ?? this.online,
        offline: offline ?? this.offline,
        connecting: connecting ?? this.connecting,
        successTask: successTask ?? this.successTask,
      );
}
