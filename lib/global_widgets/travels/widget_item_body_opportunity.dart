import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ItemBodyOpportunity extends StatelessWidget {
  final BoxConstraints? constraints;
  final travel.TravelModel? travelItem;
  final bool? isDetail;
  final outputFormat = DateFormat('EEEE d, MMMM', 'es_ES');
  final outputFormatFilter = DateFormat('d/MM', 'es_ES');
  ItemBodyOpportunity({Key? key, this.constraints, this.travelItem, this.isDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: !isDetail! ? constraints!.maxWidth * 0.55 : constraints!.maxWidth,
            // color: Colors.red,
            child: Row(
              children: <Widget>[
               isDetail! ? Expanded(
                 flex: !isDetail! ?2 : 1,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     iconOrigin(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     iconDestination(),
                   ],
                 ),
               ) : Expanded(
                 flex: 2,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     iconOrigin(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     dividerOriginDestination(),
                     iconDestination(),
                   ],
                 ),
               ),
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSubTitleWidget(
                              text: 'ORIGEN',
                              color: const Color(0xFF989898),
                              size: 8.0.sp, //13px
                              fontWeight: FontWeight.w600,
                            ),
                            CustomSubTitleWidget(
                              text: !isDetail! ? nameOrigin(travelItem!) : travelItem!.route!.origin!.cityOrigin, //'Santa Cruz'
                              color: const Color(0xFF000000),
                              size: 10.0.sp,
                              maxLines: 2,
                              fontWeight: FontWeight.w600,
                            ),
                            Visibility(
                              visible: !isDetail!,
                              child: CustomSubTitleWidget(
                                text: travelItem!.dates?.indefiniteDate == false ? outputFormat.format(travelItem!.dates!.loadingDate!.toLocal())[0].toUpperCase() +
                                    outputFormat.format(travelItem!.dates!.loadingDate!.toLocal()).substring(1) : "Fecha abierta",
                                color: const Color(0xFF989898),
                                size: 8.0.sp, //13px
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSubTitleWidget(
                              text: 'DESTINO',
                              color: const Color(0xFF989898),
                              size: 8.0.sp, //13px
                              fontWeight: FontWeight.w600,
                            ),
                            CustomSubTitleWidget(
                              text: !isDetail! ? nameDestination(travelItem!) : travelItem!.route!.destination!.cityDestination, //'La Paz'
                              color: const Color(0xFF000000),
                              size: 10.0.sp,
                              maxLines: 2,
                              fontWeight: FontWeight.w600,
                            ),
                            Visibility(
                              visible: !isDetail!,
                              child: CustomSubTitleWidget(
                                text: travelItem!.dates?.indefiniteDate == false ? outputFormat.format(travelItem!.dates!.deliveryDate!.toLocal())[0].toUpperCase() +
                                    outputFormat.format(travelItem!.dates!.deliveryDate!.toLocal()).substring(1) : "Fecha abierta",
                                color: const Color(0xFF989898),
                                size: 8.0.sp, //13px
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isDetail!,
            child: SizedBox(
                width: constraints!.maxWidth * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSubTitleWidget(
                          text: 'PESO',
                          color: const Color(0xFF989898),
                          size: 8.0.sp, //13px
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSubTitleWidget(
                          text: '${travelItem!.weightUnit!.value} ${travelItem!.weightUnit!.abbreviation}.', //'Santa Cruz'
                          color: const Color(0xFF000000),
                          size: 10.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSubTitleWidget(
                          text: 'CATEGORÍA',
                          color: const Color(0xFF989898),
                          size: 8.0.sp, //13px
                          fontWeight: FontWeight.w600,
                        ),
                        CustomSubTitleWidget(
                          maxLines: 3,
                          text: travelItem!.categoryLoad!.name, //'Santa Cruz'
                          color: const Color(0xFF000000),
                          size: 10.0.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Container iconOrigin() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: const Icon(
        Icons.location_on,
        size: 11.0,
      ),
    );
  }

  Container iconDestination() {
    return Container(
      height: 20,
      width: 20,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.black,
        ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 11.0,
      ),
    );
  }

  Container dividerOriginDestination() {
    return Container(
      height: 6.5,
      width: 1.5,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(
        bottom: 4.0,
      ),
    );
  }
}
