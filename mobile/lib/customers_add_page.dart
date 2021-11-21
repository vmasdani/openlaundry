import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomersAddPage extends StatefulWidget {
  final Customer? customer;

  CustomersAddPage({this.customer});

  @override
  _CustomersAddPageState createState() => _CustomersAddPageState();
}

class _CustomersAddPageState extends State<CustomersAddPage> {
  Customer? _customer;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    _customer = Customer.fromJson(jsonDecode(jsonEncode(widget.customer)));

    _nameController.text = _customer?.name ?? '';
    _addressController.text = _customer?.address ?? '';

    if (_customer?.phone == null || _customer?.phone == '') {
      _customer?.phone = '62';
      _phoneController.text = '62';
    } else {
      _phoneController.text = _customer?.phone ?? '';
    }

    super.initState();
  }

  Future<void> _save() async {
    final state = context.read<AppState>();

    if (_customer != null) {
      final savedCustomerId = state.saveGeneric(_customer!);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Editor'),
        actions: [
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await _save();
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text('Name')),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _customer?.name = val;
                              });
                            },
                            controller: _nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: 'Name'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text('Phone')),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _customer?.phone = val;
                              });
                            },
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: 'Phone'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: TextButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.message,
                            color: Colors.green,
                          ),
                          Text('Open WhatsApp',
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                      onPressed: () async {
                        await canLaunch(
                                'whatsapp://send?phone=${_customer?.phone ?? ''}')
                            ? launch(
                                'whatsapp://send?phone=${_customer?.phone ?? ''}')
                            : showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text('Failed to open WhatsApp'),
                                      content: Text(
                                          'Invalid number or system error'),
                                    ));
                      },
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text('Address')),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _customer?.address = val;
                              });
                            },
                            controller: _addressController,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: 'Address'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  ...(_customer?.uuid != null
                      ? [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Laundries',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Consumer<AppState>(
                            builder: (ctx, state, child) {
                              return Column(
                                children: state.laundryRecords
                                        ?.where((laundryRecord) =>
                                            laundryRecord.customerUuid ==
                                                _customer?.uuid &&
                                            laundryRecord.deletedAt == null)
                                        .map((laundryRecord) => Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '${NumberFormat.simpleCurrency(locale: 'id-ID').format(laundryRecord.price ?? 0)}'),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        '${laundryRecord.weight ?? 0} kg'),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                Text('Start')),
                                                        Expanded(
                                                          child: Text(laundryRecord
                                                                      .start !=
                                                                  null
                                                              ? DateFormat
                                                                      .yMMMEd()
                                                                  .add_jm()
                                                                  .format(DateTime
                                                                      .fromMillisecondsSinceEpoch(
                                                                          laundryRecord.start ??
                                                                              0))
                                                              : ''),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                Text('Done')),
                                                        Expanded(
                                                          child: Text(laundryRecord
                                                                      .done !=
                                                                  null
                                                              ? DateFormat
                                                                      .yMMMEd()
                                                                  .add_jm()
                                                                  .format(DateTime
                                                                      .fromMillisecondsSinceEpoch(
                                                                          laundryRecord.done ??
                                                                              0))
                                                              : ''),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                'Received')),
                                                        Expanded(
                                                          child: Text(laundryRecord
                                                                      .received !=
                                                                  null
                                                              ? DateFormat
                                                                      .yMMMEd()
                                                                  .add_jm()
                                                                  .format(DateTime
                                                                      .fromMillisecondsSinceEpoch(
                                                                          laundryRecord.received ??
                                                                              0))
                                                              : ''),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            ))
                                        .toList() ??
                                    [],
                              );
                            },
                          )
                        ]
                      : []),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
