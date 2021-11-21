import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/document_editor.dart';
import 'package:openlaundry/helpers.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _laundryDocumentSearchController = TextEditingController();
  var _filterDate = true;
  var _filterDateFrom = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);
  var _filterDateTo =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DocumentEditor(
                        laundryDocument: LaundryDocument(),
                      )));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                // Container(
                //   child: TextButton(
                //     child: Text('Save'),
                //     onPressed: () {
                //       final state = context.read<AppState>();
                //       final testCustomer =
                //           Customer(name: 'Valian', address: 'Kota sutera');

                //       state.saveGeneric(testCustomer);
                //       // state.saveGeneric(testSaveNoFactory);
                //     },
                //   ),
                // ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Consumer<AppState>(builder: (ctx, state, child) {
                    return Text(
                      'Documents (${state.laundryDocuments?.where((laundryDocument) => (laundryDocument.date ?? 0) >= _filterDateFrom.millisecondsSinceEpoch && (laundryDocument.date ?? 0) <= _filterDateTo.millisecondsSinceEpoch && laundryDocument.deletedAt == null)?.length ?? 0} records)',
                      style: TextStyle(fontSize: 18),
                    );
                  }),
                ),
                // Consumer<AppState>(builder: (ctx, state, child) {
                //   return Container(
                //     child: Text('${state.lastId}'),
                //   );
                // }),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Search: ',
                        style: TextStyle(),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Search Document',
                            isDense: true,
                          ),
                          controller: _laundryDocumentSearchController,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {});
                          })
                    ],
                  ),
                ),
                // Container(
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           child: Text('Filter Date'),
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           alignment: Alignment.centerRight,
                //           child: Switch(
                //             onChanged: (val) {
                //               setState(() {
                //                 _filterDate = val;
                //               });
                //             },
                //             value: _filterDate,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                ...(_filterDate
                    ? [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('From'),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                            onPressed: () async {
                                              final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(
                                                    DateTime.now().year - 10),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 10),
                                                initialDate: DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day),
                                              );

                                              if (date != null) {
                                                setState(() {
                                                  _filterDateFrom = date;
                                                });
                                              }
                                            },
                                            child: Text(makeReadableDateString(
                                                _filterDateFrom))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('To'),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                            onPressed: () async {
                                              final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(
                                                    DateTime.now().year - 10),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 10),
                                                initialDate: DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day),
                                              );

                                              if (date != null) {
                                                setState(() {
                                                  _filterDateTo = date;
                                                });
                                              }
                                            },
                                            child: Text(makeReadableDateString(
                                                _filterDateTo))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<AppState>(
                          builder: (ctx, state, child) {
                            final foundLaundryRecords = state.laundryDocuments
                                    ?.where((laundryDocument) =>
                                        (laundryDocument.date ?? 0) >=
                                            _filterDateFrom
                                                .millisecondsSinceEpoch &&
                                        (laundryDocument.date ?? 0) <=
                                            _filterDateTo
                                                .millisecondsSinceEpoch &&
                                        laundryDocument.deletedAt == null)
                                    .map((laundryDocument) {
                                      final foundLaundryRecords = state
                                              .laundryRecords
                                              ?.where((laundryRecord) =>
                                                  laundryRecord
                                                          .laundryDocumentUuid ==
                                                      laundryDocument.uuid &&
                                                  laundryRecord.deletedAt ==
                                                      null) ??
                                          [];

                                      return foundLaundryRecords;
                                    })
                                    .expand((element) => element)
                                    .toList() ??
                                [];

                            final unresolvedLaundries = foundLaundryRecords
                                .where((laundryRecord) =>
                                    laundryRecord.received == null &&
                                    laundryRecord.deletedAt == null)
                                .length;

                            final income = foundLaundryRecords
                                .where((laundryRecord) =>
                                    laundryRecord.received != null &&
                                    laundryRecord.deletedAt == null)
                                .fold(
                                    0,
                                    (acc, laundryRecord) =>
                                        ((acc ?? 0) as int) +
                                        (laundryRecord.price ?? 0));

                            return Column(
                              children: [
                                Container(
                                  child: Text(
                                    'Total laundries: ${foundLaundryRecords.length}',
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Unresolved laundries: $unresolvedLaundries',
                                    style: TextStyle(
                                        color: unresolvedLaundries > 0
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'Total Income:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    NumberFormat.simpleCurrency(locale: 'id-ID')
                                        .format(income),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ]
                    : []),

                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Divider(),
                ),
                // Consumer<AppState>(
                //   builder: (ctx, state, child) {
                //     return Container(
                //       margin: EdgeInsets.all(10),
                //       child: Text(jsonEncode(state.customers)),
                //     );
                //   },
                // ),
                // Divider(),
                // Consumer<AppState>(
                //   builder: (ctx, state, child) {
                //     return Container(
                //       margin: EdgeInsets.all(10),
                //       child: Text(jsonEncode(state.laundryDocuments)),
                //     );
                //   },
                // ),
                // Divider(),
                // Consumer<AppState>(
                //   builder: (ctx, state, child) {
                //     return Container(
                //       margin: EdgeInsets.all(10),
                //       child: Text(jsonEncode(state.laundryRecords)),
                //     );
                //   },
                // ),
                // Divider(),
                Consumer<AppState>(
                  builder: (ctx, state, child) {
                    return Column(
                      children: List<LaundryDocument>.from(
                              state.laundryDocuments?.reversed ??
                                  Iterable.empty())
                          .where((laundryDocument) =>

                              // Filter by name
                              (laundryDocument.name?.toLowerCase().contains(
                                      _laundryDocumentSearchController.text
                                          .toLowerCase()) ??
                                  false) &&
                              (laundryDocument.date ?? 0) >=
                                  _filterDateFrom.millisecondsSinceEpoch &&
                              (laundryDocument.date ?? 0) <=
                                  _filterDateTo.millisecondsSinceEpoch &&
                              // Filter by deletedAt
                              laundryDocument.deletedAt == null)
                          .toList()
                          .asMap()
                          .map((i, laundryDocument) => MapEntry(
                              i,
                              GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(
                                                'Delete ${laundryDocument.name}?'),
                                            actions: [
                                              Consumer<AppState>(
                                                  builder: (ctx, state, child) {
                                                return TextButton(
                                                  child: Text('Yes'),
                                                  onPressed: () async {
                                                    if (laundryDocument.uuid !=
                                                        null) {
                                                      await state.delete<
                                                              LaundryDocument>(
                                                          laundryDocument.uuid);
                                                    }

                                                    Navigator.pop(context);
                                                  },
                                                );
                                              })
                                            ],
                                          ));
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DocumentEditor(
                                                laundryDocument:
                                                    laundryDocument,
                                              )));
                                },
                                child: Column(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(3, 3),
                                              blurRadius: 5,
                                              spreadRadius: 5)
                                        ]),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${i + 1}. ${laundryDocument.name ?? 'No name'}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Consumer<AppState>(
                                          builder: (ctx, state, child) {
                                            final income = state.laundryRecords
                                                ?.where((laundryRecord) =>
                                                    laundryRecord
                                                            .laundryDocumentUuid ==
                                                        laundryDocument.uuid &&
                                                    laundryRecord.deletedAt ==
                                                        null &&
                                                    laundryRecord.received !=
                                                        null)
                                                .map((laundryRecord) =>
                                                    laundryRecord.price ?? 0)
                                                .fold(
                                                    0,
                                                    (acc, laundryRecordPrice) =>
                                                        (acc as int) +
                                                        laundryRecordPrice);

                                            return Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Total income: ${NumberFormat.simpleCurrency(locale: 'id-ID').format(income ?? 0)}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            );
                                          },
                                        ),
                                        // Container(
                                        //     child: Text(
                                        //         '${laundryDocument.deletedAt}')),
                                        Divider(),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'Date: ${makeReadableDateString(DateTime.fromMillisecondsSinceEpoch(laundryDocument.date ?? 0))}'),
                                        ),
                                        (() {
                                          final foundLaundryRecords = state
                                              .laundryRecords
                                              ?.where((laundryRecord) =>
                                                  laundryRecord
                                                          .laundryDocumentUuid ==
                                                      laundryDocument.uuid &&
                                                  laundryRecord.deletedAt ==
                                                      null);

                                          final successfulLaundries =
                                              foundLaundryRecords
                                                      ?.where((laundryRecord) =>
                                                          laundryRecord
                                                                  .received !=
                                                              null &&
                                                          laundryRecord
                                                                  .deletedAt ==
                                                              null)
                                                      .length ??
                                                  0;

                                          return Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '$successfulLaundries/${foundLaundryRecords?.length ?? 0} laundries done',
                                              style: TextStyle(
                                                  color: (successfulLaundries) <
                                                          (foundLaundryRecords
                                                                  ?.length ??
                                                              0)
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        })(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Divider(),
                                  )
                                ]),
                              )))
                          .values
                          .toList(),
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
