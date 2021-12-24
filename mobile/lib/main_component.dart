import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/CalculatorPage.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/backup_page.dart';
import 'package:openlaundry/customers_page.dart';
import 'package:openlaundry/dashboard_page.dart';
import 'package:openlaundry/document_editor.dart';
import 'package:openlaundry/model.dart';
import 'package:openlaundry/settingspage.dart';
import 'package:provider/provider.dart';

class MainComponent extends StatefulWidget {
  @override
  _MainComponentState createState() => _MainComponentState();
}

class _MainComponentState extends State<MainComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (ctx, state, child) {
      return Scaffold(
        appBar: AppBar(title: Text(state.title ?? '')),
        body: Center(
          child: Consumer<AppState>(
            builder: (ctx, state, child) {
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

                case 3:
                  {
                    return SettingsPage();
                  }

                default:
                  return Container();
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Customers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.backup),
              label: 'Backup',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: state.selectedPage,
          selectedItemColor: Colors.purple,
          onTap: (v) async {
            switch (v) {
              case 0:
                state.setSelectedPage(0);
                state.setTitle('Home');
                return;

              case 1:
                state.setSelectedPage(1);
                state.setTitle('Customers');
                return;

              case 2:
                state.setSelectedPage(2);
                state.setTitle('Backup');
                return;

              case 3:
                state.setSelectedPage(3);
                state.setTitle('Settings');
                return;

              default:
                print('Nothing selected');
                return;
            }
          },
        ),
      );
    });
  }
}
