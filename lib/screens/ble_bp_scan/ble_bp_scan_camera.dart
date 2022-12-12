import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class BleBpScanCamera extends StatefulWidget {
  const BleBpScanCamera({Key? key}) : super(key: key);

  @override
  State<BleBpScanCamera> createState() => _BleBpScanCameraState();
}

class _BleBpScanCameraState extends State<BleBpScanCamera> {
  late CameraController _controller;

  @override
  void initState() {
    _controller = CameraController(gCameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(fit: StackFit.expand, children: [
          CameraPreview(_controller),
          cameraOverlay(
              vPadding: 0,
              hPadding: 50,
              aspectRatio: 1,
              color: const Color(0x55000000))
        ]));

    // Stack(
    //   alignment: FractionalOffset.center,
    //   children: [
    //     Positioned.fill(
    //       child: AspectRatio(
    //           aspectRatio: controller.value.aspectRatio,
    //           child: CameraPreview(controller)),
    //     ),
    //     Positioned.fill(
    //       child: Center(
    //         child: Stack(
    //           children: [
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //
    //                 const SizedBox(height: 24),
    //                 Container(
    //                   decoration: BoxDecoration(
    //                       border: Border.all(width: 1, color: Colors.white),
    //                       color: Colors.transparent),
    //                   width: MediaQuery.of(context).size.width * 0.7,
    //                   height: MediaQuery.of(context).size.height * 0.5,
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget cameraOverlay({
    required double vPadding,
    required double hPadding,
    required double aspectRatio,
    required Color color,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = hPadding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * vPadding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = vPadding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * hPadding) * aspectRatio)) /
            2;
      }
      return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Container(width: horizontalPadding, color: color)),
            Align(
                alignment: Alignment.centerRight,
                child: Container(width: horizontalPadding, color: color)),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.only(
                        left: horizontalPadding, right: horizontalPadding),
                    height: verticalPadding,
                    color: color)),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(
                        left: horizontalPadding, right: horizontalPadding),
                    height: verticalPadding,
                    color: color)),
            const SizedBox(height: 24),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
            )
          ]);
    });
  }
}
