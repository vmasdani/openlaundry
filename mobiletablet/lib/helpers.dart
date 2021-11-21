import 'package:openlaundrymobiletablet/db.dart';

class Helper {
  Future<void> initApp() async {
    final db = await Db.getInstance();

    final customers = db.table((db) => db.customers);
    final laundryRecords = db.table((db) => db.laundryRecords);
    final laundryDocuments = db.table((db) => db.laundryDocuments);
    final expenses = db.table((db) => db.expenses);
  }
}
