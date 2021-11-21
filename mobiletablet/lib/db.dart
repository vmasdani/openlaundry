import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:openlaundrymobiletablet/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

part 'db.g.dart';

@JsonSerializable()
class Db {
  List<LaundryDocument>? laundryDocuments;
  List<LaundryRecord>? laundryRecords;
  List<Customer>? customers;
  List<Expense>? expenses;

  Db();

  static Future<Db> getInstance() async => Db.fromJson(jsonDecode(
      (await SharedPreferences.getInstance()).getString("data") ?? '{}'));

  Future<List<T>?> table<T extends BaseModel>(
    List<T>? Function(Db db) finder,
  ) async =>
      finder(await Db.getInstance());

  Future<T?> findById<T extends BaseModel>(
    String? uuid,
    List<T>? Function(Db db) finder,
  ) async =>
      finder(await Db.getInstance())?.firstWhereOrNull((e) => e.uuid == uuid);

  static Future<String?> deleteById<T extends BaseModel>(
    String? uuid,
    List<T>? Function(Db db) finder,
  ) async {
    final db = await Db.getInstance();
    return null;
  }

  static Future<T?> update<T extends BaseModel>(
    T item,
    List<T>? Function(Db db) finder,
  ) async {
    final db = await Db.getInstance();
    var table = finder(db);

    item.createdAt ??= DateTime.now().millisecondsSinceEpoch;
    item.updatedAt = DateTime.now().millisecondsSinceEpoch;

    var foundItem = table?.firstWhereOrNull((e) => e.uuid == item.uuid);
    T? itemToReturn;

    if (foundItem != null) {
      if (item.updatedAt != null &&
          foundItem.updatedAt != null &&
          item.updatedAt! > foundItem.updatedAt!) {
        table = table?.map((e) => e.uuid == item.uuid ? item : e).toList();

        itemToReturn = item;
      } else {
        itemToReturn = foundItem;
      }
    } else {
      table?.add(item);

      itemToReturn = item;
    }

    (await SharedPreferences.getInstance()).setString("data", jsonEncode(db));

    return itemToReturn;
  }

  static Db fromJson(Map<String, dynamic> json) => _$DbFromJson(json);
  Map<String, dynamic> toJson() => _$DbToJson(this);
}
