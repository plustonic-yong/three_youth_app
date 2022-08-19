import 'package:flutter/material.dart';
import 'package:three_youth_app/widget/agreement/use_of_terms.dart';

class UseOfTermsScreen extends StatelessWidget {
  const UseOfTermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          '이용약관',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: useOfTerms(),
        ),
      ),
    );
  }
}
