import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';

class SignupInput extends StatefulWidget {
  const SignupInput({Key? key, required this.page}) : super(key: key);
  final int page;

  @override
  State<SignupInput> createState() => _SignupInputState();
}

class _SignupInputState extends State<SignupInput> {
  int _gender = 0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _tallController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _dayController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return widget.page != 5
        ? _textInput(width: width, height: height)
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //년도
                  SizedBox(
                    width: width * 0.2,
                    height: height * 0.045,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: '년도',
                        hintStyle: const TextStyle(color: Colors.white),
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  const Text(
                    '년',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: width * 0.06),
                  //월
                  SizedBox(
                    width: width * 0.15,
                    height: height * 0.045,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '월',
                        hintStyle: const TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  const Text(
                    '월',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: width * 0.06),
                  //일
                  SizedBox(
                    width: width * 0.15,
                    height: height * 0.045,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '일',
                        hintStyle: const TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  const Text(
                    '일',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: width * 0.06),
                ],
              ),
              SizedBox(height: height * 0.05),
              //성별
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gender = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color:
                              _gender == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  const Text(
                    '여자',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  const SizedBox(width: 69.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _gender = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color:
                              _gender == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  const Text(
                    '남자',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              )
            ],
          );
  }

  Widget _textInput({
    required double width,
    required double height,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: TextField(
        controller: widget.page == 2
            ? _nameController
            : widget.page == 3
                ? _tallController
                : _weightController,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: height * 0.015),
          hintText: widget.page == 2
              ? '이름'
              : widget.page == 3
                  ? 'cm'
                  : 'kg',
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
        onChanged: (value) {},
      ),
    );
  }
}
