import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/toast.dart';

class SignupWeightScreen extends StatelessWidget {
  const SignupWeightScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: height * 0.12),
          //로고
          Image.asset(
            'assets/icons/ic_logo.png',
            width: width * 0.25,
          ),
          SizedBox(height: height * 0.16),
          const Text(
            '몸무게는 어떻게 되세요?',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '(필수입력)',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(width: 8),
              Text(
                '300kg 이하',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: height * 0.06),
          _weightInput(context: context, width: width, height: height)
        ],
      ),
    );
  }

  Widget _weightInput({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    TextEditingController _weightController =
        context.watch<SignupProvider>().weightController;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: TextField(
          controller: _weightController,
          enableInteractiveSelection: false,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          scrollPadding: EdgeInsets.all(100),
          maxLength: 3,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: height * 0.015),
            hintText: 'kg',
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
            counterText: '',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (int.parse(value) <= 300) {
                context.read<SignupProvider>().onChangeWeight(value: value);
              } else {
                showToast('300kg 이하로 입력해주세요');
                _weightController.clear();
              }
            }
          }),
    );
  }
}
