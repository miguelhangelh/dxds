part of 'global_widget.dart';

class CustomSubTitleWidget extends StatelessWidget {
  final String? text;
  final double size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final Color? color;

  const CustomSubTitleWidget({
    Key? key,
    required this.text,
    required this.size,
    this.padding,
    this.maxLines,
    this.margin,
    this.fontWeight = FontWeight.w400,
    this.textAlign,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Text(
        text ?? '',
        maxLines: maxLines ?? 5,
        style: GoogleFonts.montserrat(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
