import 'package:flutter/material.dart';
import 'package:three_youth_app/widget/common_button.dart';

class BleBpScanMesurementScreen extends StatefulWidget {
  const BleBpScanMesurementScreen({Key? key}) : super(key: key);

  @override
  State<BleBpScanMesurementScreen> createState() =>
      _BleBpScanMesurementScreenState();
}

class _BleBpScanMesurementScreenState extends State<BleBpScanMesurementScreen> {
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
            title: const Text('측정결과 대기중'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                Center(
                  child: Image.asset('assets/images/sphygmomanometer_1.png'),
                ),
                const SizedBox(height: 20.0),
                const Center(
                  child: Text(
                    '측정 중입니다...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Container(
                  padding: const EdgeInsets.all(25.0),
                  width: _screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text('・'),
                          Expanded(
                            child: Text(
                              '반드시 설명서의 유의사항에 따라주세요.',
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const Text('\n'),
                      Row(
                        children: const [
                          Text('・'),
                          Expanded(
                            child: Text(
                              '등을 세우고 바르게 앉아 측정해 주세요.',
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const Text('\n'),
                      Row(
                        children: const [
                          Text('・'),
                          Expanded(
                            child: Text(
                              '팔의 측정기 높이를 심장 높이가 되도록 해주세요.',
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const Text('\n'),
                      Row(
                        children: const [
                          Text('・'),
                          Expanded(
                            child: Text(
                              '측정 중에는 몸에 긴장을 푼 편안한 상태에서 최대한 안정을 취해주세요.',
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const Text('\n'),
                      Row(
                        children: const [
                          Text('・'),
                          Expanded(
                              child: Text(
                            '몸을 움직이거나 말을 하거나 팔에 힘을 주지 마세요.',
                            overflow: TextOverflow.clip,
                          ))
                        ],
                      ),
                      // Text(
                      //   '・반드시 설명서의 유의사항에 따라주세요.'
                      //   '\n\n・등을 세우고 바르게 앉아 측정해 주세요.'
                      //   '\n\n・팔의 측정기 높이를 심장 높이가 되도록 해주세요.'
                      //   '\n\n・측정 중에는 몸에 긴장을 푼 편안한 상태에서 최대한 안정을 취해주세요.'
                      //   '\n\n・몸을 움직이거나 말을 하거나 팔에 힘을 주지 마세요.',
                      // )
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                CommonButton(
                  height: 50.0,
                  width: _screenWidth,
                  title: '이전 화면으로',
                  buttonColor: ButtonColor.inactive,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
