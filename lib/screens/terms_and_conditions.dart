import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          try {
            await launchUrlString('https://sites.google.com/view/majoringtd/home');
          } catch (err) {
            debugPrint('Something bad happened');
          }
        },
        child: Center(
          child: Text(
            " Terms And Conditions "
          ),
        ),
      ),
    );
  }
}
