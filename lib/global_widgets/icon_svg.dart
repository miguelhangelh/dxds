part of 'global_widget.dart';

class IconSvgWidget extends StatelessWidget {
  final double size;
  final String image;
  final EdgeInsets? padding;
  final Color? color;
  const IconSvgWidget({Key? key, required this.size, required this.image, this.color, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: padding ?? EdgeInsets.all(size * 0.15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      child: SvgPicture.asset(
        image,
        color: color ?? Colors.black,
        width: size * 0.6,
        height: size * 0.6,
      ),
    );
  }
}
