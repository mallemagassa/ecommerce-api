import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    this.keys,
    required this.name,
    this.hintText,
    this.valideType,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.initialValue,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.autofillHints,
    this.textAlign = TextAlign.left,
    this.enabled = true,
    this.onChanged,
    this.textAlignVertical,
    this.decoration = const InputDecoration(
      labelStyle: TextStyle(color: Colors.black),
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    ),
  });

  final String? keys;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final String name;
  final TextInputType? keyboardType;
  final String? Function(String?)? valideType;
  final String? initialValue;
  final int? minLines;
  final int? maxLines;
  final Iterable<String>? autofillHints;
  final InputDecoration decoration;
  final TextAlign textAlign;
  final bool enabled;
  final TextAlignVertical? textAlignVertical;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 7),
        width: double.infinity,
        child: FormBuilderTextField(
          key: ValueKey(keys),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: decoration,
          name: name,
          validator: valideType,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
          obscureText: obscureText,
          initialValue: initialValue,
          maxLines: maxLines,
          minLines: minLines,
          autofillHints: autofillHints,
          textAlign: textAlign,
          style: const TextStyle(color: Colors.black),
          enabled: enabled,
          onChanged: onChanged,
          textAlignVertical:textAlignVertical,
        ));
  }
}
