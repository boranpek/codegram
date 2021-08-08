import 'package:flutter/material.dart';

class CustomButtonExtended extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Function onPress;
  final Color buttonTextColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool? enabled;
  final bool isDisabled;
  final double? width;
  const CustomButtonExtended({
    Key? key,
    required this.text,
    required this.buttonColor,
    required this.onPress,
    required this.buttonTextColor,
    this.borderColor,
    this.borderWidth,
    this.enabled,
    this.isDisabled = false,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDisabled ? Colors.red : buttonTextColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shadowColor: Colors.transparent,
          side: BorderSide(
            width: borderWidth ?? 0.0,
            color: borderColor ?? Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              34,
            ),
          ),
          elevation: 0,
        ),
        onPressed: isDisabled ? null : onPress as void Function()?,
      ),
    );
  }
}
