import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ashfaque_project/view/custom_widget/my_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserPassField extends StatefulWidget {
  const UserPassField({
    Key? key,
    required this.userPassController,
    required this.userPassErrorText,
    required this.userPassHintText,
    required this.userPassHintTextColor,
    required this.userPassTextFieldPrefixIcon,
    required this.userPassTextFieldPrefixIconColor,
    required this.inputType,
    required this.onUserPassValueChange,
    required this.suffixIcon,
    required this.suffixIconColor
  }) : super(key: key);

  final TextEditingController userPassController;
  final String userPassErrorText;
  final String userPassHintText;
  final Color userPassHintTextColor;
  final IconData userPassTextFieldPrefixIcon;
  final Color userPassTextFieldPrefixIconColor;
  final TextInputType inputType;
  final Function onUserPassValueChange;
  final IconData suffixIcon;
  final Color suffixIconColor;



  @override
  State<UserPassField> createState() => _UserPassFieldState();
}

class _UserPassFieldState extends State<UserPassField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.userPassController,
      validator: (value) {
        if (value!.isEmpty || value.length < 8) {
          return widget.userPassErrorText;
        } else {
          return null;
        }
      },
      onChanged: (value) {
        widget.onUserPassValueChange(value);
      },
      keyboardType: widget.inputType,
      cursorColor: Colors.black,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      obscureText: isVisible ? false : true,
      decoration: InputDecoration(
        hintText: widget.userPassHintText,
        hintStyle: TextStyle(color: widget.userPassHintTextColor),
        border: InputBorder.none,
        prefixIcon: Icon(
          widget.userPassTextFieldPrefixIcon,
          color: widget.userPassTextFieldPrefixIconColor,
        ),
        suffixIcon: IconButton(
          icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
          color: widget.suffixIconColor,
          onPressed: (){
            setState((){
              isVisible = !isVisible;
            });
            // TODO: will use getx here
          },
        ),
      ),
    );
  }
}