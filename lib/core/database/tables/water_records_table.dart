import 'package:drift/drift.dart';
import 'cats_table.dart';

class WaterRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get catId => integer().references(Cats, #id)();
  RealColumn get amountMl => real()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
