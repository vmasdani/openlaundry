import 'package:flutter/material.dart';

class GenericSelector<T> extends StatefulWidget {
  const GenericSelector({
    Key? key,
    this.getLabel,
    this.title,
    this.list,
    this.onSelect,
    this.searchCriteria,
  }) : super(key: key);

  final Iterable<T>? list;
  final String Function(T)? getLabel;
  final Function(T)? onSelect;
  final bool Function(T, String)? searchCriteria;

  final String? title;

  @override
  _GenericSelectorState<T> createState() => _GenericSelectorState<T>();
}

class _GenericSelectorState<T> extends State<GenericSelector<T>> {
  var _searchInput = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'Selector',
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        onChanged: (v) {
                          _searchInput = v;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          label: Text(
                            'Search...',
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      print(_searchInput);
                      // print()
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.search,
                    ),
                  )
                ],
              ),
            ),
            ...(widget.list?.where((e) {
                  final res = widget.searchCriteria?.call(
                    e,
                    _searchInput,
                  );

                  if (res != null) {
                    return res;
                  } else {
                    return true;
                  }
                })?.map((e) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      widget.getLabel?.call(e) ?? 'No name',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                widget.onSelect?.call(e);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Select',
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                })?.toList() ??
                [])
          ],
        ),
      ),
    );
  }
}
