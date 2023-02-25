import 'package:flutter/material.dart';

import '../custom_widget/my_theme.dart';


class TextFieldDecorator extends StatefulWidget {

  final Widget child;

  const TextFieldDecorator({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  State<TextFieldDecorator> createState() => _TextFieldDecoratorState();
}

class _TextFieldDecoratorState extends State<TextFieldDecorator> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: MyTheme.logInPageBoxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: widget.child,
    );
  }
}