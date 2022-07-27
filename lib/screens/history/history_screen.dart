import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/php/classCubeAPI.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

enum dataKind { bp, ecg }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;

  dataKind iKind = dataKind.bp;

  TDataSet dsTagList = TDataSet();

  List<String> lChk = [];
  bool isCheckMode = false;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });
    super.initState();
  }

  // 11111111111111111111111111111
  Future<bool> doViewListReload() async {
    bool isOK = false;

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';

    // TCubeAPI ca = TCubeAPI();

    String idkind = id;
    if (iKind == dataKind.bp) {
      idkind = idkind + '_bp';
    } else if (iKind == dataKind.ecg) {
      idkind = idkind + '_ecg';
    }

    String sql = "select * from test_list where eq like '$idkind%' ";

    await dsTagList.getDataSet(sql);
    //lChk.clear();
    //isCheckMode = false;

    isOK = true;

    return isOK;
  }

  Future<void> doTestPDF(String testListIdx) async {
    TCubeAPI ca = TCubeAPI();
    TDataSet ds = TDataSet();

    String sql = "select * from test_list where idx = $testListIdx";
    await ds.getDataSet(sql);

    if (ds.getRowCount() > 0) {
      String url = await ca.getPDFUrl(testListIdx);

      if (url.isEmpty) {
        showToast('PDF 생성에 실패 했습니다.');
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('id') ?? '';

      String name =
          await ca.sqlToText("select 이름 from login_info where 아이디 = '$id' ");
      Share.share(url, subject: '$name - 혈압 측정결과');
    } else {
      showToast('데이터가 없습니다.');
    }
  }

  bool isChk(int index) {
    TRow dr = dsTagList.rows[index];
    String idx = dr.value('idx').toString();
    return lChk.contains(idx);
  }

  // 1111111111111111111111111
  Widget getViewItem(int index) {
    TRow dr = dsTagList.rows[index];

    if (iKind == dataKind.bp) {
      return Card(
        child: ListTile(
          onTap: () async {
            await doTestPDF(dr.value('idx'));
          },
          title: Row(
            children: [
              isCheckMode
                  ? Checkbox(
                      value: isChk(index),
                      onChanged: (value) {
                        TRow dr = dsTagList.rows[index];
                        String idx = dr.value('idx').toString();

                        setState(() {
                          if (value == true) {
                            lChk.add(idx);
                          } else {
                            lChk.remove(idx);
                          }
                        });
                      })
                  : const SizedBox(width: 10),
              Text('측정시각 ${dr.value('start')}'),
            ],
          ),

          // subtitle: Container(
          //   child: Row(
          //     children: [
          //       SizedBox(width: 40),
          //       Text('종료 ${dr.value('start')}'),
          //     ],
          //   ),
          // ),

          // leading: CircleAvatar(
          //     backgroundImage: Icons.amp_stories_outlined,
          trailing: Text(
            'SYS ${dr.value('value1')}\nDIA ${dr.value('value2')}\nPUL ${dr.value('value3')}',
            style: const TextStyle(
              // color: ColorAssets.fontDarkGrey,
              fontSize: 12,
              // fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    } else {
      return Card(
        child: ListTile(
          onTap: () async {
            await doTestPDF(dr.value('idx'));
          },
          title: Row(
            children: [
              isCheckMode
                  ? Checkbox(
                      value: isChk(index),
                      onChanged: (value) {
                        TRow dr = dsTagList.rows[index];
                        String idx = dr.value('idx').toString();

                        setState(() {
                          if (value == true) {
                            lChk.add(idx);
                          } else {
                            lChk.remove(idx);
                          }
                        });
                      })
                  : const SizedBox(width: 10),
              Text('시작 ${dr.value('start')}\n종료 ${dr.value('stop')}'),
            ],
          ),

          // leading: CircleAvatar(
          //     backgroundImage: Icons.amp_stories_outlined,
          trailing: Text(
            '데이터 개수 ${dr.value('datacnt')}',
          ),
        ),
      );
    }
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: doViewListReload(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          if (dsTagList.getRowCount() == 0) {
            return Column(
              children: const [
                SizedBox(
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
          } else {
            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              itemCount: dsTagList.getRowCount(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return getViewItem(index);
              },
            );
          }
        }
      },
    );
  }

  String getTodayString() {
    DateTime now = DateTime.now();
    var formatter = DateFormat('MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
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
                '히스토리',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  isCheckMode
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  isCheckMode = false;
                                  lChk.clear();
                                });
                              },
                              icon: const Icon(Icons.cancel, size: 18),
                              label: const Text('취소'),
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 10,
                        ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          if (isCheckMode) {
                            if (lChk.isEmpty) {
                              showToast('항목을 1개이상 체크해야 합니다.');
                              return;
                            }
                            showRemoveDialog(context);
                          } else {
                            setState(() {
                              isCheckMode = true;
                              lChk.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle, size: 18),
                        label: Text(isCheckMode ? "선택 삭제하기" : "삭제"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
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
                      value: dataKind.bp,
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
                      value: dataKind.ecg,
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
              SizedBox(
                height: _screenHeight * 0.8,
                // ignore: unrelated_type_equality_checks
                child: (iKind == 0) ? getMainListViewUI() : getMainListViewUI(),
              ),
            ],
          );
  }

  void doCheckRemove() async {
    String sql =
        'delete from test_list where idx in (' + lChk.join(',') + '); ';

    TCubeAPI ca = TCubeAPI();
    String sr = await ca.sqlExecPost(sql);

    if (sr == "TRUE") {
      await doViewListReload();
      setState(() {
        isCheckMode = false;
        lChk.clear();
      });
    } else {
      showToast('삭제시 에러가 발생했습니다. 서버 관리자에게 문의하세요.');
    }
  }

  showRemoveDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("선택 삭제"),
      onPressed: () async {
        doCheckRemove();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("선택 삭제"),
      content: const Text("선택 항목을 삭제 하시겠습니까?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
