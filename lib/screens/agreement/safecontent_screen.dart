import 'package:flutter/material.dart';
import 'package:three_youth_app/screens/base/navigate_app_bar.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:flutter/services.dart' show rootBundle;

class SafeContentScreen extends StatefulWidget {
  const SafeContentScreen({Key? key}) : super(key: key);

  @override
  _SafeContentScreenState createState() => _SafeContentScreenState();
}

class _SafeContentScreenState extends State<SafeContentScreen> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.commonBackgroundDark,
      appBar: const NavigateAppBar(),
      //drawer: ,
      body: SingleChildScrollView(
        child: isLoading
            ? spinkit
            : Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '예방 콘텐츠',
                      style: TextStyle(
                          color: ColorAssets.fontDarkGrey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    uiAgree(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget uiAgree() {
    return Container(
      decoration: BoxDecoration(
        color: ColorAssets.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: ColorAssets.borderGrey,
          width: 1,
        ),
      ),
      height: _screenHeight * 0.6,
      width: _screenWidth * 0.8,
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: getAgreeTxt(),
        ),
      ),
    );
  }

  Widget getAgreeTxt() {
    return FutureBuilder<String>(
        future: loadAsset('assets/safecontent.txt'),
        builder: (context, snapshot) {
          // snapshot은 Future 클래스가 포장하고 있는 객체를 data 속성으로 전달
          // Future<String>이기 때문에 data는 String이 된다.
          final contents = snapshot.data.toString();

          // 개행 단위로 분리
          final rows = contents.split('\n');

          var tableRows = <TableRow>[];
          for (var row in rows) {
            tableRows.add(
              TableRow(
                children: [
                  Text(row),
                ],
              ),
            );
          }
          return Table(children: tableRows);
        });
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
    // return await DefaultAssetBundle.of(ctx).loadString('assets/2016_GDP.txt');
  }
}
