
import 'package:flutter/material.dart';
import 'package:appdriver/core/utils/utils.dart';
import 'package:appdriver/global_widgets/global_widget.dart';

class SuccessPage extends StatelessWidget {

  static const String routeName = 'success_page';
  final double heighTop;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;
  final void Function()? onPressed;

  const SuccessPage( {
    Key? key,
    this.heighTop = 0.0,
    this.title = 'Foto subida exitosamente', 
    this.subtitle = '',
    this.description = 'Los datos registrados van a ser verificados por nuestro equipo, que se pondrá en contacto contigo.',
    this.buttonText = 'Ver oportunidades',
    this.onPressed,
    } ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - heighTop,
        color: const Color.fromRGBO(45, 170, 88, 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: _responsive.height,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomSubTitleWidget(
                        text: title,
                        textAlign: TextAlign.center,
                        size: _responsive.dp(3.5),
                        color: const Color(0xFF2DAA58),
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        padding:  EdgeInsets.only( top: _responsive.dp(3.5), ),
                        child: Icon(
                          Icons.check_circle,
                          size: _responsive.dp(9.5),
                          color: const Color(0xFF2DAA58),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              width: _responsive.width,
              height: _responsive.dp(27.5),
              padding:  EdgeInsets.only(
                top: _responsive.wp(7.0),
                left: _responsive.wp(10.0),
                right: _responsive.wp(12.0),
                bottom: _responsive.wp(5.3),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTitleWidget(
                        title: subtitle,
                        size: _responsive.dp(3.2),
                      ),
                      CustomSubTitleWidget(
                        padding: const EdgeInsets.only(top: 7.5),
                        text: description,
                        size: _responsive.dp(1.8),
                      ),
                    ],
                  ),
                  RoundedButton(
                    label: 'Continuar',
                    onPressed: onPressed,

                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

