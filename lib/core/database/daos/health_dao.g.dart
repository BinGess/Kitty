// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_dao.dart';

// ignore_for_file: type=lint
mixin _$HealthDaoMixin on DatabaseAccessor<AppDatabase> {
  $CatsTable get cats => attachedDatabase.cats;
  $WeightRecordsTable get weightRecords => attachedDatabase.weightRecords;
  $DietRecordsTable get dietRecords => attachedDatabase.dietRecords;
  $WaterRecordsTable get waterRecords => attachedDatabase.waterRecords;
  $ExcretionRecordsTable get excretionRecords =>
      attachedDatabase.excretionRecords;
  HealthDaoManager get managers => HealthDaoManager(this);
}

class HealthDaoManager {
  final _$HealthDaoMixin _db;
  HealthDaoManager(this._db);
  $$CatsTableTableManager get cats =>
      $$CatsTableTableManager(_db.attachedDatabase, _db.cats);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db.attachedDatabase, _db.weightRecords);
  $$DietRecordsTableTableManager get dietRecords =>
      $$DietRecordsTableTableManager(_db.attachedDatabase, _db.dietRecords);
  $$WaterRecordsTableTableManager get waterRecords =>
      $$WaterRecordsTableTableManager(_db.attachedDatabase, _db.waterRecords);
  $$ExcretionRecordsTableTableManager get excretionRecords =>
      $$ExcretionRecordsTableTableManager(
        _db.attachedDatabase,
        _db.excretionRecords,
      );
}
