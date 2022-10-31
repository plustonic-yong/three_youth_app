import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/models/bp_model.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/ble_ecg_connect/prev/prev_ble_ecg_connect_screen.dart';
import 'package:three_youth_app/services/php/classCubeAPI.dart';
import 'package:three_youth_app/providers/current_user_provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/utils.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ble_bp_scan/ble_bp_prev_history_screen.dart';

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
  // bool _isSphyFairing = false;
  bool _isPaired = false;

  TDataSet dsTagList = TDataSet();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        // _isSphyFairing = prefs.getBool('isSphyFairing') ?? false;
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
    _isPaired = context.watch<BleBpProvider>().isPaired;
    BpModel? _lastBpHistory = context.watch<BleBpProvider>().lastBpHistory;
    UserModel? _userInfo = context.watch<UserProvider>().userInfo;
    return isLoading
        ? spinkit
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  //유저 프로필
                  _userInfo != null
                      ? Row(
                          children: [
                            _userInfo.imgUrl !=
                                    "https://3youth.s3.ap-northeast-2.amazonaws.com/undefined"
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(90.0),
                                    child: Image.network(
                                      _userInfo.imgUrl,
                                      fit: BoxFit.cover,
                                      width: 64.0,
                                      height: 64.0,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 32.0,
                                    child: Image.asset(
                                      'assets/icons/ic_user.png',
                                    ),
                                  ),
                            const SizedBox(width: 10.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userInfo.name,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${_userInfo.birth != '' ? Utils.getAge(_userInfo.birth) : '0'}세 ${_userInfo.gender == "M" ? '남성' : '여성'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 20.0),
                  const Text(
                    '최근 심전도 측정기록',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
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
                                  '2022.7.15(화) 오후 7:21',
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
                        // const SizedBox(height: 25.0),
                        // CommonButton(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 40.0,
                        //   title: '이전 코드 연동/측정 테스트',
                        //   buttonColor: ButtonColor.inactive,
                        //   onTap: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) =>
                        //             const PrevBleECGConnectScreen(),
                        //       ),
                        //     );
                        //     Provider.of<CurrentUserProvider>(context,
                        //             listen: false)
                        //         .isER2000S = true;
                        //   },
                        // ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: CommonButton(
                                width: 135.0,
                                height: 40.0,
                                title: '측정하기',
                                buttonColor: ButtonColor.inactive,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/scanecg',
                                  );
                                  Provider.of<CurrentUserProvider>(context,
                                          listen: false)
                                      .isER2000S = true;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CommonButton(
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
                            ),
                          ],
                        ),
                      ],
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
                  Container(
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
                              _lastBpHistory != null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Utils.formatDatetime(
                                              _lastBpHistory.measureDatetime),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${_lastBpHistory.sys}/${_lastBpHistory.dia}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
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
                                  : const SizedBox(
                                      child: Text(
                                        '측정기록이 없습니다.\n측정기록을 남겨보세요!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CommonButton(
                                  width: 135.0,
                                  height: 40.0,
                                  title: '측정하기',
                                  buttonColor: _isPaired
                                      ? ButtonColor.white
                                      : ButtonColor.inactive,
                                  onTap: _isPaired
                                      ? () {
                                          log('scan');
                                          Navigator.pushNamed(context, '/scan');
                                        }
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _isPaired
                                  ? Expanded(
                                      child: CommonButton(
                                        width: 135.0,
                                        height: 40.0,
                                        title: '연동해제',
                                        buttonColor: ButtonColor.orange,
                                        onTap: () async {
                                          await context
                                              .read<BleBpProvider>()
                                              .disConnectPairing();
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: CommonButton(
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
                                    ),
                            ],
                          ),
                        ],
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
