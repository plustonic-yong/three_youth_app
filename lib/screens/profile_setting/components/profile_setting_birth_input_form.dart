import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';

class ProfileSettingBirthInputForm extends StatelessWidget {
  const ProfileSettingBirthInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //년도
        Row(
          children: [
            SizedBox(
              width: 80.0,
              height: 40.0,
              child: TextFormField(
                initialValue: '1999',
                readOnly: true,
                enableInteractiveSelection: false,
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
                onChanged: (value) =>
                    context.read<SignupProvider>().onChangeYear(value: value),
              ),
            ),
            const SizedBox(width: 10.0),
            const Text(
              '년',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        //월
        Row(
          children: [
            SizedBox(
              width: 60.0,
              height: 40.0,
              child: TextFormField(
                initialValue: '08',
                enableInteractiveSelection: false,
                readOnly: true,
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
                onChanged: (value) =>
                    context.read<SignupProvider>().onChangeMonth(value: value),
              ),
            ),
            const SizedBox(width: 10.0),
            const Text(
              '월',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        //일
        Row(
          children: [
            SizedBox(
              width: 60.0,
              height: 40.0,
              child: TextFormField(
                initialValue: '08',
                enableInteractiveSelection: false,
                readOnly: true,
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
                onChanged: (value) =>
                    context.read<SignupProvider>().onChangeDay(value: value),
              ),
            ),
            const SizedBox(width: 10.0),
            const Text(
              '일',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
