import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:openlaundry/model.dart';

final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String getMonth(DateTime date) {
  switch (date.month) {
    case DateTime.january:
      return 'Jan';
    case DateTime.february:
      return 'Feb';
    case DateTime.march:
      return 'Mar';
    case DateTime.april:
      return 'Apr';
    case DateTime.may:
      return 'May';
    case DateTime.june:
      return 'Jun';
    case DateTime.july:
      return 'Jul';
    case DateTime.august:
      return 'Aug';
    case DateTime.september:
      return 'Sep';
    case DateTime.october:
      return 'Oct';
    case DateTime.november:
      return 'Nov';
    case DateTime.december:
      return 'Dec';
    default:
      return 'None';
  }
}

String makeReadableDateTimeString(DateTime date) {
  return '${days[date.weekday]} ${date.day} ${getMonth(date)} ${date.year}, ${date.hour}:${date.minute}:${date.second} ${date.timeZoneName}';
}

String makeReadableDateString(DateTime date) {
  return '${days[date.weekday]} ${date.day} ${getMonth(date)} ${date.year}';
}

String makeDateString(DateTime date) {
  String m = (date.month) < 10 ? '0${date.month}' : '${date.month}';
  String d = (date.day) < 10 ? '0${date.day}' : '${date.day}';

  return '${date.year}-${m}-${d}';
}

Iterable<T> filterNotHidden<T extends BaseModel>(Iterable<T> list) =>
    list.where(
      (e) => e.deleted == null,
    );

Future<Iterable<T>> fetchHiveListNotHidden<T extends BaseModel>(
        String tableName) async =>
    (await Hive.openBox<T>(tableName)).values.where(
          (e) => e.deleted == null,
        );

Widget hiveListNotHidden<T extends BaseModel>({
  required BuildContext context,
  required String tableName,
  required Widget Function(Iterable<T> list) mapperWidget,
  required Widget Function() waitWidget,
}) =>
    FutureBuilder(
        future: Hive.openBox<T>(tableName),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.done) {
            return mapperWidget(
              filterNotHidden(
                (snapshot.data as Box<T>).values,
              ),
            );
          } else {
            return waitWidget();
          }
        });
