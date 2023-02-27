import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:provider/provider.dart';

class SignupNameScreen extends StatelessWidget {
  const SignupNameScreen({Key? key}) : super(key: key);

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
            '당신의 이름은 무엇인가요?',
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
                '15자 이하',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: height * 0.06),
          _nameInput(context: context, width: width, height: height)
        ],
      ),
    );
  }

  Widget _nameInput({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    TextEditingController _nameController =
        context.watch<SignupProvider>().nameController;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        maxLength: 15,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: height * 0.015),
          hintText: '홍길동',
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
        onChanged: (value) =>
            context.read<SignupProvider>().onChangeName(value: value),
      ),
    );
  }
}
