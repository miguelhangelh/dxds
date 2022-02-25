import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:appdriver/extensions_methos_global/opportunity/opportunity_currency_methods.dart';

class ItemHeadOpportunity extends StatelessWidget {
  final BoxConstraints? constraints;
  final travel.TravelModel? travelItem;
  final bool? isDetail;
  final bool isPaid;
  final List<ExchangeRate>? exchangeRates;
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  final outputFormatFilter = DateFormat('d/MM', 'es_ES');
  ItemHeadOpportunity({Key? key, this.constraints, this.travelItem, this.isDetail, required this.isPaid, this.exchangeRates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox().widgetTitleCurrency(isPaid, travelItem!),
                  SizedBox(width: travelItem!.freightValues?.freightOffered?.value == null ? 0 :7),
                  const SizedBox().widgetTitlePriceCurrency(isPaid, travelItem!, exchangeRates),
                ],
              ),
            ],
          ),
          CustomSubTitleWidget(
            text: 'Valor de flete',
            size: 8.0.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF707070),
          ),
        ],
      ),
    );
  }
}
