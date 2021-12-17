import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/constants.dart';
import 'package:openlaundry/generic_selector.dart';
import 'package:openlaundry/model.dart';
import 'package:collection/collection.dart';
import 'package:openlaundry/print_receipt_page.dart';
import 'package:uuid/uuid.dart';

class LaundryRecordEditor extends StatefulWidget {
  const LaundryRecordEditor({
    Key? key,
    this.uuid,
    this.onSave,
  }) : super(key: key);

  final String? uuid;
  final Function()? onSave;

  @override
  _LaundryRecordEditorState createState() => _LaundryRecordEditorState();
}

class _LaundryRecordEditorState extends State<LaundryRecordEditor> {
  LaundryRecord? _laundryRecord;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final l = (await Hive.openBox<LaundryRecord>(laundryRecordsHiveTable))
        .values
        .firstWhereOrNull(
          (l) => l.uuid == widget.uuid,
        );

    setState(() {
      _laundryRecord = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laundry Record Editor',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              _laundryRecord?.updated = DateTime.now().millisecondsSinceEpoch;
              await _laundryRecord?.save();

              //save details
              (await Hive.openBox<LaundryRecordDetail>(
                      laundryRecordDetailsHiveTable))
                  .values
                  .where(
                    (lD) => lD.laundryRecordUuid == _laundryRecord?.uuid,
                  )
                  .forEach(
                (lD) async {
                  await lD.save();
                },
              );

              Navigator.pop(context);
              widget.onSave?.call();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
            ),
            Container(
              child: MaterialButton(
                color: Colors.purple,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrintReceiptPage(
                        uuid: _laundryRecord?.uuid,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Print Receipt',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Date'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                    DateTime.now().year - 100,
                                  ),
                                  lastDate: DateTime(
                                    DateTime.now().year + 100,
                                  ),
                                );

                                if (date != null) {
                                  setState(() {
                                    _laundryRecord?.date = DateTime.parse(
                                      '${date.toIso8601String().split('T')[0]}T00:00:00Z',
                                    ).millisecondsSinceEpoch;
                                  });
                                }
                              },
                              child: Text(
                                _laundryRecord?.date != null
                                    ? DateFormat.yMMMEd().format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          _laundryRecord!.date!,
                                        ).toLocal(),
                                      )
                                    : 'Select Date',
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            'Customer',
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: TextButton(
                          onPressed: () async {
                            final customers = (await Hive.openBox<Customer>(
                                    customersHiveTable))
                                .values;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GenericSelector<Customer>(
                                  title: 'Select Customer',
                                  list: customers,
                                  getLabel: (c) => '${c?.name} (${c?.address})',
                                  onSelect: (c) {
                                    setState(() {
                                      _laundryRecord?.customerUuid = c?.uuid;
                                    });
                                  },
                                  searchCriteria: (c, search) =>
                                      '${c?.name ?? ''}${c?.address ?? ''}'
                                          .toLowerCase()
                                          .contains(
                                            search?.toLowerCase() ?? '',
                                          ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                child: FutureBuilder(
                                  future: Hive.openBox<Customer>(
                                      customersHiveTable),
                                  builder: (ctx,
                                      AsyncSnapshot<Box<Customer>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      final c = snapshot.data?.values
                                          ?.firstWhereOrNull((c) =>
                                              c.uuid ==
                                              _laundryRecord?.customerUuid);
                                      return Container(
                                        child: Column(
                                          children: [
                                            ...(_laundryRecord?.customerUuid !=
                                                    null
                                                ? [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        c?.name != null &&
                                                                c?.name != ""
                                                            ? (c?.name ?? '')
                                                            : 'No Name',
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        c?.address != null &&
                                                                c?.address != ''
                                                            ? c?.address ?? ''
                                                            : 'No Address',
                                                      ),
                                                    )
                                                  ]
                                                : [
                                                    Text(
                                                      'Select Customer',
                                                    )
                                                  ]),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        child: Text('Loading...'),
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Weight',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      alignment: Alignment.centerRight,
                      child: TextField(
                        controller: TextEditingController()
                          ..text = '${_laundryRecord?.weight ?? 0}',
                        onChanged: (v) {
                          _laundryRecord?.weight =
                              double.tryParse(v) ?? _laundryRecord?.weight;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Weight (kg)',
                          ),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Price',
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final box = (await Hive.openBox<LaundryRecordDetail>(
                          laundryRecordDetailsHiveTable,
                        ));

                        final lD = LaundryRecordDetail()
                          ..name = ''
                          ..created = DateTime.now().millisecondsSinceEpoch
                          ..updated = DateTime.now().millisecondsSinceEpoch
                          ..uuid = Uuid().v4()
                          ..laundryRecordUuid = _laundryRecord?.uuid
                          ..price = 0.0;

                        box.add(lD);
                        await lD.save();

                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.add),
                          Text(
                            'Add Detail',
                          )
                        ],
                      ),
                    ),
                  )
                      // Container(
                      //   margin: EdgeInsets.only(
                      //     top: 10,
                      //     bottom: 10,
                      //   ),
                      //   alignment: Alignment.centerRight,
                      //   child: TextField(
                      //     controller: TextEditingController()
                      //       ..text = '${_laundryRecord?.price ?? 0}',
                      //     onChanged: (v) {
                      //       _laundryRecord?.price =
                      //           double.tryParse(v) ?? _laundryRecord?.price;
                      //     },
                      //     decoration: InputDecoration(
                      //       label: Text(
                      //         'Price',
                      //       ),
                      //       isDense: true,
                      //       border: OutlineInputBorder(),
                      //     ),
                      //   ),
                      // ),
                      )
                ],
              ),
            ),
            // Container(
            //   child: TextButton(
            //     child: Text('Check'),
            //     onPressed: () async {
            //       final lDs = (await Hive.openBox<LaundryRecordDetail>(
            //               laundryRecordDetailsHiveTable))
            //           .values
            //           ?.where(
            //               (lD) => lD.laundryRecordUuid == _laundryRecord?.uuid)
            //           .toList();

            //       showDialog(
            //         context: context,
            //         builder: (_) => AlertDialog(
            //           title: Text('debug'),
            //           content: Text(
            //             jsonEncode(lDs),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Container(
              child: FutureBuilder(
                future: (Hive.openBox<LaundryRecordDetail>(
                  laundryRecordDetailsHiveTable,
                )),
                builder: (
                  ctx,
                  AsyncSnapshot<Box<LaundryRecordDetail>> snapshot,
                ) {
                  final lDs = snapshot.data?.values.where(
                    (lD) =>
                        lD.deleted == null &&
                        lD.laundryRecordUuid == _laundryRecord?.uuid,
                  );

                  return Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total: ${NumberFormat.decimalPattern().format(
                                        lDs?.fold(
                                          0.0,
                                          (acc, lD) =>
                                              (acc as double) + (lD.price ?? 0),
                                        ),
                                      ) ?? 0} ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                child: TextButton(
                                  child: Text(
                                    'Refresh',
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        ...(lDs
                                ?.map(
                                  (lD) => Container(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: TextField(
                                                  onChanged: (v) {
                                                    lD.updated = DateTime.now()
                                                        .millisecondsSinceEpoch;
                                                    lD.name = v;
                                                  },
                                                  controller:
                                                      TextEditingController()
                                                        ..text = lD.name ?? '',
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    label: Text(
                                                      'Name',
                                                    ),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: TextField(
                                                  onChanged: (v) {
                                                    lD.updated = DateTime.now()
                                                        .millisecondsSinceEpoch;
                                                    lD.price =
                                                        double.tryParse(v) ??
                                                            lD.price;
                                                  },
                                                  controller:
                                                      TextEditingController()
                                                        ..text =
                                                            '${lD?.price}' ??
                                                                '0.0',
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    label: Text(
                                                      'Price',
                                                    ),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Container(
                                        //   child: Text(
                                        //     lD?.uuid ?? '',
                                        //   ),
                                        // ),
                                        Container(
                                          child: Divider(),
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                .toList() ??
                            [])
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Paid?',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Checkbox(
                        value: _laundryRecord?.isPaid == 1,
                        onChanged: (v) {
                          if (v != null && v) {
                            setState(() {
                              _laundryRecord?.updated =
                                  DateTime.now().millisecondsSinceEpoch;
                              _laundryRecord?.isPaid = 1;
                            });
                          } else {
                            setState(() {
                              _laundryRecord?.updated =
                                  DateTime.now().millisecondsSinceEpoch;
                              _laundryRecord?.isPaid = 0;
                              _laundryRecord?.paidValue = 0;
                            });
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            ...(_laundryRecord?.isPaid == 1
                ? [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Paid Value',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              alignment: Alignment.centerRight,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = '${_laundryRecord?.paidValue ?? 0}',
                                onChanged: (v) {
                                  _laundryRecord?.updated =
                                      DateTime.now().millisecondsSinceEpoch;
                                  _laundryRecord?.paidValue =
                                      double.tryParse(v) ??
                                          _laundryRecord?.paidValue;
                                },
                                decoration: InputDecoration(
                                  label: Text(
                                    'Paid value',
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ]
                : []),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Note',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      alignment: Alignment.centerRight,
                      child: TextField(
                        maxLines: null,
                        controller: TextEditingController()
                          ..text = '${_laundryRecord?.note ?? ''}',
                        onChanged: (v) {
                          _laundryRecord?.note = v;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Note',
                          ),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
