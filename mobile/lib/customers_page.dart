import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/constants.dart';
import 'package:openlaundry/customer_edit_page.dart';
import 'package:openlaundry/customers_add_page.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  var _customerSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final c = Customer()
            ..uuid = Uuid().v4()
            ..created = DateTime.now().millisecondsSinceEpoch
            ..updated = DateTime.now().millisecondsSinceEpoch;

          (await Hive.openBox<Customer>(customersHiveTable)).add(c);

          await c.save();

          setState(() {});
        },
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController()
                        ..text = _customerSearch,
                      onChanged: (v) {
                        _customerSearch = v;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Search by name, phone, address',
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () async {
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Consumer<AppState>(builder: (ctx, state, child) {
              return Container(
                child: FutureBuilder(
                  future: Hive.openBox<Customer>(customersHiveTable),
                  builder: (ctx, AsyncSnapshot<Box<Customer>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        child: Column(
                          children: snapshot.data?.values
                                  .toList()
                                  .reversed
                                  ?.where(
                                    (c) =>
                                        '${c?.name}${c?.address}${c?.phone}'
                                            .toLowerCase()
                                            ?.contains(
                                              _customerSearch?.toLowerCase() ??
                                                  '',
                                            ) ??
                                        false,
                                  )
                                  .map(
                                (c) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  // Container(
                                                  //   child: Text(
                                                  //     c?.uuid ?? 'No uuid',
                                                  //   ),
                                                  // ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      c?.name != null &&
                                                              c?.name != ''
                                                          ? (c?.name ?? '')
                                                          : 'No name',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      c?.address != null &&
                                                              c?.address != ''
                                                          ? (c?.address ?? '')
                                                          : 'No address',
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      c?.phone != null &&
                                                              c?.phone != ''
                                                          ? (c?.phone ?? '')
                                                          : 'No phone',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        CustomerEditPage(
                                                      uuid: c?.uuid,
                                                      onSave: () {
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                              ),
                                              color: Colors.green,
                                            )
                                          ],
                                        ),
                                        Container(
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ).toList() ??
                              [],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
