import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/constants.dart';
import 'package:openlaundry/model.dart';

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
                                  (l) => l?.uuid == widget?.uuid,
                                );

                            final c = (await Hive.openBox<Customer>(
                              customersHiveTable,
                            ))
                                .values
                                ?.firstWhereOrNull(
                                  (c) => c?.uuid == l?.customerUuid,
                                );

                            try {
                              await _bluetooth?.connect(d);
                            } catch (e) {
                              print(
                                  'Bluetooth connect error, maybe already connected. ');
                            }

                            final connStatus = await _bluetooth.isConnected;

                            if (connStatus != null && connStatus) {
                              _bluetooth.printCustom("Cinta Laundry", 3, 1);

                              _bluetooth.printCustom(
                                  '${DateFormat.yMMMd().add_jms().format(
                                        DateTime.now().toLocal(),
                                      )} ${DateTime.now().timeZoneName}',
                                  1,
                                  1);
                              _bluetooth.printNewLine();

                              _bluetooth.printCustom(
                                  "Customer: ${c?.name}", 1, 0);
                              _bluetooth.printCustom(
                                  "Address: ${c?.address}", 1, 0);
                              _bluetooth.printCustom(
                                  "Weight: ${l?.weight?.toStringAsFixed(2)} kg",
                                  1,
                                  0);

                              _bluetooth.printCustom(
                                  "Price: ${NumberFormat.decimalPattern()?.format(
                                    l?.price ?? 0,
                                  )}",
                                  1,
                                  0);

                              _bluetooth.printCustom(
                                  "Status: ${l?.isPaid == 1 ? 'PAID' : 'UNPAID'}",
                                  1,
                                  0);

                              if (l?.isPaid == 1) {
                                _bluetooth.printCustom(
                                    "Paid value: ${NumberFormat.decimalPattern()?.format(
                                      l?.paidValue ?? 0,
                                    )}",
                                    1,
                                    0);

                                if ((l?.paidValue ?? 0) > (l?.price ?? 0)) {
                                  _bluetooth.printCustom(
                                      "Deposit: ${NumberFormat.decimalPattern()?.format(
                                        (l?.paidValue ?? 0) - (l?.price ?? 0),
                                      )}",
                                      1,
                                      0);
                                } else {
                                  _bluetooth.printCustom(
                                      "Change: ${NumberFormat.decimalPattern()?.format(
                                        (l?.price ?? 0) - (l?.paidValue ?? 0),
                                      )}",
                                      1,
                                      0);
                                }
                              }

                              _bluetooth.printNewLine();

                              _bluetooth?.printCustom('DRY CLEAN + IRON', 1, 0);

                              _bluetooth.printNewLine();
                            }

                            await _bluetooth.disconnect();
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
