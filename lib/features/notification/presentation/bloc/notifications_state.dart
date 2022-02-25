part of 'notifications_bloc.dart';

enum TypeFilter { NOTIFICATIONS, OPERATION, TASK, NEWS }

class NotificationState extends Equatable {
  final List<NewModel>? news;
  final List<NotificationModel>? notifications;
  final bool? loading;
  final TypeFilter? typeFilter;
  final ResponseStatus? status;
  const NotificationState({
    this.news,
    this.loading,
    this.status,
    this.notifications,
    this.typeFilter,
  });
  static NotificationState get initialState => const NotificationState(
        news: [],
        loading: false,
        status: ResponseStatus.NONE,
        notifications: [],
        typeFilter: TypeFilter.NEWS,
      );
  NotificationState copyWith(
      {List<NewModel>? news, bool? loading, ResponseStatus? status, List<NotificationModel>? notifications, TypeFilter? typeFilter}) {
    return NotificationState(
      news: news ?? this.news,
      loading: loading ?? this.loading,
      typeFilter: typeFilter ?? this.typeFilter,
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [
        news,
        typeFilter,
        loading,
        notifications,
        status,
      ];
}
