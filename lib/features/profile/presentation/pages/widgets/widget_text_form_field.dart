import 'package:appdriver/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldGeneric extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final bool? enabled;
  final bool readOnly;
  final String? initialValue;
  final String? labelText;
  final Widget? suffixIcon;
  final bool underline;
  final GestureTapCallback? onTap;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  const TextFormFieldGeneric({
    Key? key,
    this.inputFormatters,
    this.validator,
    this.enabled = true,
    this.underline = false,
    this.readOnly = false,
    this.initialValue,
    this.textCapitalization = TextCapitalization.none,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.suffixIcon,
    this.onTap,
  }) : super(key: key);
  @override
  _TextFormFieldGenericState createState() => _TextFormFieldGenericState();
}

class _TextFormFieldGenericState extends State<TextFormFieldGeneric> {
  final UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color(0xffD9D9D9),
      width: 1,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textCapitalization: widget.textCapitalization,
      key: Key(widget.initialValue ?? ""),
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      initialValue: widget.initialValue,
      onTap: widget.onTap,
      decoration: InputDecoration(
        contentPadding: widget.underline ? const EdgeInsets.fromLTRB(0, 12, 0, 12) : null,
        border: widget.underline ? underlineInputBorder : null,
        disabledBorder: widget.underline ? underlineInputBorder: null,
        enabledBorder: widget.underline ? underlineInputBorder: null,
        focusedBorder: widget.underline ? const UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1,
          ),
        ): null,
        hintText: widget.hintText,
        labelText: widget.labelText,
        suffixIcon: widget.suffixIcon,
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
