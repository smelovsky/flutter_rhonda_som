import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../web/web_page.dart';

class AboutScreen extends StatelessWidget {

  AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 40, bottom:0, left:10, right:10),
      child: Column(
        children: [
          Image.asset("assets/images/rhonda.png"),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom:20, left:10, right:10),
          child: RichText(
            text: TextSpan(
              text: 'https://www.rhondasoftware.com',
              style:TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => WebViewApp(url: 'https://www.rhondasoftware.com')
                  ));
                },
            ),
          ),
        ),

          Align(
              alignment: Alignment.center,
              child: Text(
                  'Rhonda SoM App'
              )
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                  'created by Michael Smelovsky'
              )
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                  '(msmelovs@rhonda.ru)'
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

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    // The InkWell wraps the custom flat button widget.
    return InkWell(
      // When the user taps the button, show a snackbar.
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tap'),
        ));
      },
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Flat Button'),
      ),
    );
  }
}