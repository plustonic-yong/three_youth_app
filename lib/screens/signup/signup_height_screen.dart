import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SignupHeightScreen extends StatelessWidget {
  const SignupHeightScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 0.12),
        //로고
        Image.asset(
          'assets/icons/ic_logo.png',
          width: width * 0.25,
        ),
        SizedBox(height: height * 0.16),
        const Text(
          '키는 몇 이신가요?',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: height * 0.06),
        const SizedBox(height: 30.0),
        _heightInput(context: context, width: width, height: height)
      ],
    );
  }

  Widget _heightInput({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    TextEditingController _heightController =
        context.watch<SignupProvider>().heightController;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: TextField(
          controller: _heightController,
          enableInteractiveSelection: false,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: height * 0.015),
            hintText: 'cm',
            hintStyle: const TextStyle(color: Colors.white),
            // ignore: use_full_hex_values_for_flutter_colors
            fillColor: const Color(0xff00000033).withOpacity(0.25),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          onChanged: (value) {
            context.read<SignupProvider>().onChangeHeight(value: value);
          }),
    );
  }
}
