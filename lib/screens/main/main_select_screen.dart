import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/services/php/classCubeAPI.dart';
import 'package:three_youth_app/utils/current_user.dart';
import 'package:three_youth_app/widget/common_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MainSelectScreen extends StatefulWidget {
  const MainSelectScreen({Key? key}) : super(key: key);

  @override
  _MainSelectScreenState createState() => _MainSelectScreenState();
}

class _MainSelectScreenState extends State<MainSelectScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;

  TDataSet dsTagList = TDataSet();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });

    doPerm();

    super.initState();
  }

  Future<void> doPerm() async {
    if (await Permission.bluetoothScan.request().isGranted) {}
    if (await Permission.bluetooth.request().isGranted) {}
    if (await Permission.bluetoothConnect.request().isGranted) {}
    if (await Permission.location.request().isGranted) {}
    if (await Permission.storage.request().isGranted) {}
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32.0,
                        child: Image.asset(
                          'assets/images/profile_img_1.png',
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '홍길동님',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '60세 여성',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    '최근 심전도 측정기록',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 30.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        // border: Border.all(
                        //   color: ColorAssets.borderGrey,
                        //   width: 1,
                        // ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: const Offset(0, 2),
                        //     blurRadius: 5,
                        //     color: Colors.white.withOpacity(0.4),
                        //   ),
                        // ],
                      ),
                      // width: _screenWidth * 0.8,
                      // height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/electrocardiogram_1.png',
                                fit: BoxFit.cover,
                                height: 70.0,
                              ),
                              const SizedBox(width: 20.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '7.15(화) 오후 7:21',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Text(
                                        '158',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'bpm',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonButton(
                                width: 135.0,
                                height: 40.0,
                                title: '측정하기',
                                buttonColor: ButtonColor.inactive,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/connectecg',
                                  );
                                  Provider.of<CurrentUser>(context,
                                          listen: false)
                                      .isER2000S = true;
                                },
                              ),
                              CommonButton(
                                width: 135.0,
                                height: 40.0,
                                title: '연동하기',
                                buttonColor: ButtonColor.primary,
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const BleECGConnectScreenPrev(),
                                  //   ),
                                  // );
                                  Navigator.of(context)
                                      .pushNamed('/connectecg');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    '최근 혈압 측정기록',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const BleBPConnectScreen()),
                      // );

                      // Provider.of<CurrentUser>(context, listen: false).isER2000S = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        // border: Border.all(
                        //   color: ColorAssets.borderGrey,
                        //   width: 1,
                        // ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: const Offset(0, 2),
                        //     blurRadius: 5,
                        //     color: Colors.white.withOpacity(0.4),
                        //   ),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 30.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/sphygmomanometer_1.png',
                                  fit: BoxFit.cover,
                                  height: 70.0,
                                ),
                                const SizedBox(width: 20.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '7.15(화) 오후 7:21',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: const [
                                        Text(
                                          '167/88',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'mmHg',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonButton(
                                  width: 135.0,
                                  height: 40.0,
                                  title: '측정하기',
                                  buttonColor: ButtonColor.white,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/scan',
                                    );
                                  },
                                ),
                                CommonButton(
                                  width: 135.0,
                                  height: 40.0,
                                  title: '연동하기',
                                  buttonColor: ButtonColor.primary,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/connect',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          );
  }

  void _launchURL() async {
    String _url = "http://www.3-youth.com/";
    // ignore: deprecated_member_use
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
