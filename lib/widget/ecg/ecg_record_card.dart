import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';

Widget ecgRecordCard({required BuildContext context}) {
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
                  'assets/images/electrocardiogram_1.png',
                  height: 80.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '2022.7.05(화)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                      ),
                    ),
                    Text(
                      '오후 7:21',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10.0),
                Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '30초 측정 기준',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Row(
                      children: const [
                        Text(
                          '158',
                          style: TextStyle(
                            color: Color(0xFFFFF898),
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          'bpm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 100.0),
          Image.asset('assets/images/graph.png'),
          const SizedBox(height: 60.0),
        ],
      ),
    ),
  );
}
