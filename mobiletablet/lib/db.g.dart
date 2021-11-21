// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Db _$DbFromJson(Map<String, dynamic> json) => Db()
  ..laundryDocuments = (json['laundryDocuments'] as List<dynamic>?)
      ?.map((e) => LaundryDocument.fromJson(e as Map<String, dynamic>))
      .toList()
  ..laundryRecords = (json['laundryRecords'] as List<dynamic>?)
      ?.map((e) => LaundryRecord.fromJson(e as Map<String, dynamic>))
      .toList()
  ..customers = (json['customers'] as List<dynamic>?)
      ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
      .toList()
  ..expenses = (json['expenses'] as List<dynamic>?)
      ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$DbToJson(Db instance) => <String, dynamic>{
      'laundryDocuments': instance.laundryDocuments,
      'laundryRecords': instance.laundryRecords,
      'customers': instance.customers,
      'expenses': instance.expenses,
    };
