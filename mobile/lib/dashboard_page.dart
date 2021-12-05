import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/constants.dart';
import 'package:openlaundry/document_editor.dart';
import 'package:openlaundry/generic_selector.dart';
import 'package:openlaundry/helpers.dart';
import 'package:openlaundry/laundry_record_editor.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _from = DateTime.parse(
    '${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 7).toLocal().toIso8601String().split('T')[0]}T00:00:00Z',
  ).millisecondsSinceEpoch;

  var _to = DateTime.parse(
    '${DateTime.now().toLocal().toIso8601String().split('T')[0]}T00:00:00Z',
  ).millisecondsSinceEpoch;

  String? _filterCustomerUuid;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final l = LaundryRecord()
            ..uuid = Uuid().v4()
            ..createdAt = DateTime.now().millisecondsSinceEpoch
            ..updatedAt = DateTime.now().millisecondsSinceEpoch
            ..date = DateTime.parse(
              '${DateTime.now().toLocal().toIso8601String().split('T')[0]}T00:00:00Z',
            ).millisecondsSinceEpoch;

          (await Hive.openBox<LaundryRecord>(laundryRecordsHiveTable)).add(l);

          await l.save();

          setState(() {});
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 100),
                          lastDate: DateTime(DateTime.now().year + 100),
                        );

                        if (date != null) {
                          setState(() {
                            _from = DateTime.parse('${date}Z')
                                .millisecondsSinceEpoch;
                          });
                        }
                      },
                      child: Text(
                        _from != null
                            ? DateFormat.yMMMEd().format(
                                DateTime.fromMillisecondsSinceEpoch(_from)
                                    .toLocal(),
                              )
                            : 'From',
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text('to'),
                  ),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 100),
                          lastDate: DateTime(DateTime.now().year + 100),
                        );

                        if (date != null) {
                          setState(() {
                            _to = DateTime.parse('${date}Z')
                                .millisecondsSinceEpoch;
                          });
                        }
                      },
                      child: Text(
                        _to != null
                            ? DateFormat.yMMMEd().format(
                                DateTime.fromMillisecondsSinceEpoch(_to)
                                    .toLocal(),
                              )
                            : 'To',
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Filter by Customer',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final customers =
                            (await Hive.openBox<Customer>(customersHiveTable))
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
                                  _filterCustomerUuid = c?.uuid;
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
                      child: (_filterCustomerUuid != null
                          ? FutureBuilder(
                              future:
                                  Hive.openBox<Customer>(customersHiveTable),
                              builder:
                                  (ctx, AsyncSnapshot<Box<Customer>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  final c =
                                      snapshot.data?.values?.firstWhereOrNull(
                                    (c) => c?.uuid == _filterCustomerUuid,
                                  );
                                  return Text(
                                    '${c?.name ?? 'No name'} (${c?.address ?? 'No address'})',
                                  );
                                } else {
                                  return Text('Loading...');
                                }
                              })
                          : Text('Select Customer')),
                    ),
                    ...(_filterCustomerUuid != null
                        ? [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _filterCustomerUuid = null;
                                });
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ]
                        : [])
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              (FutureBuilder(
                future: Hive.openBox<LaundryRecord>(laundryRecordsHiveTable),
                builder: (ctx, AsyncSnapshot<Box<LaundryRecord>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              child: Text(
                                'Showing ${snapshot.data?.values?.length} records',
                              ),
                            ))
                          ],
                        ),
                      ),
                      ...((snapshot.data)
                              ?.values
                              .where(
                                (l) =>
                                    (l.date ?? 0) >= _from &&
                                    (l.date ?? 0) <= _to &&
                                    (_filterCustomerUuid != null
                                        ? l?.customerUuid == _filterCustomerUuid
                                        : true),
                              )
                              .toList()
                              .reversed
                              .mapIndexed(
                                (i, l) => GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LaundryRecordEditor(
                                          uuid: l.uuid,
                                          onSave: () {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            // spreadRadius: 5,
                                            offset: Offset(5, 5),
                                            color: Colors.black26,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Text('${i + 1}. '),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      l.date != null
                                                          ? DateFormat.yMMMEd()
                                                              // .add_jms()
                                                              .format(
                                                              DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                l.date!,
                                                              ).toUtc(),
                                                            )
                                                          : 'No date',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: FutureBuilder(
                                                  future:
                                                      (Hive.openBox<Customer>(
                                                          customersHiveTable)),
                                                  builder: (ctx,
                                                      AsyncSnapshot<
                                                              Box<Customer>>
                                                          customers) {
                                                    return customers
                                                                .connectionState ==
                                                            ConnectionState.done
                                                        ? (() {
                                                            final c = (customers
                                                                    .data)
                                                                ?.values
                                                                .firstWhereOrNull(
                                                                  (c) =>
                                                                      c.uuid ==
                                                                      l.customerUuid,
                                                                );
                                                            return Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      c?.name ??
                                                                          'No customer',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      c?.address ??
                                                                          'No address',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          })()
                                                        : Text(
                                                            'Loading customer...',
                                                          );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${l?.weight ?? 0.0} kg : ${NumberFormat.decimalPattern().format(
                                                      l.price ?? 0,
                                                    )}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    l?.isPaid == 1
                                                        ? 'Paid ${NumberFormat.decimalPattern().format(
                                                            l?.paidValue ?? 0,
                                                          )}'
                                                        : 'Unpaid',
                                                    style: TextStyle(
                                                      color: l?.isPaid == 1
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Container(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Note'),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    l?.note != null &&
                                                            l?.note != ""
                                                        ? l?.note ?? ''
                                                        : 'No note',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Divider(),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        Container(
                                          child: Text(
                                            'Created ${l.createdAt != null ? DateFormat.yMMMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(l.createdAt!)) : ''}, Updated ${l.updatedAt != null ? DateFormat.yMMMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(l.updatedAt!)) : ''}',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList() ??
                          [])
                    ]);
                  } else {
                    return Container(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
