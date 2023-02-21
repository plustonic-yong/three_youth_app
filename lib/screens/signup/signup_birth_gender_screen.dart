import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/utils/enums.dart';

class SignupBirthGenderScreen extends StatelessWidget {
  const SignupBirthGenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //생년월일
    TextEditingController _yearController =
        context.watch<SignupProvider>().yearController;

    TextEditingController _monthController =
        context.watch<SignupProvider>().monthController;

    TextEditingController _dayController =
        context.watch<SignupProvider>().dayController;

    //성별
    GenderState _gender = context.watch<SignupProvider>().gender;

    //생일
    DateTime _birth = context.watch<SignupProvider>().birth;

    return Column(
      children: [
        const Spacer(),
        //로고
        Image.asset(
          'assets/icons/ic_logo.png',
          width: width * 0.25,
        ),
        const Spacer(),
        const Text(
          '생년월일과 성별을 입력해주세요.\n(필수입력)',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        // SizedBox(height: height * 0.06),
        const Spacer(),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    enableDrag: false,
                    builder: (context) {
                      return SizedBox(
                        height: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                behavior: HitTestBehavior.translucent,
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200.0,
                              child: ScrollDatePicker(
                                locale: const Locale('ko'),
                                selectedDate: _birth,
                                minimumDate: DateTime(1910, 1, 1),
                                maximumDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                scrollViewOptions:
                                    const DatePickerScrollViewOptions(
                                        day: ScrollViewDetailOptions(
                                            margin: EdgeInsets.all(16),
                                            textStyle: TextStyle(fontSize: 20),
                                            selectedTextStyle:
                                                TextStyle(fontSize: 20)),
                                        month: ScrollViewDetailOptions(
                                            margin: EdgeInsets.all(16),
                                            textStyle: TextStyle(fontSize: 20),
                                            selectedTextStyle:
                                                TextStyle(fontSize: 20)),
                                        year: ScrollViewDetailOptions(
                                            margin: EdgeInsets.all(16),
                                            textStyle: TextStyle(fontSize: 20),
                                            selectedTextStyle:
                                                TextStyle(fontSize: 20))),
                                options:
                                    const DatePickerOptions(itemExtent: 35),
                                onDateTimeChanged: (value) async {
                                  context
                                      .read<SignupProvider>()
                                      .onChangeBirth(value: value);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                    color: const Color(0xff00000033).withOpacity(0.25),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text(
                  DateFormat('yyyy년 MM월 dd일').format(_birth),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            //성별
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read<SignupProvider>()
                        .onChangeGender(genderState: GenderState.woman);
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
                        color: _gender == GenderState.woman
                            ? Colors.white
                            : Colors.transparent,
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
                    context
                        .read<SignupProvider>()
                        .onChangeGender(genderState: GenderState.man);
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
                        color: _gender == GenderState.man
                            ? Colors.white
                            : Colors.transparent,
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
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
      ],
    );
  }
}
