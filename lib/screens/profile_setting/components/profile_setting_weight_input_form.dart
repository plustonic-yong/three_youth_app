import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';

import '../../../utils/toast.dart';

class ProfileSettingWeightInputForm extends StatefulWidget {
  final double weight;
  const ProfileSettingWeightInputForm({Key? key, required this.weight})
      : super(key: key);

  @override
  State<ProfileSettingWeightInputForm> createState() =>
      _ProfileSettingWeightInputFormState();
}

class _ProfileSettingWeightInputFormState
    extends State<ProfileSettingWeightInputForm> {
  final TextEditingController _weightCon = TextEditingController();

  @override
  void initState() {
    _weightCon.text = widget.weight.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    double? _weight = context.watch<UserProvider>().userInfo!.weight;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          // padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          width: _screenWidth - 100.0,
          height: 40.0,
          child: TextFormField(
              controller: _weightCon,
              enableInteractiveSelection: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,4}\.?\d{0,1}')),
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: _screenHeight * 0.015),
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
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (double.parse(value) <= 300) {
                    context.read<UserProvider>().onChangeWeight(value: value);
                  } else {
                    context
                        .read<UserProvider>()
                        .onChangeHeight(value: widget.weight.toString());
                    _weightCon.clear();
                    showToast('300kg 이하로 입력해주세요');
                  }
                }
              }),
        ),
        const Text(
          'kg',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ],
    );
  }
}
