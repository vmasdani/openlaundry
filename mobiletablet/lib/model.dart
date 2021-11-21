import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class BaseModel {
  BaseModel({this.uuid, this.createdAt, this.updatedAt});

  String? uuid;
  int? createdAt;
  int? updatedAt;
  int? deletedAt;

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}

@JsonSerializable()
class Customer extends BaseModel {
  Customer({this.name, this.phone, this.address});

  String? name;
  String? phone;
  String? address;

  static Customer create() => Customer();
  static Customer fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class LaundryRecord extends BaseModel {
  LaundryRecord(
      {this.customerUuid,
      this.laundryDocumentUuid,
      this.weight,
      this.price,
      this.type,
      this.start,
      this.done,
      this.received,
      this.wash,
      this.dry,
      this.iron,
      this.note});

  String? customerUuid;
  String? laundryDocumentUuid;
  double? weight;
  int? price;
  int? type; // 0 = cash, 1 = epay
  int? start;
  int? done;
  int? received;
  String? ePayId;
  bool? wash;
  bool? dry;
  bool? iron;
  String? note;

  static LaundryRecord create() => LaundryRecord();
  static LaundryRecord fromJson(Map<String, dynamic> json) =>
      _$LaundryRecordFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryRecordToJson(this);
}

@JsonSerializable()
class LaundryDocument extends BaseModel {
  LaundryDocument({this.name, this.date});

  String? name;
  int? date;

  static LaundryDocument create() => LaundryDocument();
  static LaundryDocument fromJson(Map<String, dynamic> json) =>
      _$LaundryDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryDocumentToJson(this);
}

@JsonSerializable()
class Expense extends BaseModel {
  Expense({this.name, this.date, this.amount});

  String? name;
  int? date;
  double? amount;

  static Expense create() => Expense();
  static Expense fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

@JsonSerializable()
class BackupRecord {
  BackupRecord(
      {this.id,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.customers,
      this.laundryDocuments,
      this.laundryRecords,
      this.expenses});

  int? id;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? customers;
  String? laundryDocuments;
  String? laundryRecords;
  String? expenses;

  static BackupRecord create() => BackupRecord();
  static BackupRecord fromJson(Map<String, dynamic> json) =>
      _$BackupRecordFromJson(json);
  Map<String, dynamic> toJson() => _$BackupRecordToJson(this);
}
