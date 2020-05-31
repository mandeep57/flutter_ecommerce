import 'package:flutter/material.dart';
import 'package:heady_ecommerce/utils/constants.dart';
class ReturnPolicy extends StatefulWidget {
  @override
  _ReturnPolicyState createState() => _ReturnPolicyState();
}

class _ReturnPolicyState extends State<ReturnPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Return Policy'),
          centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            _headingText(returnPolicyHeading1),
            _normalText(retunPolicyText1),
            _headingText(returnPolicyHeading2),
            _normalText(returnPolicyText2),
          ],
        ),
      ),
    );
  }
}

Widget _normalText(String text) {
  return Text(text);
}

Widget _headingText(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  );
}
