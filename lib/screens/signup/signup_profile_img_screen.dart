import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';

class SignupProfileImgScreen extends StatelessWidget {
  const SignupProfileImgScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    XFile? _selectedImg = context.watch<SignupProvider>().selectedImg;
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
          '프로필 사진을 등록해주세요',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        const Text(
          '(선택사항)',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),

        const Spacer(),
        GestureDetector(
          onTap: () async {
            final ImagePicker _picker = ImagePicker();
            XFile? value = await _picker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 750,
              maxHeight: 750,
            );
            context.read<SignupProvider>().onChangeProfileImg(value: value!);
          },
          child: _selectedImg != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(90.0),
                  child: Image.file(
                    File(_selectedImg.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/camera.png',
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                ),
        ),
        const Spacer(),
        // GestureDetector(
        //   onTap: () => context.read<SignupProvider>().onDeleteProfileImg(),
        //   child: const Text(
        //     '삭제',
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
