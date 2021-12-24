import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/constants.dart';
import 'package:openlaundry/model.dart';
import 'package:path_provider/path_provider.dart';

class PrintReceiptPage extends StatefulWidget {
  const PrintReceiptPage({
    Key? key,
    this.uuid,
  }) : super(key: key);

  final String? uuid;

  @override
  _PrintReceiptPageState createState() => _PrintReceiptPageState();
}

class _PrintReceiptPageState extends State<PrintReceiptPage> {
  BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice>? _devices = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final devices = await _bluetooth?.getBondedDevices();

      print(
        'Devices len: ${devices?.length}',
      );
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Print Receipt',
        ),
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
              child: MaterialButton(
                color: Colors.purple,
                onPressed: () async {
                  // printerManager?.startScan(
                  //   Duration(seconds: 4),
                  // );
                },
                child: Text(
                  'Scan',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ..._devices?.map((d) {
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              child: Text(d?.name ?? ''),
                            ),
                            Container(
                              child: Text(d?.address ?? ''),
                            ),
                            Container(
                              child: Divider(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: TextButton(
                          child: Text(
                            'Print',
                          ),
                          onPressed: () async {
                            final l = (await Hive.openBox<LaundryRecord>(
                              laundryRecordsHiveTable,
                            ))
                                .values
                                ?.firstWhereOrNull(
                                  (l) =>
                                      l?.uuid == widget?.uuid &&
                                      l.deleted == null,
                                );

                            final c = (await Hive.openBox<Customer>(
                              customersHiveTable,
                            ))
                                .values
                                ?.firstWhereOrNull(
                                  (c) =>
                                      c?.uuid == l?.customerUuid &&
                                      c.deleted == null,
                                );

                            try {
                              await _bluetooth?.connect(d);
                            } catch (e) {
                              print(
                                  'Bluetooth connect error, maybe already connected. ');
                            }

                            try {
                              final connStatus = await _bluetooth.isConnected;

                              if (connStatus != null && connStatus) {
                                _bluetooth.printCustom("Cinta Laundry", 2, 1);

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom(
                                  '${DateFormat.yMMMd().add_jms().format(
                                        DateTime.now().toLocal(),
                                      )} ${DateTime.now().timeZoneName}',
                                  1,
                                  1,
                                );

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom('===============', 2, 1);

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom(
                                  'Customer: ${c?.name != null && c?.name != '' ? c?.name : '[No name]'}',
                                  1,
                                  0,
                                );

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom(
                                  'Address: ${c?.address != null && c?.address != '' ? c?.address : '[No address]'}',
                                  1,
                                  0,
                                );

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom(
                                  'Phone: ${c?.phone != null && c?.phone != '' ? c?.phone : '[No phone]'}',
                                  1,
                                  0,
                                );

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom('---------------', 2, 1);

                                _bluetooth.printNewLine();

                                _bluetooth.printCustom(
                                  'Items',
                                  1,
                                  0,
                                );

                                _bluetooth.printNewLine();

                                final laundryDetails =
                                    (await Hive.openBox<LaundryRecordDetail>(
                                  laundryRecordDetailsHiveTable,
                                ))
                                        .values
                                        .where(
                                          (lD) =>
                                              lD.laundryRecordUuid == l?.uuid &&
                                              lD.deleted == null,
                                        );

                                laundryDetails.forEachIndexed(
                                  (i, lD) {
                                    // print(jsonEncode(lD));

                                    _bluetooth.printCustom(
                                      '${i + 1}. ${lD.name}: ${NumberFormat.decimalPattern().format(lD.price ?? 0)}',
                                      1,
                                      0,
                                    );
                                    _bluetooth.printNewLine();
                                  },
                                );

                                final totalPrice = laundryDetails.fold(
                                  0.0,
                                  (acc, lD) =>
                                      (acc as double) + (lD.price ?? 0),
                                );

                                _bluetooth.printCustom(
                                  "Status: ${l?.isPaid == 1 ? 'PAID' : 'UNPAID'}",
                                  2,
                                  0,
                                );

                                _bluetooth.printNewLine();

                                final customerRecords =
                                    (await Hive.openBox<LaundryRecord>(
                                  laundryRecordsHiveTable,
                                ))
                                        .values
                                        .where(
                                          (l) =>
                                              l.customerUuid == c?.uuid &&
                                              l.deleted == null,
                                        );
                                final totalCustomerRecordPrices =
                                    (await Future.wait(
                                  customerRecords.map(
                                    (l) async => (await Hive.openBox<
                                            LaundryRecordDetail>(
                                      laundryRecordDetailsHiveTable,
                                    ))
                                        .values
                                        .where(
                                          (lD) =>
                                              lD.laundryRecordUuid == l.uuid,
                                        ),
                                  ),
                                ))
                                        .expand((lD) => lD)
                                        .fold(
                                          0.0,
                                          (acc, lD) =>
                                              (acc as double) + (lD.price ?? 0),
                                        );

                                final totalCustomerPaid = customerRecords.fold(
                                  0.0,
                                  (acc, l) =>
                                      (acc as double) + (l?.paidValue ?? 0.0),
                                );

                                final customerBalance = totalCustomerPaid -
                                    totalCustomerRecordPrices;

                                _bluetooth.printCustom(
                                  'Total: ${NumberFormat.decimalPattern().format(
                                    totalPrice,
                                  )}',
                                  3,
                                  0,
                                );

                                _bluetooth.printNewLine();

                                if (l?.isPaid == 1) {
                                  _bluetooth.printCustom(
                                    'Paid: ${NumberFormat.decimalPattern().format(
                                      l?.paidValue ?? 0.0,
                                    )}',
                                    3,
                                    0,
                                  );

                                  _bluetooth.printNewLine();
                                }

                                _bluetooth.printCustom(
                                  'Cst. Balance: ${NumberFormat.decimalPattern().format(
                                    customerBalance,
                                  )}',
                                  3,
                                  0,
                                );

                                // _bluetooth.printNewLine();

                                // if (await File(
                                //         '${(await getApplicationDocumentsDirectory()).path}/qr.png')
                                //     .exists()) {
                                //   _bluetooth.printImage(
                                //     '${(await getApplicationDocumentsDirectory()).path}/qr.png',
                                //   );
                                // } else {
                                //   print(
                                //     '[${(await getApplicationDocumentsDirectory()).path}/qr.png] does not exist',
                                //   );
                                // }

                                // _bluetooth.printQRcode(
                                //   '00020101021126570011ID.DANA.WWW011893600915312913148402091291314840303UMI51440014ID.CO.QRIS.WWW0215ID10210681486540303UMI5204721053033605802ID5913Cinta Laundry6014Kab. Tangerang6105155606304CC53',
                                //   300,
                                //   300,
                                //   1,
                                // );

                                // _bluetooth.printNewLine();
                                // _bluetooth.printNewLine();
                                // _bluetooth.printNewLine();
                              }
                            } catch (e) {
                              print(
                                '[Bluetooth printing error] $e',
                              );
                            } finally {
                              await _bluetooth.disconnect();
                            }
                          },
                        ),
                      )
                    ],
                  );
                }) ??
                []
          ],
        ),
      ),
    );
  }
}
