import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const spinkit = Center(
  child: SizedBox(
    height: 500,
    child: SpinKitFadingCircle(
      color: ColorAssets.white,
      size: 66.0,
    ),
  ),
);
