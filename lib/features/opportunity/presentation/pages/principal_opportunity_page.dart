import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/global_widgets/custom_success.dart';
import 'package:appdriver/global_widgets/empty/empty_message_data.dart';
import 'package:appdriver/global_widgets/loading/widget_loading.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/error/response.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/features/opportunity/data/supcriptions/supcription_oportunity.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:appdriver/features/opportunity/presentation/pages/detail_opportunity_page.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:appdriver/global_widgets/travels/widget_item_general_opportunity.dart';
import 'package:appdriver/extensions_methos_global/opportunity/opportunity_item.dart';

class OpportunityPage extends StatefulWidget {
  const OpportunityPage({Key? key}) : super(key: key);

  @override
  _OpportunityPageState createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  final outputFormatFilter = DateFormat('d/MM', 'es_ES');
  OpportunityBloc bloc = sl<OpportunityBloc>();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  UserPreference userPreference = UserPreference();

  @override
  void initState() {
    super.initState();
    analytics.logEvent(name: 'Oportunidades');
    OpportunitySubcriptions.instance.stream.listen((event) {
      bloc.add(GetTravels(isRefresh: true, typeFilter: TypeFilter.NONE));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc
        ..add(GetTravels(isRefresh: true, typeFilter: TypeFilter.NONE))
        ..add(GetFilterCategory()),
      child: Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: CustomSubTitleWidget(
            text: 'Oportunidades',
            color: Colors.black,
            size: 18.sp, //13px
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBar: FloatingActionButton(
          child: Icon(Icons.ac_unit_rounded),
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierLabel: "Hola a todos",
              barrierDismissible: false,
              transitionDuration: Duration(milliseconds: 300),
              pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent, // For both Android + iOS
                    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
                    statusBarBrightness: Brightness.light,
                  ),
                  child: Scaffold(
                    extendBodyBehindAppBar: true,
                    body: DoubleBackToCloseApp(
                      snackBar: const SnackBar(
                        content: Text('Toca de nuevo para salir'),
                      ),
                      child: SuccessPage(
                        title: 'Tarea subida exitosamente',
                        description: 'Se ha subido la tarea exitosamente.',
                        buttonText: 'Continuar',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text('Toca de nuevo para salir'),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const FilterWidget(),
                filterDataWidget(),
                bodyOpportunity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder<OpportunityBloc, OpportunityState> bodyOpportunity() {
    return BlocBuilder<OpportunityBloc, OpportunityState>(
      builder: (context, state) {
        if (state.status == ResponseStatus.NONE) {
          return Container();
        } else if (state.status == ResponseStatus.LOADING) {
          return opportunityLoading();
        } else if (state.status == ResponseStatus.COMPLETED) {
          if (state.travels!.isNotEmpty) {
            return opportunityTravels(state);
          } else {
            return opportunityNone(context);
          }
        } else {
          return opportunityError(state, context);
        }
      },
    );
  }

  Expanded opportunityError(OpportunityState state, BuildContext context) {
    return Expanded(
      child: EmptyDataMessage(
        message: state.messages,
        onPressed: () {
          context.read<OpportunityBloc>().add(GetTravels(isRefresh: true));
        },
      ),
    );
  }

  Expanded opportunityNone(BuildContext context) {
    return Expanded(
      child: EmptyDataMessage(
        message: 'No hay oportunidades en este momento',
        onPressed: () {
          context.read<OpportunityBloc>().retryTravels();
        },
      ),
    );
  }

  Expanded opportunityTravels(OpportunityState state) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        footer: ClassicFooter(
          textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
          noDataText: 'No hay más oportunidades disponibles',
          idleText: 'Desliza hacia arriba carga más',
          canLoadingText: 'Suelte para cargar más',
          loadingText: "Cargando...",
        ),
        enablePullUp: true,
        controller: bloc.refreshController,
        onRefresh: bloc.onRefresh,
        onLoading: bloc.onLoading,
        child: ListView.builder(
          itemCount: state.travels!.length,
          itemBuilder: (BuildContext context, int index) {
            travel.TravelModel travelItem = state.travels![index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<DetailOpportunityPage>(
                    builder: (_) => DetailOpportunityPage(isDetailNotification: false, travelItem: travelItem),
                  ),
                );
              },
              child: travelItem.isPostulation(),
            );
          },
        ),
      ),
    );
  }

  Expanded opportunityLoading() {
    return const Expanded(
      child: LoadingProgress(),
    );
  }

  BlocBuilder<OpportunityBloc, OpportunityState> filterDataWidget() {
    return BlocBuilder<OpportunityBloc, OpportunityState>(
      builder: (context, state) {
        var a = (state.start != null && state.end != null);
        return Column(
          children: [
            Visibility(
              visible: (state.start != null && state.end != null),
              child: buildFilterDate(state, context),
            ),
            Visibility(
              visible: state.category != null,
              child: buildFilterCategory(state, context),
            )
          ],
        );
      },
    );
  }

  Container buildFilterCategory(OpportunityState state, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: Row(
        children: [
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xfff9eee2),
                ),
                height: 30,
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_rounded,
                      color: primaryColor,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomSubTitleWidget(
                      text: 'Categoria: ${state.category?.name}',
                      color: Colors.black,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            child: Container(
              child: const Icon(
                Icons.delete,
                size: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xffe1e1e1),
              ),
              height: 30,
              width: 30,
            ),
            onTap: () {
              BlocProvider.of<OpportunityBloc>(context).add(GetTravels(isRefresh: true, category: null, typeFilter: TypeFilter.CATEGORY));
            },
          ),
        ],
      ),
    );
  }

  Container buildFilterDate(OpportunityState state, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: Row(
        children: [
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xfff9eee2),
                ),
                height: 30,
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_rounded,
                      color: primaryColor,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomSubTitleWidget(
                      text:
                          'Fecha: ${outputFormatFilter.format(state.start ?? DateTime.now())} - ${outputFormatFilter.format(state.end ?? DateTime.now())}',
                      color: Colors.black,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            child: Container(
              child: const Icon(
                Icons.delete,
                size: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xffe1e1e1),
              ),
              height: 30,
              width: 30,
            ),
            onTap: () {
              BlocProvider.of<OpportunityBloc>(context).add(GetTravels(isRefresh: true, end: null, start: null, typeFilter: TypeFilter.DATE));
            },
          ),
        ],
      ),
    );
  }
}

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  CategoryModel? _selectedValueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      height: 27,
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              Text(
                'Filtrar por: ',
                style: TextStyle(fontSize: 12.0.sp, color: const Color(0xff242424), fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 7,
              ),
              BlocBuilder<OpportunityBloc, OpportunityState>(
                builder: (context, state) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(width: state.end != null && state.start != null ? 1 : 1, color: const Color(0xff242424)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      primary: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      backgroundColor: state.end != null && state.start != null ? const Color(0xff242424) : Colors.transparent,
                    ),
                    onPressed: () async {
                      var data = await showDateRangePicker(
                        locale: const Locale('es', 'ES'),
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData(
                              brightness: Brightness.light,
                              colorScheme: const ColorScheme.light(
                                primary: primaryColor,
                              ),
                              cardColor: primaryColor,
                              highlightColor: primaryColor,
                              splashColor: primaryColor,
                              primaryColor: primaryColor,
                              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: SizedBox(width: 200, height: 200, child: child),
                          );
                        },
                      );
                      if (data != null) {
                        BlocProvider.of<OpportunityBloc>(context)
                            .add(GetTravels(isRefresh: true, start: data.start, end: data.end, typeFilter: TypeFilter.DATE));
                      }
                    },
                    child: Text(
                      'Fecha',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.0.sp,
                        color: state.end != null && state.start != null ? Colors.white : const Color(0xff242424),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<OpportunityBloc, OpportunityState>(
                builder: (context, state) {
                  return TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        side: BorderSide(width: state.category != null ? 1 : 1, color: const Color(0xff242424)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.red)),
                        primary: Colors.blue,
                        elevation: 0,
                        backgroundColor: state.category != null ? const Color(0xff242424) : Colors.transparent),
                    onPressed: () async {
                      await showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
                        ),
                        context: context,
                        builder: (BuildContext contexts) {
                          return StatefulBuilder(
                            builder: (BuildContext contextData, setState) {
                              return Container(
                                padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 5,
                                              width: 100,
                                              color: const Color(0xffe2e8f0),
                                            ),
                                            SizedBox(
                                              height: 2.5.h,
                                            ),
                                            Visibility(
                                              visible: state.categories!.isNotEmpty,
                                              child: Text(
                                                'Filtrar por ',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff242424),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: state.categories!.isEmpty,
                                              child: Text(
                                                'No hay categorias para filtrar ',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xff242424),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.5.h,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: state.categories!.isNotEmpty,
                                      child: Expanded(
                                        child: SizedBox(
                                          child: ListView.builder(
                                            itemExtent: 7.0.h,
                                            shrinkWrap: true,
                                            itemCount: state.categories!.length,
                                            itemBuilder: (context, index) {
                                              var category = state.categories![index];
                                              return GestureDetector(
                                                onTap: () {
                                                  // valueItem.selected = true;
                                                  setState(() {
                                                    _selectedValueColor = category;
                                                  });
                                                },
                                                child: Container(
                                                  color: category.id == _selectedValueColor?.id ? const Color(0xFFfdf2e6) : Colors.transparent,
                                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(category.name!,
                                                          style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w500, color: Colors.black)),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 19,
                                    ),
                                    Visibility(
                                      visible: state.categories!.isNotEmpty,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RoundedButton(
                                              backgroundColor: const Color(0xffFAFAFA),
                                              borderColor: const Color(0xffD9D9D9),
                                              textColor: Colors.black,
                                              // loading: state.formStatus is FormSubmitting ? true : false,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _selectedValueColor = null;
                                              },
                                              label: 'Cancelar',
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 19,
                                          ),
                                          Expanded(
                                            child: RoundedButton(
                                              onPressed: () {
                                                if (_selectedValueColor == null) {
                                                  _showSnackBar(
                                                    context,
                                                    'Selecciona una categoria para filtrar',
                                                  );
                                                  return;
                                                }
                                                Navigator.pop(context);
                                                BlocProvider.of<OpportunityBloc>(context)
                                                    .add(GetTravels(isRefresh: true, category: _selectedValueColor, typeFilter: TypeFilter.CATEGORY));
                                                setState(() {
                                                  _selectedValueColor = null;
                                                });
                                              },
                                              label: 'Continuar',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Categoría ',
                      style: GoogleFonts.montserrat(
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: state.category != null ? Colors.white : const Color(0xff242424),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(behavior: SnackBarBehavior.floating, content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
