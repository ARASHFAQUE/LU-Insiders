import 'package:flutter/material.dart';

class LogInBackground extends StatefulWidget {
  final Widget child;
  const LogInBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<LogInBackground> createState() => _LogInBackgroundState();
}

class _LogInBackgroundState extends State<LogInBackground> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width*0.4,
              )
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/bottom.png",
                width: size.width*0.4,
              )
          ),
          widget.child,
        ],
      ),
    );
  }
}