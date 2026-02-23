import 'package:drift/drift.dart';
import 'cats_table.dart';

class ExcretionRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get catId => integer().references(Cats, #id)();
  TextColumn get excretionType => text()();
  IntColumn get bristolScale => integer().nullable()();
  IntColumn get urineAmount => integer().nullable()();
  BoolColumn get hasBlood =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hasAnomaly =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
