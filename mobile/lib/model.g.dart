// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) {
  return BaseModel(
    uuid: json['uuid'] as String?,
    createdAt: json['createdAt'] as int?,
    updatedAt: json['updatedAt'] as int?,
  )..deletedAt = json['deletedAt'] as int?;
}

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?
    ..deletedAt = json['deletedAt'] as int?;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

LaundryRecord _$LaundryRecordFromJson(Map<String, dynamic> json) {
  return LaundryRecord(
    customerUuid: json['customerUuid'] as String?,
    laundryDocumentUuid: json['laundryDocumentUuid'] as String?,
    weight: (json['weight'] as num?)?.toDouble(),
    price: json['price'] as int?,
    type: json['type'] as int?,
    start: json['start'] as int?,
    done: json['done'] as int?,
    received: json['received'] as int?,
    wash: json['wash'] as bool?,
    dry: json['dry'] as bool?,
    iron: json['iron'] as bool?,
    note: json['note'] as String?,
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?
    ..deletedAt = json['deletedAt'] as int?
    ..ePayId = json['ePayId'] as String?;
}

Map<String, dynamic> _$LaundryRecordToJson(LaundryRecord instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'customerUuid': instance.customerUuid,
      'laundryDocumentUuid': instance.laundryDocumentUuid,
      'weight': instance.weight,
      'price': instance.price,
      'type': instance.type,
      'start': instance.start,
      'done': instance.done,
      'received': instance.received,
      'ePayId': instance.ePayId,
      'wash': instance.wash,
      'dry': instance.dry,
      'iron': instance.iron,
      'note': instance.note,
    };

LaundryDocument _$LaundryDocumentFromJson(Map<String, dynamic> json) {
  return LaundryDocument(
    name: json['name'] as String?,
    date: json['date'] as int?,
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?
    ..deletedAt = json['deletedAt'] as int?;
}

Map<String, dynamic> _$LaundryDocumentToJson(LaundryDocument instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'name': instance.name,
      'date': instance.date,
    };

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    name: json['name'] as String?,
    date: json['date'] as int?,
    amount: (json['amount'] as num?)?.toDouble(),
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?
    ..deletedAt = json['deletedAt'] as int?;
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'name': instance.name,
      'date': instance.date,
      'amount': instance.amount,
    };

BackupRecord _$BackupRecordFromJson(Map<String, dynamic> json) {
  return BackupRecord(
    id: json['id'] as int?,
    email: json['email'] as String?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    customers: json['customers'] as String?,
    laundryDocuments: json['laundryDocuments'] as String?,
    laundryRecords: json['laundryRecords'] as String?,
    expenses: json['expenses'] as String?,
  );
}

Map<String, dynamic> _$BackupRecordToJson(BackupRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'customers': instance.customers,
      'laundryDocuments': instance.laundryDocuments,
      'laundryRecords': instance.laundryRecords,
      'expenses': instance.expenses,
    };
