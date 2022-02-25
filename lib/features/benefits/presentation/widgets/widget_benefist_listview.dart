import 'package:appdriver/core/utils/colors.dart';
import 'package:appdriver/features/benefits/data/models/benefit_model.dart';
import 'package:appdriver/features/benefits/presentation/bloc/benefits_bloc.dart';
import 'package:flutter/material.dart';
import 'package:appdriver/features/benefits/presentation/widgets/widget_item_benefist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

class BuildDataBenefits extends StatefulWidget {
  final List<BenefitModel>? benefits;
  final VoidCallback? onRefresh;

  const BuildDataBenefits({Key? key, this.benefits, this.onRefresh}) : super(key: key);
  @override
  _BuildDataBenefitsState createState() => _BuildDataBenefitsState();
}

class _BuildDataBenefitsState extends State<BuildDataBenefits> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      footer: ClassicFooter(
        textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
        noDataText: 'No hay más oportunidades disponibles',
        idleText: 'Desliza hacia arriba carga más',
        canLoadingText: 'Suelte para cargar más',
        loadingText: "Cargando...",
      ),
      enablePullUp: false,
      controller: BlocProvider.of<BenefitsBloc>(context).refreshController,
      onRefresh: BlocProvider.of<BenefitsBloc>(context).onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemCount: widget.benefits!.length,
        itemBuilder: (BuildContext context, int index) {
          var benefit = widget.benefits![index];
          return WidgetItemBenefits(benefit: benefit);
        },
      ),
    );
  }
}
