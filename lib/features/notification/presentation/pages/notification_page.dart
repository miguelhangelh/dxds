import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/notification/data/models/notification_model.dart';
import 'package:appdriver/features/notification/presentation/widgets/web_view_news.dart';
import 'package:appdriver/features/operation/presentation/pages/operation_page.dart';
import 'package:appdriver/features/operation/presentation/pages/travels_past_page.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart' as blocAs;
import 'package:appdriver/features/opportunity/presentation/pages/detail_opportunity_page.dart';
import 'package:appdriver/global_widgets/loading/widget_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/new_model.dart';
import 'package:appdriver/features/notification/presentation/bloc/notifications_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:appdriver/features/notification/presentation/pages/notification_type.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationsBloc bloc = sl<NotificationsBloc>();
  ApiBaseHelper data = ApiBaseHelper();
  UserPreference userPreference = UserPreference();
  @override
  void initState() {
    super.initState();
    bloc.add(GetNews(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: CustomSubTitleWidget(
            text: 'Notificaciones',
            color: Colors.black,
            size: 18.0.sp, //13px
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterWidget(),
            BlocBuilder<NotificationsBloc, NotificationState>(
              builder: (context, state) {
                if (state.loading!) {
                  return const Expanded(child: LoadingProgress());
                }
                if (state.typeFilter == TypeFilter.NEWS) {
                  return Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      footer: ClassicFooter(
                        textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
                        noDataText: 'No hay más noticias disponibles',
                        idleText: 'Desliza hacia arriba carga más',
                        canLoadingText: 'Suelte para cargar más',
                      ),
                      enablePullUp: true,
                      controller: bloc.refreshController,
                      onRefresh: bloc.onRefresh,
                      onLoading: bloc.onLoading,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hoy',
                                style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w500, color: const Color(0xff707070)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildIItemToday(state),
                              Text(
                                'Pasadas',
                                style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w500, color: const Color(0xff707070)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildIItemPast(state),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (state.typeFilter == TypeFilter.NOTIFICATIONS) {
                  return Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      footer: ClassicFooter(
                        textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
                        noDataText: 'No hay más notificaciones disponibles',
                        idleText: 'Desliza hacia arriba carga más',
                        canLoadingText: 'Suelte para cargar más',
                      ),
                      enablePullUp: true,
                      controller: bloc.refreshControllerType,
                      onRefresh: bloc.onRefreshType,
                      onLoading: bloc.onLoadingType,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hoy',
                                style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w500, color: const Color(0xff707070)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildIItemTodayType(state, context),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Ayer',
                                style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w500, color: const Color(0xff707070)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildIItemYesterdayType(state, context),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Pasadas',
                                style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w500, color: const Color(0xff707070)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildIItemPastType(state, context),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        )),
      ),
    );
  }

  Column buildIItemToday(NotificationState state) {
    return Column(
      children: state.news!
          .map(
            (e) {
              var time = DateTime.now().difference(e.account!.createDate!.toLocal()).inDays;
              if (time == 0) {
                return ItemNotification(
                  newItem: e,
                );
              }
              return Container();
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }

  Column buildIItemYesterday(NotificationState state) {
    return Column(
      children: state.news!
          .map(
            (e) {
              var time = DateTime.now().difference(e.account!.createDate!.toLocal()).inDays;
              if (time == 1) {
                return ItemNotification(newItem: e);
              }
              return Container();
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }

  Column buildIItemPast(NotificationState state) {
    return Column(
      children: state.news!
          .map(
            (e) {
              var time = DateTime.now().difference(e.account!.createDate!.toLocal()).inDays;
              if (time > 1 || time == 1) {
                return ItemNotification(newItem: e);
              }
              return Container();
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }

  Column buildIItemTodayType(NotificationState state, BuildContext context) {
    return Column(
      children: state.notifications!
          .map(
            (e) {
              var time = DateTime.now().difference(e.createDate!.toLocal()).inDays;
              if (time == 0) {
                return ItemNotificationType(
                  newItem: e,
                  label: e.type,
                  onPressed: () async {
                    redirect(context, e);
                  },
                );
              }
              return Container();
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }

  Column buildIItemYesterdayType(NotificationState state, BuildContext context) {
    return Column(
      children: state.notifications!
          .map(
            (e) {
              var time = DateTime.now().difference(e.createDate!.toLocal()).inDays;
              if (time == 1) {
                return ItemNotificationType(
                  newItem: e,
                  label: e.type,
                  onPressed: () async {
                    redirect(context, e);
                  },
                );
              }
              return Container();
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }

  Column buildIItemPastType(NotificationState state, BuildContext context) {
    return Column(
      children: state.notifications!
          .map(
            (e) {
              var time = DateTime.now().difference(e.createDate!.toLocal()).inDays;
              if (time > 1) {
                return ItemNotificationType(
                  newItem: e,
                  label: e.type,
                  onPressed: () async {
                    redirect(context, e);
                  },
                );
              }
              return Container();
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }

  void redirect(
    BuildContext context,
    NotificationModel e,
  ) {
    if (e.type == "rejecttasks") {
      Navigator.pushNamed(context, OperationPage.routeName);
    }
    if (e.type == "tasks") {
      Navigator.pushNamed(context, OperationPage.routeName);
    }
    if (e.type == "travel") {
      Navigator.pushNamed(context, 'opportunity');
    }
    if (e.type == 'cancelLoadingOrder') {
      Navigator.pushNamed(context, TravelPastPage.routeName);
    }
    if (e.type == 'travelPaid') {
      Navigator.pushNamed(context, 'payment');
    }
    if (e.type == 'AssignedLoadOrder') {
      Navigator.pushNamed(context, TravelPastPage.routeName);
    }
    if (e.type == 'postulationAccepted') {
      Navigator.push(
        context,
        MaterialPageRoute<DetailOpportunityPage>(
          builder: (_) => BlocProvider(
            create: (context) => sl<blocAs.OpportunityBloc>(),
            child: DetailOpportunityPage(
              travelId: e.travelId,
              notification: false,
              isDetailNotification: true,
            ),
          ),
        ),
      );
    }
  }
}

class ItemNotification extends StatefulWidget {
  final NewModel newItem;
  const ItemNotification({
    Key? key,
    required this.newItem,
  }) : super(key: key);

  @override
  _ItemNotificationState createState() => _ItemNotificationState();
}

class _ItemNotificationState extends State<ItemNotification> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.newItem.account!.createDate!.toLocal());
    var data = timeago.format(now.subtract(difference.abs()), locale: 'es');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD9D9D9),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            children: [
              CachedNetworkImage(
                imageUrl: widget.newItem.path ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                    ),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFD9D9D9),
                    ),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white, strokeWidth: 2.0, valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    image: const DecorationImage(
                      image: ExactAssetImage('assets/Logo2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data,
                      style: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.w500, color: const Color(0xff707070)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Text(
                        widget.newItem.name ?? "Sin titulo",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.newItem.description ?? "Sin descripción",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 8.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 18,
                          child: RoundedButton(
                            borderRadius: 14,
                            label: 'Noticia',
                            fullWidth: false,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            fontSize: 7.0.sp,
                            height: 18,
                            textColor: Colors.white,
                            borderColor: Colors.transparent,
                            onPressed: () {},
                            backgroundColor: const Color(0xff242424),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                          child: RoundedButton(
                            borderRadius: 14,
                            label: 'Ver más…',
                            fullWidth: false,
                            padding: EdgeInsets.zero,
                            fontSize: 8.0.sp,
                            height: 18,
                            textColor: primaryColor,
                            borderColor: Colors.transparent,
                            onPressed: () {
                              _launchInBrowser(widget.newItem.link!, context);
                            },
                            backgroundColor: Colors.transparent,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Future<void> _launchInBrowser(String url, context) async {
  if (url.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewContainer(
          url: url,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('La noticia no cuenta con un enlace.'),
    ));
  }
}

class FilterWidget extends StatelessWidget {
  FilterWidget({
    Key? key,
  }) : super(key: key);
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 27, maxHeight: 27, minWidth: 70),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(width: 1, color: Color(0xff242424)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        backgroundColor: state.typeFilter == TypeFilter.NOTIFICATIONS ? Colors.black : Colors.transparent,
                      ),
                      onPressed: () {
                        context.read<NotificationsBloc>().add(GetNotifications(isRefresh: true, typeFilter: TypeFilter.NOTIFICATIONS));
                      },
                      child: Text(
                        'Notificaciones',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: state.typeFilter == TypeFilter.NOTIFICATIONS ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 27, maxHeight: 27, minWidth: 100),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          side: const BorderSide(width: 1, color: Color(0xff242424)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: Colors.red),
                          ),
                          primary: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          backgroundColor: state.typeFilter == TypeFilter.NEWS ? Colors.black : Colors.transparent,
                        ),
                        onPressed: () async {
                          context.read<NotificationsBloc>().add(GetNews(isRefresh: true));
                        },
                        child: Text(
                          'Noticias',
                          style: GoogleFonts.montserrat(
                            fontSize: 10.0.sp,
                            color: state.typeFilter == TypeFilter.NEWS ? Colors.white : Colors.black,
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
