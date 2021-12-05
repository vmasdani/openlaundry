import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
          ),
          Container(
            child: Text(
              'Calculator',
            ),
          )
        ],
      ),
    );
  }
}
