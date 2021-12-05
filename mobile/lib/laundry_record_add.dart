import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/customer_select.dart';
import 'package:openlaundry/helpers.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class LaundryRecordAdd extends StatefulWidget {
  final LaundryRecord? laundryRecord;
  Function(LaundryRecord laundryRecord)? onSave;

  LaundryRecordAdd({this.laundryRecord, this.onSave});

  @override
  _LaundryRecordAddState createState() => _LaundryRecordAddState();
}

class _LaundryRecordAddState extends State<LaundryRecordAdd> {
  LaundryRecord? _laundryRecord;
  final _noteController = TextEditingController();

  @override
  void initState() {
    _laundryRecord =
        LaundryRecord.fromJson(jsonDecode(jsonEncode(widget.laundryRecord)));

    if (_laundryRecord?.price == null || _laundryRecord?.price == 0) {
      _laundryRecord?.price = 10000;
    }

    _noteController.text = _laundryRecord?.note ?? '';

    if (_laundryRecord?.type == null) {
      _laundryRecord?.type = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
