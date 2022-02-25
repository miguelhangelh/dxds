import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/extensions_methos_global/opportunity/opportunity_currency_methods.dart';
import 'package:appdriver/features/models/travel_model.dart' as travel;
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/global_widgets/travels/widget_item_general_opportunity.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension OpportunityItems on travel.TravelModel {
  static UserPreference userPreference = UserPreference();

  Widget isPostulation() {
    Color colorData = Colors.white;
    if (postulation != null) {
      var transportUnitId = userPreference.transportUnit;
      var postulation = this.postulation!.firstWhereOrNull((element) => element.transportUnitId == transportUnitId!.id);
      if (postulation == null) {
        return _travelItemPostulation(travelItem: this);
      }
      if (id == postulation.travelId) {
        if (postulation.postulateDate != null &&
            postulation.acceptedDate == null &&
            postulation.confirmedDate == null &&
            postulation.cancelledDate == null &&
            postulation.rejectDate == null) {
          colorData = warningColor.withOpacity(0.08);
          return _travelItemPostulation(
            color: colorData,
            postulation: postulation,
            travelItem: this,
            textPostulation: 'Postulación en revisión',
            freightTextPostulation: 'Postulaste por',
            isPostulation: true,
          );
        }
        if (postulation.postulateDate != null &&
            postulation.acceptedDate != null &&
            postulation.confirmedDate == null &&
            postulation.cancelledDate == null &&
            postulation.rejectDate == null) {
          colorData = successColor.withOpacity(0.08);
          return _travelItemPostulation(
            color: colorData,
            postulation: postulation,
            travelItem: this,
            textPostulation: 'Postulación aprobada',
            freightTextPostulation: 'Postulaste por',
            isPostulation: true,
          );
        }
        if (postulation.postulateDate != null &&
            postulation.acceptedDate != null &&
            postulation.confirmedDate != null &&
            postulation.cancelledDate == null &&
            postulation.rejectDate == null) {
          colorData = successColor.withOpacity(0.08);
          return _travelItemPostulation(
            color: colorData,
            postulation: postulation,
            travelItem: this,
            textPostulation: 'Postulación confirmada',
            freightTextPostulation: 'Postulaste por',
            isPostulation: true,
          );
        }
      }
      return _travelItemPostulation(travelItem: this);
    }
    return _travelItemPostulation(travelItem: this);
  }

  Color getColorOpportunity(travel.Postulation postulation) {
    if (postulation.postulateDate != null &&
        postulation.acceptedDate == null &&
        postulation.confirmedDate == null &&
        postulation.cancelledDate == null &&
        postulation.rejectDate == null) {
      return warningColor.withOpacity(0.08);
    }
    if (postulation.postulateDate != null &&
        postulation.acceptedDate != null &&
        postulation.confirmedDate == null &&
        postulation.cancelledDate == null &&
        postulation.rejectDate == null) {
      return successColor.withOpacity(0.08);
    }
    return primaryColor;
  }

  Widget _travelItemPostulation({
    Color color = primaryColor,
    bool isPostulation = false,
    travel.Postulation? postulation,
    required travel.TravelModel travelItem,
    String textPostulation = "",
    String freightTextPostulation = "",
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isPostulation ? color : Colors.white,
          border: Border.all(color: color),
        ),
        padding: isPostulation ? const EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 10) : EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isPostulation ? _buildTextPostulation(textPostulation, freightTextPostulation, postulation!, travelItem) : Container(),
            isPostulation ? const SizedBox(height: 10) : const SizedBox.shrink(),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 9, right: 9, top: 25, bottom: 13),
                  height: 210,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: WidgetItemGeneralOpportunity(travelItem: travelItem),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    width: 100.0.w - 66,
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
                Visibility(
                  visible: !isPostulation,
                  child: const Positioned(
                    right: 5,
                    top: 10,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextPostulation(String textPostulation, String freightTextPostulation, travel.Postulation postulation, travel.TravelModel travelItem) {
    double value = 0;
    double valueOperator = 0;
    if (postulation.freightValue != null) {
      value = postulation.freightValue!;
    }

    if (postulation.freightValueOperator != null) {
      valueOperator = postulation.freightValueOperator!;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomSubTitleWidget(
              text: textPostulation,
              color: Colors.black,
              size: 12.0.sp,
              fontWeight: FontWeight.w600,
            ),
            Visibility(
              visible: value > 0 || valueOperator > 0,
              child: CustomSubTitleWidget(
                text: getTextPostulation(freightTextPostulation, postulation, travelItem),
                color: Colors.black,
                size: 8.0.sp, //13px
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: postulation.acceptedDate != null ? Colors.green : primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        )
      ],
    );
  }

  static String getTextPostulation(String freightTextPostulation, travel.Postulation postulation, travel.TravelModel travelItem) {
    double value = 0;
    double valueOperator = 0;
    if (postulation.freightValue != null) {
      value = postulation.freightValue!;
    }

    if (postulation.freightValueOperator != null) {
      valueOperator = postulation.freightValueOperator!;
    }
    if (valueOperator > 0) {
      if(postulation.typeUnitMeasurementOperator == null){
        return 'Monto por $valueOperator ${postulation.abbreviationTypeCurrencyOperator}';
      }
      return 'Monto por $valueOperator ${postulation.abbreviationTypeCurrencyOperator}/${postulation.abbreviationUnitOperator}';
    }
    return '$freightTextPostulation $value ${OpportunityCurrencyExtension.titleCurrency(false, travelItem)}';
  }
}
