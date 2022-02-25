import 'dart:async';

import 'package:appdriver/features/notification/domain/usecases/get_notifications_all_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/features/models/new_model.dart';
import 'package:appdriver/features/notification/domain/usecases/get_news_all_usecase.dart';
import 'package:appdriver/features/notification/data/models/notification_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationState> {
  GetNewsAllUseCase getNewsAllUseCase;
  GetNotificationsAllUseCase getNotificationsAllUseCase;
  int currentPage = 0;
  int size = 10;
  int totalPages = 0;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RefreshController refreshControllerType = RefreshController(initialRefresh: false);
  NotificationsBloc({
    required this.getNewsAllUseCase,
    required this.getNotificationsAllUseCase,
  }) : super(NotificationState.initialState);

  void onRefreshType() async {
    add(GetNotifications(isRefresh: true, typeFilter: TypeFilter.NOTIFICATIONS));
  }

  void onLoadingType() async {
    add(GetNotifications(isRefresh: false, typeFilter: state.typeFilter));
  }

  void onRefresh() async {
    add(GetNews(isRefresh: true));
  }

  void onLoading() async {
    add(GetNews(isRefresh: false));
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is GetNews) {
      if (event.isRefresh!) {
        currentPage = 0;
        yield state.copyWith(loading: true, typeFilter: TypeFilter.NEWS);
      } else {
        currentPage++;
      }
      try {
        List<NewModel> news = [];
        List<NewModel>? response = await getNewsAllUseCase(page: currentPage);
        var data = ApiResponse.completed(response);
        if (event.isRefresh!) {
          news = List<NewModel>.from(data.data!);
          if (data.data == null) {
            refreshController.loadNoData();
          } else {
            refreshController.refreshCompleted(resetFooterState: true);
          }
        } else {
          news = List<NewModel>.from(state.news!);
          if (data.data == null || data.data!.isEmpty) {
            refreshController.loadNoData();
          } else {
            news.addAll(data.data!);
            refreshController.loadComplete();
          }
        }
        yield state.copyWith(news: news, loading: false);
      } catch (_) {}
    }

    if (event is GetNotifications) {
      if (event.isRefresh) {
        currentPage = 0;
        yield state.copyWith(loading: true, typeFilter: event.typeFilter);
      } else {
        currentPage++;
      }
      try {
        String? type;
        if (state.typeFilter == TypeFilter.NOTIFICATIONS) {
          type = '';
        }

        List<NotificationModel> notifications = [];
        List<NotificationModel>? data = await getNotificationsAllUseCase(
          page: currentPage,
          type: type,
        );
        var response = ApiResponse.completed(data);

        if (event.isRefresh) {
          notifications = List<NotificationModel>.from(response.data!);
          if (response.data == null) {
            refreshControllerType.loadNoData();
          } else {
            refreshControllerType.refreshCompleted(resetFooterState: true);
          }
        } else {
          notifications = List<NotificationModel>.from(state.notifications!);
          if (response.data == null || response.data!.isEmpty) {
            refreshControllerType.loadNoData();
          } else {
            notifications.addAll(response.data!);
            refreshControllerType.loadComplete();
          }
        }

        yield state.copyWith(notifications: notifications, loading: false);
      } catch (e) {
        ApiResponse.error(e.toString());
        yield state.copyWith(notifications: [], loading: false);
      }
    }
  }
}
