part of 'global_widget.dart';

class CustomTextArea extends StatefulWidget {
  final String label;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? textController;
  final void Function(String text)? onChanged;
  final String Function(String? text)? validator;
  final TextInputType keyboardType;

  const CustomTextArea({
    Key? key,
    this.margin,
    this.label = "",
    this.textController,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  _CustomTextAreaState createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
 final FocusNode _myFocusNode =  FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.textController,
        onChanged: widget.onChanged,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        focusNode: _myFocusNode,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: (_myFocusNode.hasFocus ? Colors.orange : const Color(0xFF707070)),
            fontWeight: FontWeight.w400,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.orange,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
