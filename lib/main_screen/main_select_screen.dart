import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/ble_bp_connect_screen/ble_bp_connect_screen.dart';
import 'package:three_youth_app/custom/gradient_small_button.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/current_user.dart';
import 'package:three_youth_app/utils/toast.dart';
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
        : Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                '기기 선택',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/connectecg',
                  );
                  Provider.of<CurrentUser>(context, listen: false).isER2000S =
                      true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorAssets.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: ColorAssets.borderGrey,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ],
                  ),
                  width: _screenWidth * 0.8,
                  height: 200,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/images/electrocardiogram_front_1.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: _screenWidth * 0.2,
                          ),
                          Image.asset(
                            'assets/images/electrocardiogram_front_2.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: _screenWidth * 0.2,
                          ),
                          Image.asset(
                            'assets/images/electrocardiogram_front_3.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: _screenWidth * 0.2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'ER-2000S 심전도',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const BleBPConnectScreen()),
                  // );

                  Navigator.pushNamed(
                    context,
                    '/connect',
                  );
                  // Provider.of<CurrentUser>(context, listen: false).isER2000S = false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorAssets.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: ColorAssets.borderGrey,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ],
                  ),
                  width: _screenWidth * 0.8,
                  height: 200,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/images/sphygmomanometer.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: _screenWidth * 0.6,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'UA-651BLE 혈압계',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GradientSmallButton(
                width: _screenWidth * 0.6,
                height: 60,
                radius: 50.0,
                child: const Text(
                  '신규 구매',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    ColorAssets.greenGradient1,
                    ColorAssets.purpleGradient2
                  ],
                ),
                onPressed: () {
                  //TODO: 구매링크 넣기
                  _launchURL();
                },
              ),

              SizedBox(height: 20,),

              Align(
                alignment: Alignment.bottomCenter,
                child: const Text(
                  'Ver 22.06.07d',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
  }

  void _launchURL() async {
    String _url = "http://www.3-youth.com/";
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
