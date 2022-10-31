import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';
import 'package:three_youth_app/utils/utils.dart';

Widget bpRecordCard({
  required BuildContext context,
  required DateTime measureDatetime,
  required int sys,
  required int dia,
  required int pul,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/sphygmomanometer_1.png',
                  height: 80.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.formatDatetime(measureDatetime).split(' ')[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                      ),
                    ),
                    Text(
                      Utils.formatDatetime(measureDatetime).split(' ')[1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () => showToast('APP의 스토어 정식 등록 이후 구현 가능합니다.'),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: ColorAssets.waterLevelWave1,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Image.asset(
                      'assets/icons/ic_share.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                ),
                // Container(width: 27.0)
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 1.0,
                indent: 1.0,
                endIndent: 1.0,
              ),
            ),
          ),
          Column(
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
                  vertical: 10.0,
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
        ],
      ),
    ),
  );
}
