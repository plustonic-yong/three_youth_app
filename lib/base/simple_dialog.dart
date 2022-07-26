import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';

void simpleDialog(BuildContext context, String title, String content, Function func) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorAssets.commonBackgroundDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Column(
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(color: ColorAssets.fontDarkGrey),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                content,
                style: const TextStyle(color: ColorAssets.fontDarkGrey),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorAssets.purpleGradient1),
              ),
              child: const Text(
                "취소",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(ColorAssets.purpleGradient1),
                ),
                child: const Text(
                  "확인",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => func()),
          ],
        );
      });
}
