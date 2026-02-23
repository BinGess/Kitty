import 'package:drift/drift.dart';
import 'cats_table.dart';

class WeightRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get catId => integer().references(Cats, #id)();
  RealColumn get weightKg => real()();
  TextColumn get moodAnnotation => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
