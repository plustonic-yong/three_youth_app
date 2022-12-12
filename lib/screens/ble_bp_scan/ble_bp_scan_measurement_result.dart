import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/pdf_mkr.dart';
import 'package:three_youth_app/utils/toast.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/bp_model.dart';
import '../../utils/utils.dart';
import '../history/prev_history_screen.dart';

class BleBpScanMeasurementResult extends StatefulWidget {
  const BleBpScanMeasurementResult({Key? key}) : super(key: key);

  @override
  State<BleBpScanMeasurementResult> createState() =>
      _BleBpScanMeasurementResultState();
}

class _BleBpScanMeasurementResultState
    extends State<BleBpScanMeasurementResult> {
  bool _isSave = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool _dataIsOK = context.watch<BleBpProvider>().dataIsOK;

    // bool _isUpdated = context.watch<BleBpProvider>().isUpdated;
    List<double> _lDataSYS = context.read<BleBpProvider>().lDataSYS;
    List<double> _lDataDIA = context.read<BleBpProvider>().lDataDIA;
    List<double> _lDataPUL = context.read<BleBpProvider>().lDataPUL;
    UserModel? _userInfo = context.watch<UserProvider>().userInfo;
    BpModel? bpData = context.read<BleBpProvider>().lastBpHistory;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: Container(),
          ),
          backgroundColor: Colors.transparent,
          body: WillPopScope(
            onWillPop: () async => false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    _userInfo!.imgUrl !=
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
                    const SizedBox(height: 10.0),
                    Text(
                      _userInfo.name,
                      style: const TextStyle(
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
                      _dataIsOK ? _lDataPUL.last.round().toString() : '-',
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
                              _dataIsOK
                                  ? _lDataDIA.last.round().toString()
                                  : '-',
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
                              _dataIsOK
                                  ? _lDataSYS.last.round().toString()
                                  : '-',
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
                        Expanded(
                          child: CommonButton(
                            height: 40.0,
                            width: 160.0,
                            title: '결과저장',
                            buttonColor: _dataIsOK
                                ? ButtonColor.primary
                                : ButtonColor.inactive,
                            fontSize: 16.0,
                            onTap: _dataIsOK
                                ? () =>
                                    _dataSave(_lDataSYS, _lDataDIA, _lDataPUL)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CommonButton(
                            height: 40.0,
                            width: 160.0,
                            title: 'PDF 공유',
                            buttonColor: _isSave
                                ? ButtonColor.primary
                                : ButtonColor.inactive,
                            fontSize: 16.0,
                            onTap: () => _isSave
                                ? _pdfShare(context, _userInfo, bpData)
                                : showToast('결과를 저장해주세요.'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CommonButton(
                            height: 40.0,
                            width: 160.0,
                            title: '이전기록',
                            buttonColor: ButtonColor.inactive,
                            fontSize: 16.0,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrevHistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CommonButton(
                            height: 40.0,
                            width: 160.0,
                            title: '홈으로',
                            buttonColor: ButtonColor.inactive,
                            fontSize: 16.0,
                            onTap: () {
                              context.read<BleBpProvider>().dataClear();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/main', (route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  _dataSave(List<double> _lDataSYS, List<double> _lDataDIA,
      List<double> _lDataPUL) async {
    try {
      setState(() => _isLoading = true);
      var result = await context.read<BleBpProvider>().postBloodPressure(
            sys: _lDataSYS.last.round(),
            dia: _lDataDIA.last.round(),
            pul: _lDataPUL.last.round(),
          );
      if (result == BpSaveDataStatus.success) {
        await context.read<BleBpProvider>().getLastBloodPressure();
      }
      await showDialog(
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

      _isSave = true;
    } catch (e) {
      _isSave = false;
      showToast(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  _pdfShare(context, UserModel userInfo, BpModel? bpData) async {
    var pdf = await PdfMkr.getPdfForBp(userInfo, bpData!);
    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/${DateTime.now().millisecondsSinceEpoch}_혈압계.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareFiles([file.path]);
  }
}
