import 'package:appdriver/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownButtonFormFieldGeneric<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? labelText;
  final bool underline;
  const DropdownButtonFormFieldGeneric(
      {Key? key, this.value, required this.items, this.onChanged, this.labelText, this.validator, this.underline = false})
      : super(key: key);

  @override
  State<DropdownButtonFormFieldGeneric<T>> createState() => _DropdownButtonFormFieldGenericState<T>();
}

class _DropdownButtonFormFieldGenericState<T> extends State<DropdownButtonFormFieldGeneric<T>> {
  final UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color(0xffD9D9D9),
      width: 1,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: widget.underline ? const EdgeInsets.fromLTRB(0, 12, 0, 12) : null,
        border: widget.underline ? underlineInputBorder : null,
        disabledBorder: widget.underline ? underlineInputBorder : null,
        enabledBorder: widget.underline ? underlineInputBorder : null,
        focusedBorder: widget.underline ? const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1)) : null,
        labelText: widget.labelText,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_sharp),
      style: GoogleFonts.montserrat(
        fontSize: 16,
        color: const Color.fromRGBO(0, 0, 0, 0.6),
      ),
      value: widget.value,
      items: widget.items,
      onChanged: widget.onChanged,
    );
  }
}
