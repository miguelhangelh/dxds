
part of 'global_widget.dart';

class CustomTitleWidget extends StatelessWidget {

  final String title;
  final double size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final FontWeight fontWeight;

  const CustomTitleWidget( {
    Key? key, 
    required this.title, 
    required this.size,
    this.padding,
    this.margin,
    this.fontWeight = FontWeight.w600,
  } ) : 

  super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: padding,
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: size,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
