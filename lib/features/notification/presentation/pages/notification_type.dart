import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/notification/data/models/notification_model.dart';
import 'package:appdriver/features/notification/presentation/bloc/notifications_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemNotificationType extends StatefulWidget {
  final NotificationModel newItem;
  final TypeFilter? typeFilter;
  final String? label;
  final VoidCallback? onPressed;
  const ItemNotificationType({
    Key? key,
    required this.newItem,
    this.onPressed,
    this.label,
    this.typeFilter,
  }) : super(key: key);

  @override
  _ItemNotificationTypeState createState() => _ItemNotificationTypeState();
}

class _ItemNotificationTypeState extends State<ItemNotificationType> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.newItem.createDate!.toLocal());

    Locale myLocale = Localizations.localeOf(context);
    var data = timeago.format(now.subtract(difference.abs()), locale: myLocale.languageCode);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 115,
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
                imageUrl: "",
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
                      height: 8,
                    ),
                    Expanded(
                      child: Text(
                        widget.newItem.message!,
                        maxLines: 3,
                        style: TextStyle(fontSize: 8.0.sp, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 18,
                          child: RoundedButton(
                            borderRadius: 14,
                            label: nameType(widget.label),
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
                            onPressed: widget.onPressed ?? () {},
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

String nameType(String? label) {
  if (label == "travel") {
    return "Oportunidades";
  }
  if (label == "AssignedLoadOrder") {
    return "Operaciones";
  }
  if (label == "postulationAccepted") {
    return "Postulación";
  }
  if (label == "tasks") {
    return "Operaciones";
  }
  if (label == "rejecttasks") {
    return "Operaciones";
  }
  if (label == 'cancelLoadingOrder') {
    return "Operaciones";
  }
  if (label == "travelPaid") {
    return "Operaciones";
  }
  return "Notificación";
}
