import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';

import '../../providers/ble_bp_provider.dart';

class BleBpScanCameraResultScreen extends StatelessWidget {
  const BleBpScanCameraResultScreen({
    Key? key,
    this.imgFile,
    this.sys,
    this.dia,
    this.pul,
  }) : super(key: key);

  final Uint8List? imgFile;
  final String? sys;
  final String? dia;
  final String? pul;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        //배경이미지
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text('인식결과'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
                Image.memory(imgFile!, width: 180.0),

                //스캔결과
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        //sys
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '수축기 혈압(SYS)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$sys',
                                    style: const TextStyle(
                                      color: Color(0xFFFFF898),
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Text(
                                    'mmHg',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //dia
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '이완기 혈압(DIA)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$dia',
                                    style: const TextStyle(
                                      color: Color(0xFFFFF898),
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Text(
                                    'mmHg',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //pul
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '분당맥박수(PUL)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$pul',
                                    style: const TextStyle(
                                      color: Color(0xFFFFF898),
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  const Text(
                                    '/min',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonButton(
                      height: 50.0,
                      width: 165.0,
                      title: '재촬영',
                      buttonColor: ButtonColor.inactive,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    CommonButton(
                      height: 50.0,
                      width: 165.0,
                      title: '결과저장',
                      buttonColor: ButtonColor.primary,
                      onTap: () async {
                        var result = await context
                            .read<BleBpProvider>()
                            .postBloodPressure(
                              sys: int.parse(sys!),
                              dia: int.parse(dia!),
                              pul: int.parse(pul!),
                            );
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(30.0),
                                actionsPadding: const EdgeInsets.all(10.0),
                                actions: [
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ],
                                content: Text(
                                  // ignore: unrelated_type_equality_checks
                                  result == BpSaveDataStatus.success
                                      ? '데이터 저장에 성공했습니다.'
                                      : '데이터 저장에 실패했습니다.',
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                CommonButton(
                  height: 50.0,
                  width: _screenWidth,
                  title: '홈으로',
                  buttonColor: ButtonColor.inactive,
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/main',
                    (route) => false,
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
