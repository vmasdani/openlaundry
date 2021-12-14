// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 0;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer()
      ..name = fields[0] as String?
      ..phone = fields[1] as String?
      ..address = fields[2] as String?
      ..uuid = fields[255] as String?
      ..created = fields[254] as int?
      ..updated = fields[253] as int?
      ..deleted = fields[252] as int?;
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(255)
      ..write(obj.uuid)
      ..writeByte(254)
      ..write(obj.created)
      ..writeByte(253)
      ..write(obj.updated)
      ..writeByte(252)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LaundryRecordAdapter extends TypeAdapter<LaundryRecord> {
  @override
  final int typeId = 1;

  @override
  LaundryRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaundryRecord()
      ..customerUuid = fields[0] as String?
      ..laundryDocumentUuid = fields[1] as String?
      ..weight = fields[2] as double?
      ..price = fields[3] as double?
      ..type = fields[4] as int?
      ..start = fields[5] as int?
      ..done = fields[6] as int?
      ..received = fields[7] as int?
      ..ePayId = fields[8] as String?
      ..wash = fields[9] as int?
      ..dry = fields[10] as int?
      ..iron = fields[11] as int?
      ..note = fields[12] as String?
      ..paidValue = fields[13] as double?
      ..date = fields[14] as int?
      ..isPaid = fields[15] as int?
      ..uuid = fields[255] as String?
      ..created = fields[254] as int?
      ..updated = fields[253] as int?
      ..deleted = fields[252] as int?;
  }

  @override
  void write(BinaryWriter writer, LaundryRecord obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.customerUuid)
      ..writeByte(1)
      ..write(obj.laundryDocumentUuid)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.start)
      ..writeByte(6)
      ..write(obj.done)
      ..writeByte(7)
      ..write(obj.received)
      ..writeByte(8)
      ..write(obj.ePayId)
      ..writeByte(9)
      ..write(obj.wash)
      ..writeByte(10)
      ..write(obj.dry)
      ..writeByte(11)
      ..write(obj.iron)
      ..writeByte(12)
      ..write(obj.note)
      ..writeByte(13)
      ..write(obj.paidValue)
      ..writeByte(14)
      ..write(obj.date)
      ..writeByte(15)
      ..write(obj.isPaid)
      ..writeByte(255)
      ..write(obj.uuid)
      ..writeByte(254)
      ..write(obj.created)
      ..writeByte(253)
      ..write(obj.updated)
      ..writeByte(252)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaundryRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LaundryDocumentAdapter extends TypeAdapter<LaundryDocument> {
  @override
  final int typeId = 2;

  @override
  LaundryDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaundryDocument()
      ..name = fields[0] as String?
      ..date = fields[1] as int?
      ..uuid = fields[255] as String?
      ..created = fields[254] as int?
      ..updated = fields[253] as int?
      ..deleted = fields[252] as int?;
  }

  @override
  void write(BinaryWriter writer, LaundryDocument obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(255)
      ..write(obj.uuid)
      ..writeByte(254)
      ..write(obj.created)
      ..writeByte(253)
      ..write(obj.updated)
      ..writeByte(252)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaundryDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LaundryRecordDetailAdapter extends TypeAdapter<LaundryRecordDetail> {
  @override
  final int typeId = 5;

  @override
  LaundryRecordDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaundryRecordDetail()
      ..name = fields[0] as String?
      ..laundryRecordUuid = fields[1] as String?
      ..price = fields[2] as double?
      ..uuid = fields[255] as String?
      ..created = fields[254] as int?
      ..updated = fields[253] as int?
      ..deleted = fields[252] as int?;
  }

  @override
  void write(BinaryWriter writer, LaundryRecordDetail obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.laundryRecordUuid)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(255)
      ..write(obj.uuid)
      ..writeByte(254)
      ..write(obj.created)
      ..writeByte(253)
      ..write(obj.updated)
      ..writeByte(252)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaundryRecordDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 4;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense()
      ..name = fields[0] as String?
      ..date = fields[1] as int?
      ..amount = fields[2] as double?
      ..uuid = fields[255] as String?
      ..created = fields[254] as int?
      ..updated = fields[253] as int?
      ..deleted = fields[252] as int?;
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(255)
      ..write(obj.uuid)
      ..writeByte(254)
      ..write(obj.created)
      ..writeByte(253)
      ..write(obj.updated)
      ..writeByte(252)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BackupRecordAdapter extends TypeAdapter<BackupRecord> {
  @override
  final int typeId = 3;

  @override
  BackupRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BackupRecord()
      ..id = fields[0] as int?
      ..email = fields[1] as String?
      ..created = fields[2] as String?
      ..updated = fields[3] as String?
      ..customers = fields[4] as String?
      ..laundryDocuments = fields[5] as String?
      ..laundryRecords = fields[6] as String?
      ..expenses = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, BackupRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.created)
      ..writeByte(3)
      ..write(obj.updated)
      ..writeByte(4)
      ..write(obj.customers)
      ..writeByte(5)
      ..write(obj.laundryDocuments)
      ..writeByte(6)
      ..write(obj.laundryRecords)
      ..writeByte(7)
      ..write(obj.expenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer()
  ..uuid = json['uuid'] as String?
  ..created = json['created'] as int?
  ..updated = json['updated'] as int?
  ..deleted = json['deleted'] as int?
  ..name = json['name'] as String?
  ..phone = json['phone'] as String?
  ..address = json['address'] as String?;

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'created': instance.created,
      'updated': instance.updated,
      'deleted': instance.deleted,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

LaundryRecord _$LaundryRecordFromJson(Map<String, dynamic> json) =>
    LaundryRecord()
      ..uuid = json['uuid'] as String?
      ..created = json['created'] as int?
      ..updated = json['updated'] as int?
      ..deleted = json['deleted'] as int?
      ..customerUuid = json['customerUuid'] as String?
      ..laundryDocumentUuid = json['laundryDocumentUuid'] as String?
      ..weight = (json['weight'] as num?)?.toDouble()
      ..price = (json['price'] as num?)?.toDouble()
      ..type = json['type'] as int?
      ..start = json['start'] as int?
      ..done = json['done'] as int?
      ..received = json['received'] as int?
      ..ePayId = json['ePayId'] as String?
      ..wash = json['wash'] as int?
      ..dry = json['dry'] as int?
      ..iron = json['iron'] as int?
      ..note = json['note'] as String?
      ..paidValue = (json['paidValue'] as num?)?.toDouble()
      ..date = json['date'] as int?
      ..isPaid = json['isPaid'] as int?;

Map<String, dynamic> _$LaundryRecordToJson(LaundryRecord instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'created': instance.created,
      'updated': instance.updated,
      'deleted': instance.deleted,
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
      'paidValue': instance.paidValue,
      'date': instance.date,
      'isPaid': instance.isPaid,
    };

LaundryDocument _$LaundryDocumentFromJson(Map<String, dynamic> json) =>
    LaundryDocument()
      ..uuid = json['uuid'] as String?
      ..created = json['created'] as int?
      ..updated = json['updated'] as int?
      ..deleted = json['deleted'] as int?
      ..name = json['name'] as String?
      ..date = json['date'] as int?;

Map<String, dynamic> _$LaundryDocumentToJson(LaundryDocument instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'created': instance.created,
      'updated': instance.updated,
      'deleted': instance.deleted,
      'name': instance.name,
      'date': instance.date,
    };

LaundryRecordDetail _$LaundryRecordDetailFromJson(Map<String, dynamic> json) =>
    LaundryRecordDetail()
      ..uuid = json['uuid'] as String?
      ..created = json['created'] as int?
      ..updated = json['updated'] as int?
      ..deleted = json['deleted'] as int?
      ..name = json['name'] as String?
      ..laundryRecordUuid = json['laundryRecordUuid'] as String?
      ..price = (json['price'] as num?)?.toDouble();

Map<String, dynamic> _$LaundryRecordDetailToJson(
        LaundryRecordDetail instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'created': instance.created,
      'updated': instance.updated,
      'deleted': instance.deleted,
      'name': instance.name,
      'laundryRecordUuid': instance.laundryRecordUuid,
      'price': instance.price,
    };

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense()
  ..uuid = json['uuid'] as String?
  ..created = json['created'] as int?
  ..updated = json['updated'] as int?
  ..deleted = json['deleted'] as int?
  ..name = json['name'] as String?
  ..date = json['date'] as int?
  ..amount = (json['amount'] as num?)?.toDouble();

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'created': instance.created,
      'updated': instance.updated,
      'deleted': instance.deleted,
      'name': instance.name,
      'date': instance.date,
      'amount': instance.amount,
    };

BackupRecord _$BackupRecordFromJson(Map<String, dynamic> json) => BackupRecord()
  ..id = json['id'] as int?
  ..email = json['email'] as String?
  ..created = json['created'] as String?
  ..updated = json['updated'] as String?
  ..customers = json['customers'] as String?
  ..laundryDocuments = json['laundryDocuments'] as String?
  ..laundryRecords = json['laundryRecords'] as String?
  ..expenses = json['expenses'] as String?;

Map<String, dynamic> _$BackupRecordToJson(BackupRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'created': instance.created,
      'updated': instance.updated,
      'customers': instance.customers,
      'laundryDocuments': instance.laundryDocuments,
      'laundryRecords': instance.laundryRecords,
      'expenses': instance.expenses,
    };

Storage _$StorageFromJson(Map<String, dynamic> json) => Storage()
  ..key = json['key'] as String?
  ..storageRecords = (json['storage_records'] as List<dynamic>?)
      ?.map((e) => StorageRecord.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'key': instance.key,
      'storage_records': instance.storageRecords,
    };

StorageRecord _$StorageRecordFromJson(Map<String, dynamic> json) =>
    StorageRecord()
      ..uuid = json['uuid'] as String?
      ..created = json['created'] as int?
      ..updated = json['updated'] as int?
      ..deleted = json['deleted'] as int?
      ..value = json['value'] as String?;

Map<String, dynamic> _$StorageRecordToJson(StorageRecord instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'created': instance.created,
      'updated': instance.updated,
      'deleted': instance.deleted,
      'value': instance.value,
    };
