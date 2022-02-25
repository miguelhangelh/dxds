part of 'global_widget.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final String label2;
  final Color textColor, backgroundColor, borderColor;
  final bool fullWidth;
  final EdgeInsets padding;
  final FontWeight? fontWeight;
  final bool? loading;
  final double? fontSize;
  final double borderRadius;
  final double height;
  final bool underline;
  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.label2 = '',
    this.borderRadius = 11,
    this.fontWeight,
    this.underline = false,
    this.height = 46,
    this.loading = false,
    this.textColor = Colors.white,
    this.backgroundColor = primaryColor,
    this.borderColor = primaryColor,
    this.fullWidth = true,
    this.padding = const EdgeInsets.all(0),
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      borderRadius: BorderRadius.circular(borderRadius),
      disabledColor: const Color.fromRGBO(0, 0, 0, 0.12),
      color: backgroundColor,
      minSize: height,
      child: Container(
        height: height,
        padding: padding,
        width: fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            width: 1,
            color: loading == true ? const Color.fromRGBO(0, 0, 0, 0.12) : borderColor,
          ),
        ),
        child: loading == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  label2.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: FontStyles.normal.copyWith(
                                fontWeight: FontWeight.w700,
                                color: textColor,
                                fontSize: fontSize ?? 12.0.sp,
                              ),
                            ),
                            Text(
                              label2,
                              textAlign: TextAlign.center,
                              style: FontStyles.normal.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff989898),
                                fontSize: fontSize ?? 12.0.sp,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          style: FontStyles.normal.copyWith(
                              fontWeight: fontWeight ?? FontWeight.w700,
                              color: textColor,
                              fontSize: fontSize ?? 12.0.sp,
                              decorationThickness: 2,
                              decoration: underline ? TextDecoration.underline : TextDecoration.none),
                        ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: height / 2,
                      width: height / 2,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 0, 0, 0.12)),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      padding: EdgeInsets.zero,
      onPressed: loading == true ? null : onPressed,
    );
  }
}
