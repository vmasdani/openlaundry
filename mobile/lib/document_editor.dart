import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:openlaundry/app_state.dart';
import 'package:openlaundry/helpers.dart';
import 'dart:convert';
import 'package:openlaundry/laundry_record_add.dart';
import 'package:openlaundry/model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class DocumentEditor extends StatefulWidget {
  final LaundryDocument? laundryDocument;

  DocumentEditor({this.laundryDocument});

  @override
  _DocumentEditorState createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor> {
  final _documentNameController = TextEditingController();
  LaundryDocument? _laundryDocument;

  @override
  void initState() {
    _laundryDocument = LaundryDocument.fromJson(
        jsonDecode(jsonEncode(widget.laundryDocument)));

    if (_laundryDocument?.uuid == null) {
      setState(() {
        _documentNameController.text =
            'Doc ${makeReadableDateString(DateTime.now())}';
      });
    } else {
      setState(() {
        _documentNameController.text = _laundryDocument?.name ?? '';
      });
    }

    if (_laundryDocument?.date == null) {
      _laundryDocument?.date =
          DateTime.parse(makeDateString(DateTime.now())).millisecondsSinceEpoch;
    }

    super.initState();
  }

  Future<void> _save() async {
    _laundryDocument?.name = _documentNameController.text;

    final state = context.read<AppState>();

    if (_laundryDocument != null) {
      final savedLaundryDocumentId = await state.saveGeneric(_laundryDocument!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
