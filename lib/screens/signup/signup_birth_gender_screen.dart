import 'package:flutter/material.dart';
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

    return Column(
      children: [
        SizedBox(height: height * 0.12),
        //로고
        Image.asset(
          'assets/icons/logo.png',
          width: width * 0.25,
        ),
        SizedBox(height: height * 0.16),
        const Text(
          '생년월일과 성별을 입력해주세요.',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: height * 0.06),
        const SizedBox(height: 30.0),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //년도
                SizedBox(
                  width: width * 0.2,
                  height: height * 0.045,
                  child: TextField(
                    controller: _yearController,
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
                    onChanged: (value) => context
                        .read<SignupProvider>()
                        .onChangeYear(value: value),
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
                    controller: _monthController,
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
                    onChanged: (value) => context
                        .read<SignupProvider>()
                        .onChangeMonth(value: value),
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
                    controller: _dayController,
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
                    onChanged: (value) => context
                        .read<SignupProvider>()
                        .onChangeDay(value: value),
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
            )
          ],
        ),
      ],
    );
  }
}
