import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/global_widgets/travels/widget_item_body_opportunity.dart';
import 'package:appdriver/global_widgets/travels/widget_item_head_opportunity.dart';
import 'package:flutter/material.dart';

class WidgetItemGeneralOpportunity extends StatelessWidget {
  final travel.TravelModel? travelItem;
  final bool isDetail;
  final bool isPaid;
  final List<ExchangeRate>? exchangeRates;
  const WidgetItemGeneralOpportunity({
    Key? key,
    this.travelItem,
    this.isDetail = false,
    this.isPaid = false,
    this.exchangeRates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemHeadOpportunity(constraints: constraints, travelItem: travelItem, isDetail: isDetail, isPaid: isPaid, exchangeRates:exchangeRates),
            ItemBodyOpportunity(constraints: constraints, travelItem: travelItem, isDetail: isDetail),
          ],
        );
      },
    );
  }
}
