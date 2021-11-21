import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/helpers.dart';
import 'dart:convert';
import 'package:openlaundry/laundry_record_add.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class DocumentEditor extends StatefulWidget {
  final LaundryDocument? laundryDocument;

  DocumentEditor({this.laundryDocument});

  @override
  _DocumentEditorState createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor> {
  final _documentNameController = TextEditingController();
  LaundryDocument? _laundryDocument;

  @override
  void initState() {
    _laundryDocument = LaundryDocument.fromJson(
        jsonDecode(jsonEncode(widget.laundryDocument)));

    if (_laundryDocument?.uuid == null) {
      setState(() {
        _documentNameController.text =
            'Doc ${makeReadableDateString(DateTime.now())}';
      });
    } else {
      setState(() {
        _documentNameController.text = _laundryDocument?.name ?? '';
      });
    }

    if (_laundryDocument?.date == null) {
      _laundryDocument?.date =
          DateTime.parse(makeDateString(DateTime.now())).millisecondsSinceEpoch;
    }

    super.initState();
  }

  Future<void> _save() async {
    _laundryDocument?.name = _documentNameController.text;

    final state = context.read<AppState>();

    if (_laundryDocument != null) {
      final savedLaundryDocumentId = await state.saveGeneric(_laundryDocument!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _laundryDocument?.uuid != null &&
              _laundryDocument?.uuid != ''
          ? FloatingActionButton(
              onPressed: () {
                final newLaundryRecord = LaundryRecord();
                newLaundryRecord.laundryDocumentUuid = _laundryDocument?.uuid;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LaundryRecordAdd(
                              laundryRecord: newLaundryRecord,
                            )));
              },
              child: Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        title: Text('Document Editor'),
        actions: [
          TextButton(
            child: Text('Save',
                style: TextStyle(
                  color: Colors.white,
                )),
            onPressed: () async {
              await _save();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                controller: _documentNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Document Name...',
                    labelText: 'Document Name'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text('Date'),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                            '${_laundryDocument?.date != null ? makeReadableDateString(DateTime.fromMillisecondsSinceEpoch(_laundryDocument!.date!)) : 'Select'}'),
                        onPressed: () async {
                          final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 10),
                              lastDate: DateTime(DateTime.now().year + 10));

                          if (date != null) {
                            setState(() {
                              _laundryDocument?.date =
                                  date.millisecondsSinceEpoch;
                            });
                          }
                        },
                      )),
                )
              ],
            ),
            Container(
              child: Divider(),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total income',
                      style: TextStyle(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Consumer<AppState>(
                        builder: (ctx, state, child) {
                          final income = state.laundryRecords
                              ?.where((laundryRecord) =>
                                  laundryRecord.laundryDocumentUuid ==
                                      _laundryDocument?.uuid &&
                                  laundryRecord.deletedAt == null)
                              .map((laundryRecord) => laundryRecord.price ?? 0)
                              .fold(
                                  0,
                                  (acc, laundryRecordPrice) =>
                                      (acc as int) + laundryRecordPrice);

                          return Text(
                            NumberFormat.simpleCurrency(locale: 'id-ID')
                                .format(income ?? 0),
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),
            Consumer<AppState>(
              builder: (ctx, state, child) {
                return Container(
                  child: Column(
                      children: _laundryDocument?.uuid == null
                          ? []
                          : List<LaundryRecord>.from(
                                  state.laundryRecords?.reversed ??
                                      Iterable.empty())
                              .where((laundryRecord) =>
                                  laundryRecord.laundryDocumentUuid ==
                                      widget.laundryDocument?.uuid &&
                                  laundryRecord.deletedAt == null)
                              .map((laundryRecord) {
                              final foundCustomer =
                                  state.customers?.firstWhereOrNull(
                                (customer) =>
                                    customer.uuid ==
                                        laundryRecord.customerUuid &&
                                    customer.deletedAt == null,
                              );

                              return Column(
                                children: [
                                  GestureDetector(
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: Text(
                                                      'Delete laundry record?'),
                                                  actions: [
                                                    Consumer<AppState>(
                                                      builder:
                                                          (ctx, state, child) {
                                                        return TextButton(
                                                          child: Text('Yes'),
                                                          onPressed: () async {
                                                            await state.delete<
                                                                    LaundryRecord>(
                                                                laundryRecord
                                                                    .uuid);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ));
                                      },
                                      onTap: () {
                                        final newLaundryRecord =
                                            LaundryRecord.fromJson(jsonDecode(
                                                jsonEncode(laundryRecord)));

                                        newLaundryRecord.laundryDocumentUuid =
                                            _laundryDocument?.uuid;

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    LaundryRecordAdd(
                                                      laundryRecord:
                                                          newLaundryRecord,
                                                    )));
                                      },
                                      child: Container(
                                        child: Card(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(foundCustomer
                                                                      ?.name ??
                                                                  ''),
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Row(
                                                              children: [
                                                                TextButton(
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .message,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      Text(
                                                                        foundCustomer?.phone ??
                                                                            '',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await canLaunch(
                                                                            'whatsapp://send?phone=${foundCustomer?.phone ?? ''}')
                                                                        ? launch(
                                                                            'whatsapp://send?phone=${foundCustomer?.phone ?? ''}')
                                                                        : showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (_) =>
                                                                                AlertDialog(
                                                                                  title: Text('Failed to open WhatsApp'),
                                                                                  content: Text('Invalid number or system error'),
                                                                                ));
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            NumberFormat.simpleCurrency(
                                                                    locale:
                                                                        'id-ID')
                                                                .format(laundryRecord
                                                                        .price ??
                                                                    0),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text((() {
                                                            switch (
                                                                laundryRecord
                                                                    .type) {
                                                              case 0:
                                                                return 'Cash';
                                                              case 1:
                                                                return 'E-Pay';
                                                              default:
                                                                return 'None selected';
                                                            }
                                                          })()),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                              '${laundryRecord.weight ?? 0} kg'),
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Icon(Icons
                                                              .location_pin)),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '${foundCustomer?.address ?? ''}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                ...(laundryRecord.note !=
                                                            null ||
                                                        laundryRecord.note != ''
                                                    ? [
                                                        Divider(),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    'Note',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    laundryRecord
                                                                            .note ??
                                                                        ''),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ]
                                                    : []),
                                                Divider(),
                                                Container(
                                                    child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child: Text('Wash'),
                                                          ),
                                                          Center(
                                                            child: laundryRecord
                                                                            .wash !=
                                                                        null &&
                                                                    laundryRecord
                                                                        .wash!
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child: Text('Dry'),
                                                          ),
                                                          Center(
                                                            child: laundryRecord
                                                                            .dry !=
                                                                        null &&
                                                                    laundryRecord
                                                                        .dry!
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child: Text('Iron'),
                                                          ),
                                                          Center(
                                                            child: laundryRecord
                                                                            .iron !=
                                                                        null &&
                                                                    laundryRecord
                                                                        .iron!
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                Divider(),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            'Start:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  '${laundryRecord.start != null ? '${DateFormat.yMMMEd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(laundryRecord.start ?? 0).toLocal())} ${DateTime.fromMillisecondsSinceEpoch(laundryRecord.start ?? 0).toLocal().timeZoneName}' : 'Not Finished'}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          700]),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            'Done:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '${laundryRecord.done != null ? '${DateFormat.yMMMEd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(laundryRecord.done ?? 0).toLocal())} ${DateTime.fromMillisecondsSinceEpoch(laundryRecord.done ?? 0).toLocal().timeZoneName}' : 'Not Finished'}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            'Received:',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '${laundryRecord.received != null ? '${DateFormat.yMMMEd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(laundryRecord.received ?? 0).toLocal())} ${DateTime.fromMillisecondsSinceEpoch(laundryRecord.received ?? 0).toLocal().timeZoneName}' : 'Not Finished'}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Divider(),
                                  )
                                ],
                              );
                            }).toList()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
