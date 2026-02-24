import 'package:drift/drift.dart';

class Cats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get breed => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get sex => text().withDefault(const Constant('unknown'))();
  BoolColumn get isNeutered => boolean().withDefault(const Constant(false))();
  RealColumn get weightGoalMinKg => real().nullable()();
  RealColumn get weightGoalMaxKg => real().nullable()();
  RealColumn get targetWaterMl => real().withDefault(const Constant(200.0))();
  IntColumn get targetMealsPerDay => integer().withDefault(const Constant(3))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
