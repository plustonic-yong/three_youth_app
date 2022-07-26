import 'dart:async';
import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';

class NavigateAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NavigateAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  _NavigateAppBarState createState() => _NavigateAppBarState();
}

class _NavigateAppBarState extends State<NavigateAppBar> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {});

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: ColorAssets.white,
      leading: SizedBox(
        width: 50,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorAssets.fontDarkGrey,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
          },
        ),
      ),
      title: InkWell(
        onTap: () {
          //Navigator.pushNamedAndRemoveUntil(context, '/overview', (route) => false);
        },
        child: Image.asset(
          'assets/images/logo_bg_none.png',
          width: 320,
          height: 65,
        ),
      ),
      centerTitle: true,
      actions: const [
        SizedBox(
          width: 55,
        )
      ],
    );
  }
}
