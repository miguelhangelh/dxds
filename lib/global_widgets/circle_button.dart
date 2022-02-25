
part of 'global_widget.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final double size;
  final Color backgroundColor, iconColor;
  const CircleButton({
    Key? key,
    required this.onPressed,
    required this.iconPath,
    this.size = 40,
    this.backgroundColor = primaryColor,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding:  EdgeInsets.zero,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconPath,
          color: iconColor,
        ),
      ),
    );
  }
}
