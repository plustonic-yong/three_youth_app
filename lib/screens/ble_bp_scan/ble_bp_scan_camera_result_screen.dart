import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';

import '../../models/bp_model.dart';
import '../../models/user_model.dart';
import '../../providers/ble_bp_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/pdf_mkr.dart';

class BleBpScanCameraResultScreen extends StatefulWidget {
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
  State<BleBpScanCameraResultScreen> createState() =>
      _BleBpScanCameraResultScreenState();
}

class _BleBpScanCameraResultScreenState
    extends State<BleBpScanCameraResultScreen> {
  String _sys = '';
  String _dia = '';
  String _pul = '';
  bool _isLoading = false;
  @override
  void initState() {
    _sys = widget.sys ?? '';
    _dia = widget.dia ?? '';
    _pul = widget.pul ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    UserModel? _userInfo = context.watch<UserProvider>().userInfo;
    return Builder(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            //배경이미지
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover),
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
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16.0),
                            Image.memory(widget.imgFile!, width: 150.0),
                            const SizedBox(height: 16.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('수축기 혈압(SYS)',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                initialValue: widget.sys,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                  color: Color(0xFFFFF898),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.right,
                                                onChanged: (value) => setState(
                                                    () => _sys = value),
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            const Text(
                                              'mmHg',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //dia
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '이완기 혈압(DIA)',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                initialValue: widget.dia,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                  color: Color(0xFFFFF898),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.right,
                                                onChanged: (value) => setState(
                                                    () => _dia = value),
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            const Text(
                                              'mmHg',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //pul
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '분당맥박수(PUL)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                initialValue: widget.pul,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                  color: Color(0xFFFFF898),
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.right,
                                                onChanged: (value) => setState(
                                                    () => _pul = value),
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            const Text(
                                              '/min',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CommonButton(
                            height: 50.0,
                            width: 165.0,
                            title: '재촬영',
                            buttonColor: ButtonColor.inactive,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CommonButton(
                            height: 50.0,
                            width: 165.0,
                            title: '결과저장',
                            buttonColor: ButtonColor.primary,
                            onTap: () => _saveResult(_userInfo!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    CommonButton(
                      height: 50.0,
                      width: _screenWidth,
                      title: '홈으로',
                      buttonColor: ButtonColor.inactive,
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        '/main',
                        (route) => false,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    });
  }

  _saveResult(UserModel userInfo) async {
    try {
      setState(() => _isLoading = true);
      var pdf = await PdfMkr.getPdfForBp(
          userInfo,
          BpModel(
              measureDatetime: DateTime.now(),
              sys: int.parse(_sys),
              dia: int.parse(_dia),
              pul: int.parse(_pul),
              regDatetime: ''));

      final output = await getTemporaryDirectory();

      final file = File(
          '${output.path}/${DateTime.now().millisecondsSinceEpoch}_혈압계.pdf');
      await file.writeAsBytes(await pdf.save());
      var result = await context.read<BleBpProvider>().postBloodPressure(
            sys: int.parse(_sys),
            dia: int.parse(_dia),
            pul: int.parse(_pul),
            pdfPath: file.path,
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
                result == BpSaveDataStatus.success
                    ? '데이터 저장에 성공했습니다.'
                    : '데이터 저장에 실패했습니다.',
                style: const TextStyle(fontSize: 18.0),
              ),
            );
          });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
