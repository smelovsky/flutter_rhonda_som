import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const Padding(
      padding: EdgeInsets.only(top: 40, bottom:0, left:10, right:10),
      child: Column(
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                  'Rhonda SoM App'
              )
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                  'created by Michael Smelovsky (msmelovs@rhonda.ru)'
              )
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                  'created with Flutter'
              )
          ),
        ],
      )
    );
  }
}