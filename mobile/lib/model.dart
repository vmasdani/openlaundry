import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

class BaseModel {
  @HiveField(255)
  String? uuid;

  @HiveField(254)
  int? created;

  @HiveField(253)
  int? updated;

  @HiveField(252)
  int? deleted;
}

@JsonSerializable()
@HiveType(typeId: 0)
class Customer extends HiveObject with BaseModel {
  Customer();

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? phone;

  @HiveField(2)
  String? address;

  static Customer create() => Customer();
  static Customer fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class LaundryRecord extends HiveObject with BaseModel {
  LaundryRecord();

  @HiveField(0)
  String? customerUuid;

  @HiveField(1)
  String? laundryDocumentUuid;

  @HiveField(2)
  double? weight;

  @HiveField(3)
  double? price;

  @HiveField(4)
  int? type; // 0 = cash, 1 = epay

  @HiveField(5)
  int? start;

  @HiveField(6)
  int? done;

  @HiveField(7)
  int? received;

  @HiveField(8)
  String? ePayId;

  @HiveField(9)
  int? wash;

  @HiveField(10)
  int? dry;

  @HiveField(11)
  int? iron;

  @HiveField(12)
  String? note;

  @HiveField(13)
  double? paidValue;

  @HiveField(14)
  int? date;

  @HiveField(15)
  int? isPaid;

  static LaundryRecord create() => LaundryRecord();
  static LaundryRecord fromJson(Map<String, dynamic> json) =>
      _$LaundryRecordFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryRecordToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 2)
class LaundryDocument extends HiveObject with BaseModel {
  LaundryDocument();

  @HiveField(0)
  String? name;

  @HiveField(1)
  int? date;

  static LaundryDocument create() => LaundryDocument();
  static LaundryDocument fromJson(Map<String, dynamic> json) =>
      _$LaundryDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryDocumentToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 5)
class LaundryRecordDetail extends HiveObject with BaseModel {
  LaundryRecordDetail();

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? laundryRecordUuid;

  @HiveField(2)
  double? price;

  static LaundryRecordDetail create() => LaundryRecordDetail();
  static LaundryRecordDetail fromJson(Map<String, dynamic> json) =>
      _$LaundryRecordDetailFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryRecordDetailToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 4)
class Expense extends HiveObject with BaseModel {
  Expense();

  @HiveField(0)
  String? name;

  @HiveField(1)
  int? date;

  @HiveField(2)
  double? amount;

  static Expense create() => Expense();
  static Expense fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 3)
class BackupRecord extends HiveObject {
  BackupRecord();

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? created;

  @HiveField(3)
  String? updated;

  @HiveField(4)
  String? customers;

  @HiveField(5)
  String? laundryDocuments;

  @HiveField(6)
  String? laundryRecords;

  @HiveField(7)
  String? expenses;

  static BackupRecord create() => BackupRecord();
  static BackupRecord fromJson(Map<String, dynamic> json) =>
      _$BackupRecordFromJson(json);
  Map<String, dynamic> toJson() => _$BackupRecordToJson(this);
}
