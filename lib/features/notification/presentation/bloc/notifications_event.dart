part of 'notifications_bloc.dart';
abstract class NotificationsEvent {
}
class GetNews extends NotificationsEvent {
  final bool? isRefresh;

  GetNews({this.isRefresh});
}
class GetNotifications extends NotificationsEvent {
  final bool isRefresh;
  final   TypeFilter? typeFilter;
  GetNotifications({this.isRefresh = false, this.typeFilter});
}
