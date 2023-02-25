import 'package:flutter/material.dart';

import '../custom_widget/my_theme.dart';


class MoreInfo extends StatefulWidget {

  final Widget child;

  const MoreInfo({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            width: size.width * 0.9,
            height: 120,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: MyTheme.logInPageBoxColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: widget.child,
          ),
        );
      }
    );
  }
}