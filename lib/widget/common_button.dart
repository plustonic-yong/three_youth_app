import 'package:flutter/material.dart';

enum ButtonColor {
  primary,
  white,
  orange,
  inactive,
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    required this.height,
    required this.width,
    required this.title,
    required this.buttonColor,
    this.onTap,
  });
  final double height;
  final double width;
  final String title;
  final ButtonColor buttonColor;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 150.0,
        // height: 50.0,
        width: width,
        height: height,
        decoration: buttonColor == ButtonColor.primary ||
                buttonColor == ButtonColor.orange
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.05,
                    0.5,
                  ],
                  colors: buttonColor == ButtonColor.primary
                      ? const [
                          Color(0xff46DFFF),
                          Color(0xff00B1E9),
                        ]
                      : const [
                          Color(0xffFFAE43),
                          Color(0xffE58200),
                        ],
                ),
                boxShadow: const [
                  BoxShadow(
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xff00000029),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(
                      0,
                      3,
                    ), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0),
              )
            : BoxDecoration(
                color: buttonColor == ButtonColor.inactive
                    ? const Color(0xffffffff).withOpacity(0.3)
                    : Color(0xFFF0F0F0),
                boxShadow: const [
                  BoxShadow(
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xff00000029),
                    spreadRadius: 5,
                    blurRadius: 7,
                    // changes position of shadow
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0),
              ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: buttonColor == ButtonColor.white
                  ? Colors.black
                  : Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
