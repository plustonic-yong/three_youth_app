import 'package:flutter/material.dart';

class InitProfileSettingInput extends StatefulWidget {
  const InitProfileSettingInput({Key? key, required this.page})
      : super(key: key);
  final int page;

  @override
  State<InitProfileSettingInput> createState() =>
      _InitProfileSettingInputState();
}

class _InitProfileSettingInputState extends State<InitProfileSettingInput> {
  int _gender = 0;
  @override
  Widget build(BuildContext context) {
    return widget.page != 3
        ? Container(
            // width: 308.0,
            height: 50.0,
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: TextField(
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.page == 0
                    ? '이름'
                    : widget.page == 1
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
            ),
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //년도
                  SizedBox(
                    width: 90.0,
                    height: 50.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
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
                  const SizedBox(width: 8.0),
                  const Text(
                    '년',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(width: 22.0),
                  //월
                  SizedBox(
                    width: 64.0,
                    height: 50.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '월',
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
                  const SizedBox(width: 8.0),
                  const Text(
                    '월',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(width: 22.0),
                  //일
                  SizedBox(
                    width: 64.0,
                    height: 50.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '일',
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
                  const SizedBox(width: 8.0),
                  const Text(
                    '일',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(width: 22.0),
                ],
              ),
              const SizedBox(height: 60.0),
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
}
