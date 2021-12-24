import 'package:flutter/material.dart';
import 'package:openlaundry/qr_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
          ),
          Container(
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'QR Code',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QrPage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
