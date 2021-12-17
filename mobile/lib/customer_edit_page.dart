import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/constants.dart';
import 'package:openlaundry/model.dart';
import 'package:collection/collection.dart';

class CustomerEditPage extends StatefulWidget {
  const CustomerEditPage({
    Key? key,
    this.uuid,
    this.onSave,
  }) : super(key: key);

  final String? uuid;
  final Function()? onSave;

  @override
  _CustomerEditPageState createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  Customer? _customer;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final c = (await Hive.openBox<Customer>(customersHiveTable))
        .values
        .firstWhereOrNull(
          (c) => c.uuid == widget.uuid,
        );

    setState(() {
      _customer = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Editor',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              _customer?.updated = DateTime.now().millisecondsSinceEpoch;
              await _customer?.save();
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
              child: TextField(
                onChanged: (v) {
                  _customer?.name = v;
                },
                controller: TextEditingController()
                  ..text = _customer?.name ?? '',
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  label: Text(
                    'Name',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: TextField(
                onChanged: (v) {
                  _customer?.address = v;
                },
                controller: TextEditingController()
                  ..text = _customer?.address ?? '',
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  label: Text(
                    'Address',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              child: TextField(
                onChanged: (v) {
                  _customer?.phone = v;
                },
                controller: TextEditingController()
                  ..text = _customer?.phone ?? '',
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  label: Text(
                    'Phone',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'Laundry info',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: Hive.openBox<LaundryRecord>(laundryRecordsHiveTable),
              builder: (ctx, AsyncSnapshot<Box<LaundryRecord>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        child: FutureBuilder(
                          future: Hive.openBox<LaundryRecordDetail>(
                            laundryRecordDetailsHiveTable,
                          ),
                          builder: (
                            ctx,
                            AsyncSnapshot<Box<LaundryRecordDetail>> lDSnapshot,
                          ) {
                            final customerRecords =
                                (snapshot.data)?.values.where(
                                      (l) =>
                                          l.customerUuid == widget.uuid &&
                                          l.deleted == null,
                                    );

                            final customerPaidValues = customerRecords?.fold(
                              0.0,
                              (acc, l) => (acc as double) + (l.paidValue ?? 0),
                            );

                            final customerRecordPrices = customerRecords
                                ?.map(
                                  (l) =>
                                      lDSnapshot.data?.values.where(
                                        (lD) =>
                                            lD.laundryRecordUuid == l.uuid &&
                                            lD.deleted == null,
                                      ) ??
                                      [],
                                )
                                .expand(
                                  (lD) => lD,
                                )
                                .fold(
                                  0.0,
                                  (acc, lD) =>
                                      (acc as double) + (lD.price ?? 0),
                                );

                            return Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Balance: ' +
                                        (() {
                                          return '${NumberFormat.decimalPattern().format((customerPaidValues ?? 0) - (customerRecordPrices ?? 0))}';
                                        })(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: ((customerPaidValues ?? 0) -
                                                  (customerRecordPrices ?? 0)) <
                                              0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  Container(
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  ...(((snapshot.data)
                                          ?.values
                                          .toList()
                                          .reversed
                                          .where((l) =>
                                              l.customerUuid == widget.uuid)
                                          .map((l) => Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              l.date != null
                                                                  ? DateFormat()
                                                                      .add_yMMMEd()
                                                                      .format(
                                                                        DateTime
                                                                            .fromMillisecondsSinceEpoch(
                                                                          l.date!,
                                                                        ).toUtc(),
                                                                      )
                                                                  : 'No date',
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Container(
                                                              child: Text(
                                                                '${l?.weight ?? 0.0} kg',
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Price ${NumberFormat.decimalPattern().format(
                                                                  (lDSnapshot
                                                                          .data
                                                                          ?.values
                                                                          .where((lD) =>
                                                                              lD.laundryRecordUuid == l.uuid &&
                                                                              lD.deleted == null)
                                                                          .fold(
                                                                            0.0,
                                                                            (acc, lD) =>
                                                                                (acc as double) +
                                                                                (lD.price ?? 0.0),
                                                                          ) ??
                                                                      0.0),
                                                                )}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                'Paid ${NumberFormat.decimalPattern().format(
                                                                  l?.paidValue ??
                                                                      0,
                                                                )}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: (l?.paidValue ??
                                                                              0) <
                                                                          (l?.price ??
                                                                              0)
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .green,
                                                                ),
                                                              ),
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
                                                  ],
                                                ),
                                              ))
                                          .toList() ??
                                      []))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   margin: EdgeInsets.only(
                      //     top: 15,
                      //     bottom: 15,
                      //   ),
                      //   child: (() {
                      //     final depositValue = (snapshot.data)
                      //         ?.values
                      //         .where((l) => l.customerUuid == widget.uuid)
                      //         .fold(
                      //           0.0,
                      //           (acc, l) =>
                      //               (acc as double) -
                      //               (l?.price ?? 0.0) +
                      //               (l?.paidValue ?? 0.0),
                      //         );

                      //     return Text(
                      //       'Deposit: ' +
                      //           (() {
                      //             return '$depositValue';
                      //           })(),
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 18,
                      //         color: (depositValue ?? 0) < 0
                      //             ? Colors.red
                      //             : Colors.green,
                      //       ),
                      //     );
                      //   })(),
                      // ),
                      // Container(
                      //   child: Divider(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
