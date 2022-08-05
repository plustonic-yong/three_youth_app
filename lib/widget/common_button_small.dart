import 'package:flutter/material.dart';

class CommonButtonSmall extends StatelessWidget {
  const CommonButtonSmall(
      {Key? key, required this.title, required this.isActive, this.onTap})
      : super(key: key);
  final String title;
  final bool isActive;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.0,
        height: 50.0,
        decoration: isActive
            ? BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.05,
                    0.5,
                  ],
                  colors: [
                    Color(0xff46DFFF),
                    Color(0xff00B1E9),
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
                color: const Color(0xffffffff).withOpacity(0.3),
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
