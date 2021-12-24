import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  Directory? _appDir = null;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    final dir = (await getApplicationDocumentsDirectory());
    setState(() {
      _appDir = dir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Settings'),
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
            MaterialButton(
              onPressed: () async {
                print(
                  '[QR CONTENTS] ${await File(
                    '${(await getApplicationDocumentsDirectory()).path}/qr.png',
                  ).path}',
                );
                print(
                  (await File(
                    '${(await getApplicationDocumentsDirectory()).path}/qr.png',
                  ).exists()),
                );

                final f = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (f != null) {
                  print(
                    '[Decoding image...]',
                  );
                  final decodedImage = IMG.decodeImage(
                    await File(
                      f?.path ?? '',
                    ).readAsBytes(),
                  );
                  print(
                    '[Image decoded] bytes ${decodedImage?.getBytes().length}',
                  );

                  if (decodedImage != null) {
                    final resizedImg = IMG.copyResize(
                      decodedImage,
                      width: 300,
                      height: 300,
                    );

                    // print(
                    //   '[img bytes] ${resizedImg.getBytes().length}',
                    // );

                    await File(
                      '${(await getApplicationDocumentsDirectory()).path}/qr.png',
                    ).writeAsBytes(
                      IMG.encodePng(
                        resizedImg,
                      ),
                    );

                    setState(() {});
                  }
                }
              },
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                  Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: _appDir != null
                  ? FutureBuilder(
                      future: File('${_appDir?.path}/qr.png').exists(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            child: Image(
                              image: FileImage(
                                File(
                                  '${_appDir?.path}/qr.png',
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            child: Text(
                              'Loding...',
                            ),
                          );
                        }
                      })
                  : Container(child: Text('No image found.')),
            )
          ],
        ),
      ),
    );
  }
}
