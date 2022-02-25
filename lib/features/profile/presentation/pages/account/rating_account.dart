import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import 'account_page.dart';

class RatingAccountPage extends StatefulWidget {
  const RatingAccountPage({Key? key}) : super(key: key);
  @override
  _RatingAccountPageState createState() => _RatingAccountPageState();
}

class _RatingAccountPageState extends State<RatingAccountPage> {
  ProfileBloc bloc = sl<ProfileBloc>();
  final outputFormat = DateFormat("d 'de' MMMM, yyyy", 'es_ES');

  @override
  void initState() {
    super.initState();
    bloc.add(ProfileGetRating());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
        appBar: AppBar(
          title: CustomSubTitleWidget(
            text: 'Calificaciones',
            color: Colors.black,
            size: 18.0.sp, //13px
            fontWeight: FontWeight.w600,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              size: 35,
              color: Colors.black,
            ),
            onPressed: () {
              NavigatorExtension.pushAndRemoveUntil(const HomeMainView(), context);

            },
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.loading) {
              return Column(
                children: const [
                  Expanded(
                      child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ))
                ],
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomSubTitleWidget(
                              textAlign: TextAlign.right,
                              text: state.rating?.average?.toStringAsFixed(1) ?? "0",
                              color: Colors.black,
                              size: 30.0.sp, //13px
                              fontWeight: FontWeight.w500,
                            ),
                            RatingBarIndicator(
                              rating: state.rating?.average?.toDouble() ?? 0.0,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: primaryColor,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              unratedColor: primaryColor.withAlpha(70),
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomSubTitleWidget(
                              padding: const EdgeInsets.only(left: 3),
                              textAlign: TextAlign.right,
                              text: state.rating!.ratings!.length.toString(),
                              color: const Color(0xFF989898),
                              size: 10.0.sp, //13px
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CustomSubTitleWidget(
                                    textAlign: TextAlign.right,
                                    text: '5',
                                    color: Colors.black87,
                                    size: 10.0.sp, //13px
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return LinearPercentIndicator(
                                          animation: true,
                                          animateFromLastPercent: true,
                                          animationDuration: 1000,
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          width: constraints.maxWidth,
                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                          lineHeight: 10.0,
                                          percent: convertStringAverage(state.rating!.percentageFive!),
                                          backgroundColor: const Color(0xffD9D9D9),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  CustomSubTitleWidget(
                                    textAlign: TextAlign.right,
                                    text: '4',
                                    color: Colors.black87,
                                    size: 10.0.sp, //13px
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return LinearPercentIndicator(
                                          animation: true,
                                          animateFromLastPercent: true,
                                          animationDuration: 1000,
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          width: constraints.maxWidth,
                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                          lineHeight: 10.0,
                                          percent: convertStringAverage(state.rating!.percentageFour!),
                                          backgroundColor: const Color(0xffD9D9D9),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  CustomSubTitleWidget(
                                    textAlign: TextAlign.right,
                                    text: '3',
                                    color: Colors.black87,
                                    size: 10.0.sp, //13px
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return LinearPercentIndicator(
                                          animation: true,
                                          animateFromLastPercent: true,
                                          animationDuration: 1000,
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          width: constraints.maxWidth,
                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                          lineHeight: 10.0,
                                          percent: convertStringAverage(state.rating!.percentageThree!),
                                          backgroundColor: const Color(0xffD9D9D9),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  CustomSubTitleWidget(
                                    textAlign: TextAlign.right,
                                    text: '2',
                                    color: Colors.black87,
                                    size: 10.0.sp, //13px
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return LinearPercentIndicator(
                                          animation: true,
                                          animateFromLastPercent: true,
                                          animationDuration: 1000,
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          width: constraints.maxWidth,
                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                          lineHeight: 10.0,
                                          percent: convertStringAverage(state.rating!.percentageTwo!),
                                          backgroundColor: const Color(0xffD9D9D9),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  CustomSubTitleWidget(
                                    textAlign: TextAlign.right,
                                    text: '1',
                                    color: Colors.black87,
                                    size: 10.0.sp, //13px
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return LinearPercentIndicator(
                                          animation: true,
                                          animateFromLastPercent: true,
                                          animationDuration: 1000,
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          width: constraints.maxWidth,
                                          linearStrokeCap: LinearStrokeCap.roundAll,
                                          lineHeight: 10.0,
                                          percent: convertStringAverage(state.rating!.percentageOne!),
                                          backgroundColor: const Color(0xffD9D9D9),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
                Expanded(
                  child: Visibility(
                    visible: state.rating!.ratings!.isNotEmpty,
                    replacement: Container(
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
                            text: 'No tienes calificaciones y opiniones',
                            color: Colors.black,
                            size: 16.0.sp,
                            //13px
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
                              bloc.add(ProfileGetRating());
                            },
                          )
                        ],
                      ),
                    ),
                    child: RefreshIndicator(
                      displacement: 100,
                      backgroundColor: primaryColor,
                      color: Colors.white,
                      onRefresh: () async {
                        // await Future.delayed(Duration(seconds: 2));
                        bloc.add(ProfileGetRating());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        itemCount: state.rating!.ratings!.length,
                        itemBuilder: (context, index) {
                          var rating = state.rating!.ratings![index];
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 20, right: 0),
                                child: Container(
                                  margin: index == state.rating!.ratings!.length - 1 ? const EdgeInsets.all(0) : const EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomSubTitleWidget(
                                          padding: const EdgeInsets.only(left: 1),
                                          textAlign: TextAlign.right,
                                          text: 'DeltaX',
                                          color: Colors.black,
                                          size: 9.0.sp, //13px
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 15,
                                                child: RatingBarIndicator(
                                                  rating: rating.value!.toDouble(),
                                                  itemBuilder: (context, index) => const Icon(
                                                    Icons.star,
                                                    color: primaryColor,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 15.0,
                                                  unratedColor: primaryColor.withAlpha(70),
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                height: 15,
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: CustomSubTitleWidget(
                                                    textAlign: TextAlign.right,
                                                    text: outputFormat.format(rating.account!.createDate!.toLocal())[0].toUpperCase() +
                                                        outputFormat.format(rating.account!.createDate!.toLocal()).substring(1),
                                                    color: const Color(0xFF989898),
                                                    size: 8.0.sp, //13px
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        CustomSubTitleWidget(
                                          padding: const EdgeInsets.only(left: 3),
                                          text: rating.commentary,
                                          color: const Color(0xFF989898),
                                          maxLines: 3,
                                          size: 8.0.sp, //13px
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:  AssetImage('assets/Logo2.png'),
                                  backgroundColor: Colors.white,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double convertStringAverage(String value) {
    try {
      double newValue = double.parse(value) / 100;
      if (newValue > 1.0) {
        return 1.0;
      }
      if (newValue < 0.0) {
        return 0.0;
      }
      return newValue;
    } catch (e) {
      return 0.0;
    }
  }
}
