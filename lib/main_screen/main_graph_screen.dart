import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/custom/common_button.dart';
import 'package:three_youth_app/custom/gradient_small_button.dart';
import 'package:three_youth_app/php/classCubeAPI.dart';
import 'package:three_youth_app/php/cube_class_api.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/current_user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:three_youth_app/utils/toast.dart';

enum dataKind { BP, ECG }

class MainGraphScreen extends StatefulWidget {
  const MainGraphScreen({Key? key}) : super(key: key);

  @override
  _MainGraphScreenState createState() => _MainGraphScreenState();
}

class _MainGraphScreenState extends State<MainGraphScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  bool isER = false;
  math.Random random = math.Random();
  List<FlSpot> lsData = [];

  TDataSet ds = TDataSet();

  dataKind iKind = dataKind.BP;

  String _setTime = "";
  String _setDate = "";

  String dateTime = "";
  DateTime dateFrom = DateTime.now();
  DateTime timeFrom = DateTime(2000, 1, 1, 0, 0, 0);

  DateTime dateTo = DateTime.now();
  DateTime timeTo = DateTime(2000, 1, 1, 23, 59, 59);

  final TextEditingController txtDateFrom = TextEditingController();
  final TextEditingController txtTimeFrom = TextEditingController();

  final TextEditingController txtDateTo = TextEditingController();
  final TextEditingController txtTimeTo = TextEditingController();

  int isLoad = 0;

  double xMin = 0;
  double xMax = 1;
  double yMin = 0;
  double yMax = 0;

  List<DateTime> lTimes = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        var ff = DateFormat('yyyy-MM-dd');
        txtDateFrom.text = ff.format(dateFrom);
        txtDateTo.text = ff.format(dateTo);

        var ff2 = DateFormat('HH:mm');
        txtTimeFrom.text = ff2.format(timeFrom);
        txtTimeTo.text = ff2.format(timeTo);
      });
      //
      // var isSphyFairing = prefs.getBool('isSphyFairing') ?? false;
      // var isErFairing = prefs.getBool('isErFairing') ?? false;
      // bool isFairing = isSphyFairing || isErFairing;
      // Provider.of<CurrentUser>(context, listen: false).isFairing = isFairing;
      //
      // CubeClassAPI cubeClassAPI = CubeClassAPI();
      // String id = prefs.getString('id') ?? '';
      // String sql = 'SELECT * FROM bio_info WHERE login_id=("$id")';
      // String result = '';
      // try {
      //   result = await cubeClassAPI.sqlToText(sql);
      //   Map mapResult = jsonDecode(result);
      //   if (mapResult['result'].toString() == '[]') {
      //     showToast('업로드된 데이터가 없습니다.');
      //     lsData = [
      //       FlSpot(1, random.nextInt(241) * 1.0),
      //       FlSpot(2, random.nextInt(241) * 1.0),
      //       FlSpot(3, random.nextInt(241) * 1.0),
      //       FlSpot(4, random.nextInt(241) * 1.0),
      //       FlSpot(5, random.nextInt(241) * 1.0),
      //       FlSpot(6, random.nextInt(241) * 1.0),
      //       FlSpot(7, random.nextInt(241) * 1.0),
      //       FlSpot(8, random.nextInt(241) * 1.0),
      //       FlSpot(9, random.nextInt(241) * 1.0),
      //       FlSpot(10, random.nextInt(241) * 1.0),
      //       FlSpot(11, random.nextInt(241) * 1.0),
      //       FlSpot(12, random.nextInt(241) * 1.0),
      //       FlSpot(13, random.nextInt(241) * 1.0),
      //       FlSpot(14, random.nextInt(241) * 1.0),
      //     ];
      //   } else {
      //     for (int i = 0; i < mapResult['result'].length; i++) {
      //       lsData
      //           .add(FlSpot(i + 1, double.parse(mapResult['result'][i]['3'])));
      //     }
      //   }
      // } on FormatException catch (e) {
      //   log(e.toString());
      //   showToast('서버 에러');
      // }

      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });
    super.initState();
  }

  Future<Null> showDateFrom(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2021, 1, 1),
        maxTime: DateTime(2099, 12, 31),
        // onChanged: (date) {
        //   print('change $date');
        // },

        onConfirm: (date) {
      setState(() {
        dateFrom = date;
        final ff = DateFormat('yyyy-MM-dd');
        txtDateFrom.text = ff.format(dateFrom);
      });
    }, currentTime: dateFrom, locale: LocaleType.ko);
  }

  Future<Null> showDateTo(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2021, 1, 1),
        maxTime: DateTime(2099, 12, 31),
        // onChanged: (date) {
        //   print('change $date');
        // },

        onConfirm: (date) {
      setState(() {
        dateTo = date;
        final ff = DateFormat('yyyy-MM-dd');
        txtDateTo.text = ff.format(dateTo);
      });
    }, currentTime: dateTo, locale: LocaleType.ko);
  }

  Future<Null> showTimeFrom(BuildContext context) async {
    DatePicker.showTimePicker(context, showTitleActions: true,
        // onChanged: (date) {
        //   print('change $date');
        // },
        onConfirm: (date) {
      setState(() {
        timeFrom = date;
        final ff = DateFormat('HH:mm');
        txtTimeFrom.text = ff.format(timeFrom);
      });
    }, currentTime: timeFrom, locale: LocaleType.ko);
  }

  Future<Null> showTimeTo(BuildContext context) async {
    DatePicker.showTimePicker(context, showTitleActions: true,
        // onChanged: (date) {
        //   print('change $date');
        // },
        onConfirm: (date) {
      setState(() {
        timeTo = date;
        final ff = DateFormat('HH:mm');
        txtTimeTo.text = ff.format(timeTo);
      });
    }, currentTime: timeTo, locale: LocaleType.ko);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        :
    SingleChildScrollView(
child:
    Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                '데이터',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        '혈압',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: ColorAssets.fontDarkGrey),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => ColorAssets.fontDarkGrey),
                      value: dataKind.BP,
                      groupValue: iKind,
                      onChanged: (dataKind? value) {
                        setState(() {
                          iKind = value!;
                        });
                      },
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '심전도',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: ColorAssets.fontDarkGrey),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => ColorAssets.fontDarkGrey),
                      value: dataKind.ECG,
                      groupValue: iKind,
                      onChanged: (dataKind? value) {
                        setState(() {
                          iKind = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: ColorAssets.borderGrey,
                    width: 1,
                  ),
                ),
                margin: const EdgeInsets.only(
                    left: 20, bottom: 10, right: 20, top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '시작',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: ColorAssets.fontDarkGrey),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDateFrom(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: ColorAssets.fontDarkGrey),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: txtDateFrom,
                                onSaved: (val) {
                                  _setDate = val!;
                                },
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showTimeFrom(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: ColorAssets.fontDarkGrey),
                                textAlign: TextAlign.center,
                                onSaved: (val) {
                                  _setTime = val!;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: txtTimeFrom,
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.all(5)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '종료',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: ColorAssets.fontDarkGrey),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDateTo(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: ColorAssets.fontDarkGrey),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: txtDateTo,
                                onSaved: (val) {
                                  _setDate = val!;
                                },
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showTimeTo(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: ColorAssets.fontDarkGrey),
                                textAlign: TextAlign.center,
                                onSaved: (val) {
                                  _setTime = val!;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: txtTimeTo,
                                decoration: const InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.all(5)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(
                    left: 20, bottom: 10, right: 20, top: 0),
                child: GradientSmallButton(
                  width: double.infinity,
                  height: 60,
                  radius: 50.0,
                  child: const Text(
                    '불러오기',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18.0),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[ColorAssets.greenGradient1, ColorAssets.purpleGradient2],
                  ),
                  onPressed: () {
                    setState(() {
                      isLoad = 1;
                    });
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: ColorAssets.borderGrey,
                    width: 1,
                  ),
                ),
                //width: _screenWidth * 0.8,
                margin: const EdgeInsets.only(
                    left: 20, bottom: 0, right: 20, top: 0),
                height: 332,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                      //width: _screenWidth * 0.75,
                      height: 300,
                      padding: EdgeInsets.all(20),
                      child: (isLoad == 1) ?
                      FutureBuilder<TDataSet>(
                        future: (iKind == dataKind.BP) ? getChartDataBP() : getChartData(),
                        builder: (context, snapshot) {
                          {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? getChart()
                                : const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      )
                      : Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // SizedBox(
              //   width: _screenWidth * 0.8,
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         CommonButton(
              //             screenWidth: _screenWidth * 0.35,
              //             txt: '보관함 저장',
              //             onPressed: () {}),
              //         CommonButton(
              //             screenWidth: _screenWidth * 0.35,
              //             txt: 'PDF 공유',
              //             onPressed: () {}),
              //       ]),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // SizedBox(
              //   width: _screenWidth * 0.8,
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: [
              //         CommonButton(
              //             screenWidth: _screenWidth * 0.35,
              //             txt: '히스토리',
              //             onPressed: () {
              //               Navigator.pushNamed(context, '/history');
              //             }),
              //         CommonButton(
              //             screenWidth: _screenWidth * 0.35,
              //             txt: '예방 콘텐츠',
              //             onPressed: () {}),
              //       ]),
              // ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
    );
  }

  LineChartData get chartSetting => LineChartData(
        lineTouchData: chartTouch,
        gridData: bloodPressureGridData,
        titlesData: chartGetLabel,
        borderData: bloodPressureBorderData,
        lineBarsData: lcDataList,
        // minX: xMin,
        // maxX: xMax,
        // maxY: yMin,
        // minY: yMax,
      );

  LineTouchData get chartTouch => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
        ),
      );

  FlTitlesData get chartGetLabel => FlTitlesData(
        bottomTitles: chartGetXLabel,
        leftTitles: chartGetYLabel,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      );

  List<LineChartBarData> get lcDataList => [
        lcData,
      ];

  SideTitles get chartGetYLabel => SideTitles(
    showTitles: true,
    interval: 10,
    getTextStyles: (context, value) => const TextStyle(
      color: ColorAssets.fontDarkGrey,
      // fontWeight: FontWeight.bold,
      fontSize: 10,
    ),
    getTitles: (value) {
      int idx = value.toInt();

      //if(idx % 10 == 0)
        {
          return value.toString();
        }
      // else{
      //   return "";
      // }
    },
  );

  SideTitles get chartGetXLabel => SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: ColorAssets.fontDarkGrey,
          // fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        getTitles: (value) {
          int idx = value.toInt();

          if(idx < lTimes.length)
            {
              var ff = DateFormat('HH:mm');
              String sx = ff.format(lTimes[idx]);
              return sx;
            }
          else {
            return "";
          }
        },
      );

  FlGridData get bloodPressureGridData => FlGridData(show: true);

  FlBorderData get bloodPressureBorderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lcData => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xff134fad)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          colors: [
            const Color(0x00aa4cfc),
          ],
        ),
        spots: lsData,
      );

  Future<TDataSet> getChartData() async {
    TCubeAPI ca = TCubeAPI();

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';

    String eq = id;

    if(iKind == dataKind.BP) {
      id += '_bp';
    }
    else if(iKind == dataKind.ECG) {
      id += '_ecg';
    }

    String dtFrom = txtDateFrom.text + ' ' + txtTimeFrom.text + ':00';
    String dtTo = txtDateTo.text + ' ' + txtTimeTo.text + ':59';

    String sql = "select * from raw ";
    sql += " where eq   = '${id}' ";
    sql += " and   tag  = 'ecg' ";
    sql += " and   datatime >= '${dtFrom}' ";
    sql += " and   datatime <= '${dtTo}' ";

    await ds.getDataSet(sql);

    lsData.clear();
    lTimes.clear();

    xMin = 0;
    xMax = 0;
    yMin = 0;
    yMax = 0;

    double idx = 0;
    for(int r = 0; r < ds.getRowCount(); r++)
    {
      TRow dr = ds.rows[r];

      String sdt = dr.value('datatime');
      DateTime dt = DateTime.parse(sdt);

      String s1 = dr.value('ext');
      final sa = s1.split(',');
      for(int c = 0; c < sa.length; c++)
      {
        String sv = sa[c];
        double? dd = double.tryParse(sv);
        if(dd!=null) {
          lsData.add(FlSpot(idx, dd));
          lTimes.add(dt);
          idx++;
        }
      }
    }

    // setState(() {
    //
    // });

    isLoad = 0;

    return ds;
  }


  Future<TDataSet> getChartDataBP() async {
    TCubeAPI ca = TCubeAPI();

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';

    String eq = id;

    if(iKind == dataKind.BP) {
      id += '_bp';
    }
    else if(iKind == dataKind.ECG) {
      id += '_ecg';
    }

    String dtFrom = txtDateFrom.text + ' ' + txtTimeFrom.text + ':00';
    String dtTo = txtDateTo.text + ' ' + txtTimeTo.text + ':59';

    String sql = "select * from test_list ";
    sql += " where eq   = '${id}' ";
    sql += " and   start >= '${dtFrom}' ";
    sql += " and   start <= '${dtTo}' ";

    await ds.getDataSet(sql);

    lsData.clear();
    lTimes.clear();

    xMin = 0;
    xMax = 0;
    yMin = 0;
    yMax = 0;

    double idx = 0;
    for(int r = 0; r < ds.getRowCount(); r++)
    {
      TRow dr = ds.rows[r];

      String sdt = dr.value('start');
      DateTime dt = DateTime.parse(sdt);

      String s1 = dr.value('value2');
      double? dd = double.tryParse(s1);
      if(dd!=null) {
        lsData.add(FlSpot(idx, dd));
        lTimes.add(dt);
        idx++;
      }
    }

    // setState(() {
    //
    // });

    isLoad = 0;

    return ds;
  }

  Widget getChart()
  {
    if (lsData.length == 0) {
      return Column(
        children: const [
          SizedBox(
            width: 300,
            height: 20,
          ),
          Text(
            '기록이 없습니다.',
            style: TextStyle(
                color: ColorAssets.fontDarkGrey,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    else {
      return LineChart(
        chartSetting,
        swapAnimationDuration:
        const Duration(seconds: 1), // Optional
        swapAnimationCurve: Curves.linear, // Optional
      );
    }
  }
}
