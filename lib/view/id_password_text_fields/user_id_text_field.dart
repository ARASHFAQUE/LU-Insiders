import 'package:flutter/material.dart';
import 'package:ashfaque_project/view/custom_widget/my_theme.dart';

class UserIdField extends StatefulWidget {
  const UserIdField({
    Key? key,
    required this.userIdController,
    required this.userIdErrorText,
    required this.userIdHintText,
    required this.userIdHintTextColor,
    required this.userIdTextFieldPrefixIcon,
    required this.userIdTextFieldPrefixIconColor,
    required this.inputType,
    required this.onUserIdValueChange,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController userIdController;
  final String userIdErrorText;
  final String userIdHintText;
  final Color userIdHintTextColor;
  final IconData userIdTextFieldPrefixIcon;
  final Color userIdTextFieldPrefixIconColor;
  final Function onUserIdValueChange;
  final TextInputType inputType;
  final int maxLines;


  @override
  State<UserIdField> createState() => _UserIdFieldState();
}

class _UserIdFieldState extends State<UserIdField> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextFormField(
        controller: widget.userIdController,
        maxLines: widget.maxLines,
        validator: (value) {
          if (value!.isEmpty) {
            return "Value is Missing";
          } else {
            return null;
          }
        },
        onChanged: (value) {
          widget.onUserIdValueChange(value);
        },
        keyboardType: widget.inputType,
        cursorColor: Colors.black,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        decoration: InputDecoration(
          hintText: widget.userIdHintText,
          hintStyle: TextStyle(color: widget.userIdHintTextColor),
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.userIdTextFieldPrefixIcon,
            color: widget.userIdTextFieldPrefixIconColor,
          ),
        ),
      ),
    );
  }
}