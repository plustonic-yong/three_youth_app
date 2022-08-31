import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileSettingHeightInputForm extends StatelessWidget {
  const ProfileSettingHeightInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    int? _height = context.watch<UserProvider>().userInfo!.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          // padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          width: _screenWidth - 100.0,
          height: 40.0,
          child: TextFormField(
            initialValue: '$_height',
            enableInteractiveSelection: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: _screenHeight * 0.015),
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
            onChanged: (value) =>
                context.read<UserProvider>().onChangeHeight(value: value),
          ),
        ),
        const Text(
          'cm',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ],
    );
  }
}
