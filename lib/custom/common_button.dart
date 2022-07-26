import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.screenWidth,
    required this.txt,
    required this.onPressed,
  }) : super(key: key);

  final double screenWidth;
  final String txt;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        height: 55,
        width: screenWidth,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[ColorAssets.greenGradient1, ColorAssets.purpleGradient2],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(
            txt,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
