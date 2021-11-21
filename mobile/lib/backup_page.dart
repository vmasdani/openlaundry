import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/helpers.dart';
import 'package:openlaundry/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:openlaundry/google_sign_in_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _expandAdvanced = false;
  bool _loading = false;
  TextEditingController _baseUrlController = TextEditingController();

  @override
  void initState() {
    final state = context.read<AppState>();

    _baseUrlController.text = state.baseUrl ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // RefreshIndicator(
        //     child:

        Consumer<AppState>(builder: (ctx, state, child) {
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Backup',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Container(
              child: Text('Email:'),
            ),
            Container(
              child: Text(
                state.email != null ? state.email ?? '' : 'Not signed in',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: state.email != null ? Colors.green : Colors.red),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text('Last update: ' +
                        (() {
                          final date = state.updatedAt != null
                              ? DateTime.parse('${state.updatedAt}Z').toLocal()
                              : null;

                          return date != null
                              ? DateFormat().add_yMMMEd().add_jm().format(date)
                              : 'None';
                        })()),
                  )
                ],
              ),
            ),
            ...(state.email != null
                ? [
                    Center(
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();

                              print(
                                  '[Customers prefs] ${prefs.getString('customers')?.length}');
                              print(
                                  '[Expenses prefs] ${prefs.getString('expenses')?.length}');

                              print(
                                  '[Requesting to] ${'${state.baseUrl}/backup'}');
                              final res = await http.post(
                                  Uri.parse('${state.baseUrl}/backup'),
                                  headers: {
                                    'authorization': state.idToken ?? '',
                                    'content-type': 'application/json'
                                  },
                                  body: jsonEncode({
                                    'email': state.email,
                                    'customers': prefs.getString("customers"),
                                    'laundryDocuments':
                                        prefs.getString("laundrydocuments"),
                                    'laundryRecords':
                                        prefs.getString("laundryrecords"),
                                    'expenses': prefs.getString("expenses"),
                                  }));

                              if (res.statusCode != HttpStatus.ok)
                                throw res.body;

                              print('[Backup success] ${res.body}');

                              print('[Decoding]');
                              print(jsonDecode(res.body));
                              final backupRecord =
                                  BackupRecord.fromJson(jsonDecode(res.body));
                              print('[Decoding OK]');

                              print(backupRecord.customers);

                              // Set pref strings and backup

                              print('[Setting cust]');
                              print(backupRecord.customers);
                              // Customers
                              if (backupRecord.customers != null) {
                                await prefs.setString(
                                    'customers', backupRecord.customers!);
                              }

                              // Laundry Documents
                              print('[Setting docs]');

                              if (backupRecord.laundryDocuments != null) {
                                await prefs.setString('laundrydocuments',
                                    backupRecord.laundryDocuments!);
                              }

                              // Laundry records
                              print('[Setting records]');

                              if (backupRecord.laundryRecords != null) {
                                await prefs.setString('laundryrecords',
                                    backupRecord.laundryRecords!);
                              }

                              // Expenses
                              print('[Setting expenses]');
                              if (backupRecord.expenses != null) {
                                await prefs.setString(
                                    'expenses', backupRecord.expenses!);
                              }

                              print('[Setting createdAt and updatedAt]');
                              // Created and updatedAt
                              state.setCreatedAt(backupRecord.createdAt);
                              state.setUpdatedAt(backupRecord.updatedAt);

                              await state.initState();

                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text('Success!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          )
                                        ],
                                      ));
                            } catch (e) {
                              print('[Synchronisation error] $e');

                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text('Error!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('$e'),
                                          )
                                        ],
                                      ));
                            }
                          },
                          icon: Icon(Icons.sync),
                          label: Text(
                            'Sync',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ]
                : []),
            Divider(),
            ...(state.email == null
                ? [
                    Container(
                      margin: EdgeInsets.only(top: 35, bottom: 10),
                      child: Center(
                        child: MaterialButton(
                          color: Colors.grey[100],
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Google sign-in',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icon/google.png',
                                        ),
                                        width: 25,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final res = await googleSignIn.signIn();
                              final auth = await res?.authentication;

                              if (res?.email != null) {
                                state.setEmail(res?.email);
                                prefs.setString('email', res!.email);
                              }

                              if (auth?.accessToken != null) {
                                state.setAccessToken(auth?.accessToken);
                                prefs.setString(
                                    'accessToken', auth!.accessToken!);
                              }

                              print('[ACCESS TOKEN] ${auth?.accessToken}');
                              print('[ID TOKEN] ${auth?.idToken}');

                              state.initState();
                            } catch (e) {
                              print('\n\n[SIGNIN ERROR] $e \n\n');
                            }
                          },
                        ),
                      ),
                    )
                  ]
                : [
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: MaterialButton(
                          color: Colors.red[700],
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Google sign-out',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icon/google.png',
                                        ),
                                        width: 25,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            try {
                              final state = context.read<AppState>();
                              final prefs =
                                  await SharedPreferences.getInstance();

                              await googleSignIn.disconnect();

                              state.setEmail(null);
                              state.setAccessToken(null);

                              prefs.remove('email');
                              prefs.remove('accessToken');
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                  ]),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.green,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Save to JSON file',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.save_alt,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final path = await (() async {
                        if (Platform.isAndroid) {
                          return await getExternalStorageDirectory();
                        } else {
                          return await getApplicationDocumentsDirectory();
                        }
                      })();

                      final fullPath =
                          '${path?.path}/openlaundry_backup_${makeReadableDateString(DateTime.now())}_${DateTime.now().millisecondsSinceEpoch}.txt';

                      print('Start encoding here');
                      print(fullPath);

                      final jsonFileContents = jsonEncode({
                        'customers': base64.encode(GZipCodec()
                            .encode(utf8.encode(jsonEncode(state.customers)))),
                        'laundryrecords': base64.encode(GZipCodec().encode(
                            utf8.encode(jsonEncode(state.laundryRecords)))),
                        'laundrydocuments': base64.encode(GZipCodec().encode(
                            utf8.encode(jsonEncode(state.laundryDocuments))))
                      });

                      await (File(fullPath)).writeAsString(jsonFileContents);

                      print('Write finished here');

                      print(fullPath);
                      print(jsonFileContents);

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Saved!'),
                                content: Text('Saved to $fullPath'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        OpenFile.open(fullPath);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Open File'))
                                ],
                              ));
                    } catch (e) {
                      print('[Error] $e');
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.blue,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Import data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.backup_outlined,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Divider(),
            Container(
              child: ExpansionPanelList(
                expansionCallback: (_, _1) {
                  setState(() {
                    _expandAdvanced = !_expandAdvanced;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Advanced',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            child: MaterialButton(
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                final state = context.read<AppState>();

                                state.setBaseUrl(_baseUrlController.text);
                                final prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString(
                                    'baseUrl', _baseUrlController.text);

                                await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text('Saved!'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'))
                                          ],
                                        ));
                              },
                            ),
                          ),
                          Container(
                            child: Text('Server URL:'),
                          ),
                          Container(
                            child: TextField(
                              controller: _baseUrlController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  hintText: 'Server URL (ex: https://..)'),
                            ),
                          )
                        ],
                      ),
                    ),
                    isExpanded: _expandAdvanced,
                  )
                ],
              ),
            )
          ],
        ),
      );
    });

    // ,
    // onRefresh: () async {}
    // )

    ;
  }
}
