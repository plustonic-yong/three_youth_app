import 'package:flutter/material.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';

class ProfileSettingIdInputForm extends StatelessWidget {
  const ProfileSettingIdInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    UserModel? _userInfo = context.read<UserProvider>().userInfo;
    return Row(
      children: [
        const Text(
          'ID',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(width: 10.0),
        SizedBox(
          width: 200.0,
          height: 40.0,
          child: TextFormField(
            initialValue: '${_userInfo?.code}',
            readOnly: true,
            enableInteractiveSelection: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: height * 0.01),
              hintText: 'id',
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
        ),
      ],
    );
  }
}
