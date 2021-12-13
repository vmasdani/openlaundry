import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/google_sign_in_class.dart';
import 'package:openlaundry/main_component.dart';
import 'package:openlaundry/model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();

  Hive.registerAdapter(LaundryRecordAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(LaundryRecordDetailAdapter());

  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenLaundry',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    final state = context.read<AppState>();

    // state.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainComponent();
  }
}
