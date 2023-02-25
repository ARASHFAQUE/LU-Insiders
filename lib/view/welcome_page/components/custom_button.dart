import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.buttonColor,
    required this.buttonText,
    required this.textColor,
    required this.handleButtonClick,
  }) : super(key: key);

  final Color buttonColor;
  final String buttonText;
  final Color textColor;
  final Function handleButtonClick;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      child: ClipRect(
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15)),
            backgroundColor:
            MaterialStateProperty.all(widget.buttonColor),
          ),
          onPressed: () {
            widget.handleButtonClick();
          },
          child: Text(
              widget.buttonText,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor)),
        ),
      ),
    );
  }
}