import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';

class BleBpScanMeasurementResult extends StatelessWidget {
  const BleBpScanMeasurementResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _dataIsOK = context.watch<BleBpProvider>().dataIsOK;

    // bool _isUpdated = context.watch<BleBpProvider>().isUpdated;
    List<double> _lDataSYS = context.read<BleBpProvider>().lDataSYS;
    List<double> _lDataDIA = context.read<BleBpProvider>().lDataDIA;
    List<double> _lDataPUL = context.read<BleBpProvider>().lDataPUL;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.read<BleBpProvider>().dataClear();
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text('측정결과'),
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              CircleAvatar(
                radius: 32.0,
                child: Image.asset(
                  'assets/images/profile_img_1.png',
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '홍길동님',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40.0),
              Image.asset(
                'assets/icons/ic_heart.png',
                width: 24.0,
              ),
              Text(
                _dataIsOK ? _lDataSYS.last.round().toString() : '-',
                style: const TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'bpm',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      //최저혈압
                      const CommonButton(
                        height: 25.0,
                        width: 80.0,
                        title: '최저혈압',
                        buttonColor: ButtonColor.inactive,
                        fontSize: 13.0,
                      ),
                      Text(
                        _dataIsOK ? _lDataDIA.last.round().toString() : '-',
                        style: const TextStyle(
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'mmHg',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  //최고혈압
                  Column(
                    children: [
                      const CommonButton(
                        height: 25.0,
                        width: 80.0,
                        title: '최고혈압',
                        buttonColor: ButtonColor.inactive,
                        fontSize: 13.0,
                      ),
                      Text(
                        _dataIsOK ? _lDataPUL.last.round().toString() : '-',
                        style: const TextStyle(
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'mmHg',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '저장',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {},
                  ),
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: 'PDF 공유',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '기록',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {},
                  ),
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '예방 콘텐츠',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
