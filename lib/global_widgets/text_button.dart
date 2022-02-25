part of 'global_widget.dart';

class TextButtonWidget extends StatelessWidget {
  final String title;
  final double size;
  final void Function() onPressed;
  final FontWeight fontWeight;
  final Color color;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const TextButtonWidget({
    Key? key,
    required this.title,
    required this.size,
    required this.onPressed,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.orange,
    this.backgroundColor = Colors.transparent,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(color),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          // overlayColor: MaterialStateProperty.all( Colors.grey[100] ),
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              // side: BorderSide(color: Colors.red),
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: size,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
