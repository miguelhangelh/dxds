import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/benefits/presentation/bloc/benefits_bloc.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:appdriver/global_widgets/loading/widget_loading.dart';
import 'package:appdriver/global_widgets/empty/empty_message_data.dart';
import 'package:appdriver/features/benefits/presentation/widgets/widget_benefist_listview.dart';

class BenefitsPage extends StatefulWidget {
  const BenefitsPage({Key? key}) : super(key: key);

  @override
  _BenefitsPageState createState() => _BenefitsPageState();
}

class _BenefitsPageState extends State<BenefitsPage> {
  BenefitsBloc bloc = sl<BenefitsBloc>();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  UserPreference userPreference = UserPreference();
  @override
  void initState() {
    super.initState();
    bloc.add(GetBenefits());
    analytics.logEvent(name: 'Beneficios');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: const CustomSubTitleWidget(
            text: 'Beneficios',
            color: Colors.black,
            size: 24, //13px
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<BenefitsBloc, BenefitState>(
            builder: (context, state) {
              if (state.loading!) {
                return const Center(
                  child: LoadingProgress(),
                );
              }
              if (state.benefits!.isNotEmpty) {
                return BuildDataBenefits(
                  benefits: state.benefits,
                  onRefresh: () async {
                    bloc.add(GetBenefits());
                  },
                );
              } else {
                return EmptyDataMessage(
                  message: 'No hay beneficios en este momento',
                  onPressed: () {
                    bloc.add(GetBenefits());
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
