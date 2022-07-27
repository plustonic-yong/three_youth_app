import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:path/path.dart' as pp;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/php/classCubeAPI.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

enum dataKind { bp, ecg }

class LocalLogScreen extends StatefulWidget {
  const LocalLogScreen({Key? key}) : super(key: key);

  @override
  _LocalLogScreenState createState() => _LocalLogScreenState();
}

class _LocalLogScreenState extends State<LocalLogScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;

  dataKind iKind = dataKind.bp;

  List listFile = [];
  String directory = '';

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

  void getFileList() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      listFile = io.Directory('$directory/save/')
          .listSync(); //use your folder name insted of resume.
    });
  }

  // 11111111111111111111111111111
  Future<bool> doViewListReload() async {
    bool isOK = false;

    // SharedPreferences prefs;
    // prefs = await SharedPreferences.getInstance();
    // String id = prefs.getString('id') ?? '';
    //
    // TCubeAPI ca = TCubeAPI();
    //
    // String idkind = id;
    // if (iKind == dataKind.bp) {
    //   idkind = idkind + '_bp';
    // } else if (iKind == dataKind.ecg) {
    //   idkind = idkind + '_ecg';
    // }
    //
    // String sql = "select * from test_list where eq like '$idkind%' ";

    // await dsTagList.getDataSet(sql);

    getFileList();

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

      Share.share(url);
    } else {
      showToast('데이터가 없습니다.');
    }
  }

  Widget getViewItem(int index) {
    var sfile = listFile[index];

    File file = File(sfile.toString());
    String basename = pp.basename(file.path);
    basename = basename.replaceAll('\'', '');
    // int fileSize = await file.length();
    // String sfileLen = fileSize.toString();

    return Card(
      child: ListTile(
        onTap: () async {
          //await doTestPDF(dr.value('idx'));
        },
        title: Text('파일명 $basename'),
        subtitle: const Text(''),
        // leading: CircleAvatar(
        //     backgroundImage: Icons.amp_stories_outlined,
        trailing: const Text(''),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: doViewListReload(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          if (listFile.isEmpty) {
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
            return Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            showAlertDialog(context);
                          },
                          icon: const Icon(Icons.upload, size: 18),
                          label: const Text("서버에 업로드"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    itemCount: listFile.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return getViewItem(index);
                    },
                  ),
                ),
              ],
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
              const SizedBox(height: 20),
              const Text(
                '로컬보관함 관리',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _screenHeight * 0.8,
                // ignore: unrelated_type_equality_checks
                child: (iKind == 0) ? getMainListViewUI() : getMainListViewUI(),
              ),
            ],
          );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("업로드"),
      onPressed: () async {
        await doUpload();

        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("서버에 업로드"),
      content: const Text("로컬보관함 데이터를 서버에 업로드 하시겠습니까?\n업로드 된 데이터는 삭제됩니다."),
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

  Future<void> doUpload() async {
    for (final ff in listFile) {
      bool isFinish = true;
      String sfile = ff.toString().replaceAll('\'', '');
      sfile = sfile.replaceAll('File:', '');
      sfile = sfile.replaceAll(' ', '');
      File file = File(sfile);

      try {
        if (file.existsSync()) {
          List<String> lines = file.readAsLinesSync();

          for (String sql in lines) {
            TCubeAPI ca = TCubeAPI();
            String sr = await ca.sqlExecPost(sql);
            if (sr == "FALSE") {
              isFinish = false;
              break;
            }
          }
          if (isFinish) {
            file.delete();
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      // print(lines.length);
      //
    }
  }
}
