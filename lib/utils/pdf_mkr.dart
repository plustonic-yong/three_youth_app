import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:three_youth_app/models/bp_model.dart';
import 'package:three_youth_app/models/ecg_model.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:three_youth_app/utils/utils.dart';

class PdfMkr {
  static final PdfColor _orange = PdfColor.fromHex('#FF8E2C');
  static final PdfColor _orangeAccent = PdfColor.fromHex('#F26C42');
  static final PdfColor _bgGrey = PdfColor.fromHex('#F4F7F8');
  static final PdfColor _grey = PdfColor.fromHex('#C8C8C8');
  static final PdfColor _darkGrey = PdfColor.fromHex('#606060');
  static final PdfColor _white = PdfColor.fromHex('#FFFFFF');

  ///* 혈압계 pdf 생성
  static Future<pw.Document> getPdfForBp(
      UserModel userInfo, BpModel bpData) async {
    final pdf = pw.Document();
    ByteData _bytes = await rootBundle.load('assets/images/bp_pdf.png');
    var warnImgBytes = _bytes.buffer.asUint8List();
    var warnPdfImg = pw.MemoryImage(warnImgBytes);
    pw.ImageProvider? profileImage;
    if (userInfo.imgUrl !=
        'https://3youth.s3.ap-northeast-2.amazonaws.com/undefined') {
      profileImage = await networkImage(userInfo.imgUrl);
    }

    int bpIndex = 0;

    if (bpData.sys < 120 && bpData.dia < 80) {
      bpIndex = 0; // 정상혈압
    } else if ((bpData.sys >= 120 && bpData.sys <= 129) && bpData.dia < 80) {
      bpIndex = 1; // 주의혈압
    } else if ((bpData.sys >= 130 && bpData.sys <= 139) ||
        (bpData.dia >= 80 && bpData.dia <= 89)) {
      bpIndex = 2; // 고혈압전단계
    } else if (bpData.sys >= 140 || bpData.dia >= 90) {
      bpIndex = 3; // 고혈압
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Regular.ttf')),
          bold: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Bold.ttf')),
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(children: [
                if (profileImage != null)
                  pw.Container(
                    width: 100,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      image: pw.DecorationImage(image: profileImage),
                    ),
                  ),
                pw.SizedBox(width: 16),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('이름\t:\t${userInfo.name}',
                        style: pw.TextStyle(
                            fontSize: 30, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text(
                        '${Utils.getAge(userInfo.birth)}세/${userInfo.gender == "M" ? '남성' : '여성'}/${userInfo.height}cm/${userInfo.weight}kg',
                        style: const pw.TextStyle(fontSize: 22)),
                  ],
                ),
              ]),
              pw.SizedBox(height: 30),
              pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(15)),
                  border: pw.Border.all(color: _grey),
                  color: _bgGrey,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 20),
                        pw.Text(
                          Utils.formatDate(bpData.measureDatetime),
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Text(
                          Utils.formatTime(bpData.measureDatetime),
                          style: const pw.TextStyle(fontSize: 22),
                        ),
                        pw.SizedBox(width: 20),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 20),
                        pw.Text('수축기 혈압(SYS)',
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.Spacer(),
                        pw.Text(bpData.sys.toString(),
                            style: pw.TextStyle(
                                fontSize: 36,
                                fontWeight: pw.FontWeight.bold,
                                color: _orange)),
                        pw.SizedBox(width: 12),
                        pw.Align(
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text('mmHg',
                              style:
                                  pw.TextStyle(color: _darkGrey, fontSize: 18)),
                        ),
                        pw.SizedBox(width: 20),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 20),
                        pw.Text('이완기 혈압(DIA)',
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.Spacer(),
                        pw.Text(bpData.dia.toString(),
                            style: pw.TextStyle(
                                fontSize: 36,
                                fontWeight: pw.FontWeight.bold,
                                color: _orange)),
                        pw.SizedBox(width: 12),
                        pw.Align(
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text('mmHg',
                              style:
                                  pw.TextStyle(color: _darkGrey, fontSize: 18)),
                        ),
                        pw.SizedBox(width: 20),
                      ],
                    ),
                    pw.SizedBox(height: 30),
                    pw.Container(
                      color: _grey,
                      padding: const pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('혈압 분류',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(color: _white, fontSize: 16)),
                          pw.Text('수축기 혈압\n(mmHg)',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(color: _white, fontSize: 16)),
                          pw.Text('이완기 혈압\n(mmHg)',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(color: _white, fontSize: 16)),
                        ],
                      ),
                    ),
                    pw.Container(
                      color: bpIndex == 0 ? _orangeAccent : _bgGrey,
                      padding: const pw.EdgeInsets.symmetric(vertical: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('정상혈압',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 0 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('120미만',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 0 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('80미만',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 0 ? _white : _darkGrey,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                    pw.Container(
                      color: bpIndex == 1 ? _orangeAccent : _bgGrey,
                      padding: const pw.EdgeInsets.symmetric(vertical: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('주의혈압',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 1 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('120~129',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 1 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('80미만',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 1 ? _white : _darkGrey,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                    pw.Container(
                      color: bpIndex == 2 ? _orangeAccent : _bgGrey,
                      padding: const pw.EdgeInsets.symmetric(vertical: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('고혈압전단계',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 2 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('130~139',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 2 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('140이상',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 2 ? _white : _darkGrey,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                    pw.Container(
                      color: bpIndex == 3 ? _orangeAccent : _bgGrey,
                      padding: const pw.EdgeInsets.symmetric(vertical: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('고혈압',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 3 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('140이상',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 3 ? _white : _darkGrey,
                                  fontSize: 16)),
                          pw.Text('90이상',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: bpIndex == 3 ? _white : _darkGrey,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('※적어도 2회 이상, 140/90mmHg 이상 나와야 고혈압',
                  style: pw.TextStyle(fontSize: 13, color: _orangeAccent)),
            ],
          );
        },
      ),
    ); // Page
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Regular.ttf')),
          bold: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Bold.ttf')),
        ),
        build: (pw.Context context) {
          return pw.Image(warnPdfImg, fit: pw.BoxFit.fitHeight);
        }));

    return pdf;
  }

  ///* 심전계 pdf 생성
  static Future<pw.Document> getPdfForEcg(
      UserModel userInfo, EcgModel ecgData, Uint8List graphBytes) async {
    final pdf = pw.Document();

    ByteData _pulseBytes =
        await rootBundle.load('assets/images/ecg_pdf_pulse.png');
    var pulseImgBytes = _pulseBytes.buffer.asUint8List();
    var pulseImg = pw.MemoryImage(pulseImgBytes);

    ByteData _bytes1 = await rootBundle.load('assets/images/ecg_pdf1.png');
    var warnImgBytes1 = _bytes1.buffer.asUint8List();
    var warnPdfImg1 = pw.MemoryImage(warnImgBytes1);

    ByteData _bytes2 = await rootBundle.load('assets/images/ecg_pdf2.png');
    var warnImgBytes2 = _bytes2.buffer.asUint8List();
    var warnPdfImg2 = pw.MemoryImage(warnImgBytes2);

    pw.ImageProvider? profileImage;
    if (userInfo.imgUrl !=
        'https://3youth.s3.ap-northeast-2.amazonaws.com/undefined') {
      profileImage = await networkImage(userInfo.imgUrl);
    }

    var graphImage = pw.MemoryImage(graphBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Regular.ttf')),
          bold: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Bold.ttf')),
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(children: [
                if (profileImage != null)
                  pw.Container(
                    width: 100,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      image: pw.DecorationImage(image: profileImage),
                    ),
                  ),
                pw.SizedBox(width: 16),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('이름\t:\t${userInfo.name}',
                        style: pw.TextStyle(
                            fontSize: 30, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text(
                        '${Utils.getAge(userInfo.birth)}세/${userInfo.gender == "M" ? '남성' : '여성'}/${userInfo.height}cm/${userInfo.weight}kg',
                        style: const pw.TextStyle(fontSize: 22)),
                  ],
                ),
              ]),
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: pw.BoxDecoration(
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(15)),
                  border: pw.Border.all(color: _grey),
                  color: _bgGrey,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Row(
                      children: [
                        pw.Text(
                          Utils.formatDate(ecgData.measureDatetime),
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Text(
                          Utils.formatTime(ecgData.measureDatetime),
                          style: const pw.TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      children: [
                        pw.Text('평균 심박수',
                            style:
                                pw.TextStyle(fontSize: 22, color: _darkGrey)),
                        pw.Spacer(),
                        pw.Image(pulseImg, width: 23),
                        pw.SizedBox(width: 7),
                        pw.Text(ecgData.bpm.toString(),
                            style: pw.TextStyle(
                                fontSize: 36,
                                fontWeight: pw.FontWeight.bold,
                                color: _orange)),
                        pw.SizedBox(width: 12),
                        pw.Align(
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text('bpm',
                              style:
                                  pw.TextStyle(color: _darkGrey, fontSize: 18)),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    pw.Image(graphImage),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ); // Page

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Regular.ttf')),
          bold: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Bold.ttf')),
        ),
        build: (pw.Context context) {
          return pw.Image(warnPdfImg1, fit: pw.BoxFit.fitHeight);
        }));

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Regular.ttf')),
          bold: pw.Font.ttf(await rootBundle
              .load('fonts/NotoSansCJKkr/NanumGothic-Bold.ttf')),
        ),
        build: (pw.Context context) {
          return pw.Image(warnPdfImg2, fit: pw.BoxFit.fitHeight);
        }));

    return pdf;
  }
}
