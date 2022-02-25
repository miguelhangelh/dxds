import 'package:appdriver/extensions_methos_global/opportunity/opportunity_currency_methods.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/global_widgets/loading/widget_loading.dart';
import 'package:appdriver/global_widgets/travels/widget_item_general_opportunity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:appdriver/extensions_methos_global/opportunity/opportunity_item.dart';

class TravelPaymentPage extends StatefulWidget {
  const TravelPaymentPage({Key? key}) : super(key: key);

  @override
  State<TravelPaymentPage> createState() => _TravelPaymentPageState();
}

class _TravelPaymentPageState extends State<TravelPaymentPage> {
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  final OpportunityBloc bloc = sl<OpportunityBloc>();
  @override
  void initState() {
    super.initState();
    bloc.add(GetTravelsPayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const CustomSubTitleWidget(
          text: 'Mis pagos',
          color: Colors.black,
          size: 24, //13px
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => bloc,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                BlocBuilder<OpportunityBloc, OpportunityState>(
                  builder: (context, state) {
                    return FilterWidget(state: state);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: BlocBuilder<OpportunityBloc, OpportunityState>(
                    builder: (context, state) {
                      if (state.loading!) {
                        return const LoadingProgress();
                      }
                      if (state.travels!.isNotEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            pricesTotal(context, state),
                            Expanded(
                              child: RefreshIndicator(
                                backgroundColor: primaryColor,
                                color: Colors.white,
                                onRefresh: () async {
                                  context.read<OpportunityBloc>().retryTravelsPayments();
                                },
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  itemCount: state.travels!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    travel.TravelModel travelItem = state.travels![index];
                                    return itemTravel(travelItem, state.exchangeRates);
                                    // }
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: primaryColor,
                                      size: 50,
                                    ),
                                    CustomSubTitleWidget(
                                      textAlign: TextAlign.center,
                                      maxLines: 5,
                                      text: 'No ha realizado viajes con nosotros',
                                      color: Colors.black,
                                      size: 16.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        '(Reintentar)',
                                        style: GoogleFonts.montserrat(fontSize: 16, color: primaryColor, fontWeight: FontWeight.w400),
                                      ),
                                      onTap: () {
                                        context.read<OpportunityBloc>().add(GetTravelsPayments());
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemTravel(travel.TravelModel travelItem, List<ExchangeRate>? exchangeRates) {
    var order = travelItem.loadingOrder!.loadingOrderStatus!;
    if (order.isNotEmpty) {
      var orderStatus = order.last.order;
      if (orderStatus != null) {
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 9, right: 9, top: 25, bottom: 13),
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(
                    color: orderStatus == 4 ? const Color(0xff2DAA58) : const Color(0xffD9D9D9),
                  ),
                ),
                child: WidgetItemGeneralOpportunity(
                  travelItem: travelItem,
                  exchangeRates: exchangeRates,
                  isPaid: true,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 100.0.w - 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 25,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              color: primaryColor),
                          child: Center(
                            child: CustomSubTitleWidget(
                              text: 'Por ${travelItem.company?.name}',
                              color: Colors.white,
                              size: 10.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 5,
                child: orderStatus == 4
                    ? Row(
                        children: [
                          Text('Pagada', style: TextStyle(fontSize: 14.0.sp, color: const Color(0xFF2DAA58), fontWeight: FontWeight.w500)),
                          const SizedBox(
                            width: 4,
                          ),
                          const Icon(Icons.account_balance_wallet_outlined, color: Color(0xff6dc78a)),
                        ],
                      )
                    : Text('Por cobrar', style: TextStyle(fontSize: 14.0.sp, color: Colors.black, fontWeight: FontWeight.w500)),
              )
            ],
          ),
        );
      }
      return Container();
    }
    return Container();
  }

  Widget pricesTotal(BuildContext context, OpportunityState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD9D9D9), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTAL HISTÓRICO',
              style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w600, color: const Color(0xff5D5D5D)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.trending_up_outlined, color: primaryColor),
                const SizedBox(
                  width: 14,
                ),
                const SizedBox().widgetTotalPrice(state.travels!, state.exchangeRates!),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  final OpportunityState? state;
  FilterWidget({
    this.state,
    Key? key,
  }) : super(key: key);
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
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
                      backgroundColor: state!.isFilterPaid == false ? Colors.transparent : Colors.black),
                  onPressed: () {
                    context.read<OpportunityBloc>().add(GetTravelsPayments(isFilterPaid: !state!.isFilterPaid!));
                  },
                  child: Text(
                    'Pagadas',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: state!.isFilterPaid == false ? const Color(0xff242424) : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 27, maxHeight: 27, minWidth: 95),
                child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: Color(0xff242424)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.red)),
                      primary: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      elevation: 0,
                      backgroundColor: state!.isFilterToPaid == false ? Colors.transparent : Colors.black),
                  onPressed: () {
                    context.read<OpportunityBloc>().add(GetTravelsPayments(isFilterToPaid: !state!.isFilterToPaid!));
                  },
                  child: Text(
                    'Por cobrar ',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: state!.isFilterToPaid == false ? const Color(0xff242424) : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
