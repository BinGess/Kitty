import 'package:drift/drift.dart';
import 'cats_table.dart';

class DietRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get catId => integer().references(Cats, #id)();
  TextColumn get brandTag => text().nullable()();
  RealColumn get amountGrams => real()();
  TextColumn get foodType => text()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
