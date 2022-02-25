import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/features/benefits/data/models/benefit_model.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WidgetItemBenefits extends StatelessWidget {
  final BenefitModel? benefit;
  const WidgetItemBenefits({Key? key, this.benefit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GestureDetector(
            onTap: () {
              var message = "${greetingMessage()}, le hablo por el beneficio ${benefit!.name} publicado en la app de DeltaX";
              var url = "whatsapp://send?phone=+${benefit!.phone}&text=${Uri.encodeFull(message)}";
              launchInBrowser(url, context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCachedImageBenefits(benefit!, constraints),
                buildTitle(),
                buildDescription(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDescription() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  benefit?.description ?? "",
                  maxLines: 2,
                  style: TextStyle(fontSize: 7.0.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Text(
                benefit?.name ?? "",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 9.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCachedImageBenefits(BenefitModel benefit, BoxConstraints constraints) {
    return CachedNetworkImage(
      imageUrl: benefit.path ?? "",
      imageBuilder: (context, imageProvider) => buildImage(constraints, imageProvider, benefit),
      placeholder: (context, url) => Container(
        height: constraints.maxHeight * 0.7,
        width: constraints.maxWidth,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          color: Colors.white,
        ),
        child: const Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => buildImageError(constraints, benefit),
    );
  }

  Widget buildImageError(BoxConstraints constraints, BenefitModel benefit) {
    return Stack(
      children: [
        Container(
          height: constraints.maxHeight * 0.70,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            color: Colors.white,
            image: DecorationImage(
              image: ExactAssetImage('assets/Logo2.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        buildImageWhatsapp(),
        buildPercentage(benefit),
        buildPrice(benefit),
      ],
    );
  }

  Widget buildImage(BoxConstraints constraints, ImageProvider<Object> imageProvider, BenefitModel benefit) {
    return Stack(
      children: [
        buildImageItem(constraints, imageProvider),
        buildImageWhatsapp(),
        buildPercentage(benefit),
        buildPrice(benefit),
      ],
    );
  }

  Positioned buildPrice(BenefitModel benefit) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(14),
                ),
                color: primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CustomSubTitleWidget(
                      text: 'Precio',
                      color: Colors.white,
                      size: 8.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Center(
                    child: CustomSubTitleWidget(
                      text: '${benefit.price ?? "0"} Bs',
                      color: Colors.white,
                      size: 10.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Visibility buildPercentage(BenefitModel benefit) {
    return Visibility(
      visible: (benefit.percentage != null && benefit.percentage != 0),
      child: Positioned(
        top: 0,
        left: 0,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 25,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                color: Color(0xff2DAA58),
              ),
              child: Center(
                child: CustomSubTitleWidget(
                  text: '${benefit.percentage ?? "0"} %',
                  color: Colors.white,
                  size: 10.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildImageWhatsapp() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        height: 30,
        width: 30,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
          image: DecorationImage(
            image: ExactAssetImage('assets/wp.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Container buildImageItem(BoxConstraints constraints, ImageProvider<Object> imageProvider) {
    return Container(
      height: constraints.maxHeight * 0.70,
      width: constraints.maxWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        color: Colors.white,
        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
      ),
    );
  }
}
