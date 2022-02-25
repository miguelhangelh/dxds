import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart' as op;
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension OpportunityCurrencyExtension on Object {
  static String titleCurrency(bool isPaid, TravelModel travelItem) {
    if (isPaid) {
      String? typeUnitMeasurement = travelItem.loadingOrder?.carrierFreight?.typeUnitMeasurement;
      final LoadingOrder? loadingOrder = travelItem.loadingOrder;
      if (typeUnitMeasurement == null) {
        return loadingOrder?.carrierFreight?.abbreviationtypeCurrencyFreight ?? 'Bs';
      } else {
        return '${loadingOrder?.carrierFreight?.abbreviationtypeCurrencyFreight}/${loadingOrder?.carrierFreight?.abbreviationUnit} ';
      }
    } else {
      double? freightOfferedValue = travelItem.freightValues?.freightOffered?.value;
      if (freightOfferedValue == null) {
        return '';
      } else {
        String? typeUnitMeasurement = travelItem.freightValues?.freightOffered?.typeUnitMeasurement;
        if (typeUnitMeasurement == null) {
          return travelItem.freightValues?.freightOffered?.abbreviationTypeCurrency ?? 'Bs';
        } else {
          return '${travelItem.freightValues?.freightOffered?.abbreviationTypeCurrency}/${travelItem.freightValues?.freightOffered?.abbreviationUnit} ';
        }
      }
    }
  }

  static String titleCurrencyOperation(op.Operation travelItem) {
    double? freightOfferedValue = travelItem.freightValues?.freightOffered?.value;
    if (freightOfferedValue == null) {
      return '';
    } else {
      String? typeUnitMeasurement = travelItem.freightValues?.freightOffered?.typeUnitMeasurement;
      if (typeUnitMeasurement == null) {
        return travelItem.freightValues?.freightOffered?.abbreviationTypeCurrency ?? 'Bs';
      } else {
        return '${travelItem.freightValues?.freightOffered?.abbreviationTypeCurrency}/${travelItem.freightValues?.freightOffered?.abbreviationUnit} ';
      }
    }
  }

  double _totalPrice(List<TravelModel> travels, List<ExchangeRate> exchangeRates) {
    double total = 0;
    for (var travelItem in travels) {
      if (travelItem.loadingOrder!.loadingOrderStatus!.isNotEmpty) {
        var data = travelItem.loadingOrder!.loadingOrderStatus!.last;
        if (data.order == 4) {
          var totalData = travelItem.loadingOrder?.carrierFreight?.freightValue ?? 0;
          total = total + totalData;
        }
      }
    }
    return total;
  }

  Widget widgetTotalPrice(List<TravelModel> travels, List<ExchangeRate> exchangeRates) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'BS.',
            style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          TextSpan(
            text: _totalPrice(travels, exchangeRates).toStringAsFixed(2),
            style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget widgetTitleCurrency(bool isPaid, TravelModel travelItem) {
    return CustomSubTitleWidget(
      text: titleCurrency(isPaid, travelItem),
      size: 16.0.sp,
      fontWeight: FontWeight.w600,
    );
  }

  Widget widgetTitlePriceCurrency(bool isPaid, TravelModel travelItem, List<ExchangeRate>? exchangeRates) {
    return CustomSubTitleWidget(
      text: _titlePriceCurrency(isPaid, travelItem, exchangeRates),
      size: 16.0.sp,
      fontWeight: FontWeight.w600,
      color: primaryColor,
    );
  }

  bool _isToday(DateTime startDate) {
    final now = DateTime.now();
    return now.day == startDate.day && now.month == startDate.month && now.year == startDate.year;
  }

  bool _isCurrentDateInRange(DateTime startDate, DateTime endDate) {
    final currentDate = DateTime.now();
    bool isAfterDate = currentDate.isAfter(startDate);
    bool isBeforeDate = currentDate.isBefore(endDate);
    return isAfterDate && isBeforeDate;
  }

  double valuePrice(LoadingOrder? loadingOrder, List<ExchangeRate>? exchangeRates) {
    final double freightValue = loadingOrder?.carrierFreight?.freightValue ?? 0;
    final CarrierFreight? carrierFreight = loadingOrder?.carrierFreight;
    double currentExchangeRate = 0.0;
    const String dollar = "\$us";
    bool isDollar = false;
    if (carrierFreight != null) {
      String abbreviationTypeCurrencyFreight = carrierFreight.abbreviationtypeCurrencyFreight!;
      if (abbreviationTypeCurrencyFreight.isNotEmpty && abbreviationTypeCurrencyFreight == dollar) {
        isDollar = true;
        ExchangeRate? valuesExchanges =
            exchangeRates!.firstWhereOrNull((element) => element.typeMeasurementUnit == carrierFreight.typeCurrencyFreightId);
        if (valuesExchanges != null) {
          for (var element in valuesExchanges.values!) {
            if (element.initialDate != null && element.endDate != null) {
              bool currentDateInRange = _isCurrentDateInRange(element.initialDate!, element.endDate!);
              if (currentDateInRange) {
                currentExchangeRate = element.value!;
              }
              currentExchangeRate = element.value!;
            } else if (element.initialDate != null && element.endDate == null) {
              final currentDate = DateTime.now();
              bool currentDateInRange = element.initialDate!.isBefore(currentDate) || _isToday(element.initialDate!);
              if (currentDateInRange) {
                currentExchangeRate = element.value!;
              }
            }
          }
        }
      } else {
        currentExchangeRate = 0.0;
        isDollar = false;
      }
      if (carrierFreight.typeUnitMeasurement == null) {
        return isDollar ? (carrierFreight.freightValue ?? 0) * currentExchangeRate : (carrierFreight.freightValue ?? 0);
      } else {
        if (carrierFreight.typeUnitMeasurement == 'Peso') {
          final double value = loadingOrder?.weightUnit?.value ?? 0;
          return isDollar ? (value * freightValue) * currentExchangeRate : (value * freightValue);
        } else if (carrierFreight.typeUnitMeasurement == 'Distancia') {
          final double value = loadingOrder?.distanceUnit?.value ?? 0;
          return isDollar ? (value * freightValue) * currentExchangeRate : (value * freightValue);
        } else if (carrierFreight.typeUnitMeasurement == 'Volumen') {
          final double value = loadingOrder?.volumeUnit?.value ?? 0;
          return isDollar ? (value * freightValue) * currentExchangeRate : (value * freightValue);
        } else if (carrierFreight.typeUnitMeasurement == 'Tiempo') {
          final double value = loadingOrder?.timeUnit?.value ?? 0;
          return isDollar ? (value * freightValue) * currentExchangeRate : (value * freightValue);
        }
      }
    }
    return 0;
  }

  String _titlePriceCurrency(bool isPaid, TravelModel travelItem, List<ExchangeRate>? exchangeRates) {
    double? freightOfferedValue = travelItem.freightValues?.freightOffered?.value;
    if (isPaid) {
      double freightValue = travelItem.loadingOrder?.carrierFreight?.freightValue ?? 0;
      return freightValue.toStringAsFixed(1);
    } else {
      if (freightOfferedValue == null) {
        return 'Por negociar';
      } else {
        return (travelItem.freightValues?.freightOffered?.value ?? 0).toStringAsFixed(1);
      }
    }
  }

  static String titlePriceCurrencyOperation(op.Operation travelItem) {
    double? freightOfferedValue = travelItem.freightValues?.freightOffered?.value;
    if (freightOfferedValue == null) {
      return 'Por negociar';
    } else {
      return (travelItem.freightValues?.freightOffered?.value ?? 0).toStringAsFixed(1);
    }
  }
}
