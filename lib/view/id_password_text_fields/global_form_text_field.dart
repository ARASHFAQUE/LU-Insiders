import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalFormTextField extends StatefulWidget{

  const GlobalFormTextField({
    Key? key,
    required this.valueKey,
    required this.controller,
    required this.enabled,
    required this.fct,
    required this.jobErrorText,
    required this.jobHintText,
    required this.jobHintTextColor,
    required this.jobTextFieldPrefixIcon,
    required this.jobTextFieldPrefixIconColor,
    required this.inputType,
    this.maxLines = 1,
  }) : super(key: key);


  final String valueKey;
  final TextEditingController controller;
  final bool enabled;
  final Function fct;
  final int maxLines;
  final String jobErrorText;
  final String jobHintText;
  final Color jobHintTextColor;
  final IconData jobTextFieldPrefixIcon;
  final Color jobTextFieldPrefixIconColor;
  final TextInputType inputType;

  @override
  State<GlobalFormTextField> createState() => _GlobalFormTextFieldState();
}

class _GlobalFormTextFieldState extends State<GlobalFormTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: (){
          widget.fct();
        },
        child: TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          key: ValueKey(widget.valueKey),
          maxLines: widget.maxLines,
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is Missing";
            } else {
              return null;
            }
          },
          onChanged: (value) {

          },
          keyboardType: widget.inputType,
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: widget.jobHintText,
            hintStyle: TextStyle(color: widget.jobHintTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(
              widget.jobTextFieldPrefixIcon,
              color: widget.jobTextFieldPrefixIconColor,
            ),
          ),
        ),
      ),
    );
  }
}

