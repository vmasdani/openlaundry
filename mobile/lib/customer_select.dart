import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';

class CustomerSelect extends StatefulWidget {
  Function(Customer customer)? onSelect;

  CustomerSelect({this.onSelect});

  @override
  _CustomerSelectState createState() => _CustomerSelectState();
}

class _CustomerSelectState extends State<CustomerSelect> {
  final _customerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Customer'),
      ),
      body: Consumer<AppState>(builder: (ctx, state, child) {
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _customerSearch,
                  onChanged: (v) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: 'Search by name, phone, address'),
                ),
              ),
              Divider(),
              ...List<Customer>.from(
                      state.customers?.reversed ?? Iterable.empty())
                  .where((customer) =>
                      '${customer.name}${customer.phone}${customer.address}'
                          .toLowerCase()
                          .contains(_customerSearch.text.toLowerCase()) &&
                      customer.deletedAt == null)
                  .map((customer) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!(customer);
                        }

                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Card(
                          child: Container(
                            color: Colors.grey[100],
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(customer.name ?? 'No Name'),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(customer.phone ?? 'No Phone'),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(customer.address ?? 'No Address'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider()
                  ],
                );
              }).toList()
            ],
          ),
        );
      }),
    );
  }
}
