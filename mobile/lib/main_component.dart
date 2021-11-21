import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/backup_page.dart';
import 'package:openlaundry/customers_page.dart';
import 'package:openlaundry/dashboard_page.dart';
import 'package:openlaundry/document_editor.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';

class MainComponent extends StatefulWidget {
  @override
  _MainComponentState createState() => _MainComponentState();
}

class _MainComponentState extends State<MainComponent> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.purple),
                child: Text(
                  'OpenLaundry Mobile App',
                  style: TextStyle(color: Colors.white),
                )),
            Consumer<AppState>(
              builder: (ctx, state, child) {
                return ListTile(
                  title: TextButton(
                      onPressed: () {
                        state.setTitle('Dashboard');
                        state.setSelectedPage(0);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [Icon(Icons.dashboard), Text('Dashboard')],
                      )),
                );
              },
            ),
            Consumer<AppState>(
              builder: (ctx, state, child) {
                return ListTile(
                  title: TextButton(
                      onPressed: () {
                        state.setTitle('Customers');
                        state.setSelectedPage(1);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [Icon(Icons.group), Text('Customers')],
                      )),
                );
              },
            ),
            Consumer<AppState>(
              builder: (ctx, state, child) {
                return ListTile(
                  title: TextButton(
                      onPressed: () {
                        state.setTitle('Backup');
                        state.setSelectedPage(2);
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [Icon(Icons.backup), Text('Backup')],
                      )),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Consumer<AppState>(builder: (ctx, state, child) {
          return Text(state.title ?? '');
        }),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Consumer<AppState>(builder: (ctx, state, child) {
        switch (state.selectedPage) {
          case 0:
            {
              return DashboardPage();
            }

          case 1:
            {
              return CustomersPage();
            }

          case 2:
            {
              return BackupPage();
            }

          default:
            return Container();
        }
      })),
    );
  }
}
