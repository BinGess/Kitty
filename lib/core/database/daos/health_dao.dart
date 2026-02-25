import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/weight_records_table.dart';
import '../tables/diet_records_table.dart';
import '../tables/water_records_table.dart';
import '../tables/excretion_records_table.dart';

part 'health_dao.g.dart';

@DriftAccessor(
  tables: [WeightRecords, DietRecords, WaterRecords, ExcretionRecords],
)
class HealthDao extends DatabaseAccessor<AppDatabase> with _$HealthDaoMixin {
  HealthDao(super.db);

  Future<int> getRecordCountByCat(int catId) async {
    final weightCountExp = weightRecords.id.count();
    final weightCountRow =
        await (selectOnly(weightRecords)
              ..addColumns([weightCountExp])
              ..where(weightRecords.catId.equals(catId)))
            .getSingle();
    final weightCount = weightCountRow.read(weightCountExp) ?? 0;

    final dietCountExp = dietRecords.id.count();
    final dietCountRow =
        await (selectOnly(dietRecords)
              ..addColumns([dietCountExp])
              ..where(dietRecords.catId.equals(catId)))
            .getSingle();
    final dietCount = dietCountRow.read(dietCountExp) ?? 0;

    final waterCountExp = waterRecords.id.count();
    final waterCountRow =
        await (selectOnly(waterRecords)
              ..addColumns([waterCountExp])
              ..where(waterRecords.catId.equals(catId)))
            .getSingle();
    final waterCount = waterCountRow.read(waterCountExp) ?? 0;

    final excretionCountExp = excretionRecords.id.count();
    final excretionCountRow =
        await (selectOnly(excretionRecords)
              ..addColumns([excretionCountExp])
              ..where(excretionRecords.catId.equals(catId)))
            .getSingle();
    final excretionCount = excretionCountRow.read(excretionCountExp) ?? 0;

    return weightCount + dietCount + waterCount + excretionCount;
  }

  Future<bool> hasAnyRecordsForCat(int catId) async {
    return (await getRecordCountByCat(catId)) > 0;
  }

  // Weight records
  Stream<List<WeightRecord>> watchWeightRecords(int catId, {int limit = 50}) {
    return (select(weightRecords)
          ..where((r) => r.catId.equals(catId))
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(limit))
        .watch();
  }

  Future<WeightRecord?> getLatestWeight(int catId) {
    return (select(weightRecords)
          ..where((r) => r.catId.equals(catId))
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertWeightRecord(WeightRecordsCompanion record) =>
      into(weightRecords).insert(record);

  Future<int> deleteWeightRecord(int id) =>
      (delete(weightRecords)..where((r) => r.id.equals(id))).go();

  // Diet records
  Stream<List<DietRecord>> watchDietRecords(int catId, {int limit = 50}) {
    return (select(dietRecords)
          ..where((r) => r.catId.equals(catId))
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(limit))
        .watch();
  }

  Future<List<DietRecord>> getTodayDietRecords(int catId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return (select(dietRecords)
          ..where(
            (r) =>
                r.catId.equals(catId) &
                r.recordedAt.isBiggerOrEqualValue(startOfDay),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)]))
        .get();
  }

  Future<int> getDietCountSince(int catId, DateTime since) async {
    final countExp = dietRecords.id.count();
    final row =
        await (selectOnly(dietRecords)
              ..addColumns([countExp])
              ..where(
                dietRecords.catId.equals(catId) &
                    dietRecords.recordedAt.isBiggerOrEqualValue(since),
              ))
            .getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> insertDietRecord(DietRecordsCompanion record) =>
      into(dietRecords).insert(record);

  Future<int> deleteDietRecord(int id) =>
      (delete(dietRecords)..where((r) => r.id.equals(id))).go();

  // Water records
  Stream<List<WaterRecord>> watchWaterRecords(int catId, {int limit = 50}) {
    return (select(waterRecords)
          ..where((r) => r.catId.equals(catId))
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(limit))
        .watch();
  }

  Future<double> getTodayWaterTotal(int catId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final records =
        await (select(waterRecords)..where(
              (r) =>
                  r.catId.equals(catId) &
                  r.recordedAt.isBiggerOrEqualValue(startOfDay),
            ))
            .get();
    return records.fold<double>(0.0, (sum, r) => sum + r.amountMl);
  }

  Future<double> getWaterTotalSince(int catId, DateTime since) async {
    final records =
        await (select(waterRecords)..where(
              (r) =>
                  r.catId.equals(catId) &
                  r.recordedAt.isBiggerOrEqualValue(since),
            ))
            .get();
    return records.fold<double>(0.0, (sum, r) => sum + r.amountMl);
  }

  Future<int> insertWaterRecord(WaterRecordsCompanion record) =>
      into(waterRecords).insert(record);

  Future<int> deleteWaterRecord(int id) =>
      (delete(waterRecords)..where((r) => r.id.equals(id))).go();

  // Excretion records
  Stream<List<ExcretionRecord>> watchExcretionRecords(
    int catId, {
    int limit = 50,
  }) {
    return (select(excretionRecords)
          ..where((r) => r.catId.equals(catId))
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(limit))
        .watch();
  }

  Future<int> insertExcretionRecord(ExcretionRecordsCompanion record) =>
      into(excretionRecords).insert(record);

  Future<int> deleteExcretionRecord(int id) =>
      (delete(excretionRecords)..where((r) => r.id.equals(id))).go();

  Future<List<WaterRecord>> getTodayWaterRecords(int catId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return (select(waterRecords)
          ..where(
            (r) =>
                r.catId.equals(catId) &
                r.recordedAt.isBiggerOrEqualValue(startOfDay),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)]))
        .get();
  }

  Future<List<ExcretionRecord>> getTodayExcretionRecords(int catId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return (select(excretionRecords)
          ..where(
            (r) =>
                r.catId.equals(catId) &
                r.recordedAt.isBiggerOrEqualValue(startOfDay),
          )
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)]))
        .get();
  }

  Future<DietRecord?> getLatestDietRecord(int catId) {
    return (select(dietRecords)
          ..where((r) => r.catId.equals(catId))
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  // Aggregated timeline for a cat (all record types)
  Future<double?> getWeightChangePercent(int catId, Duration period) async {
    final cutoff = DateTime.now().subtract(period);
    final records =
        await (select(weightRecords)
              ..where(
                (r) =>
                    r.catId.equals(catId) &
                    r.recordedAt.isBiggerOrEqualValue(cutoff),
              )
              ..orderBy([(r) => OrderingTerm.asc(r.recordedAt)]))
            .get();
    if (records.length < 2) return null;
    final first = records.first.weightKg;
    final last = records.last.weightKg;
    return ((last - first) / first) * 100;
  }

  Future<List<WeightRecord>> getWeightTrendData(int catId, int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(weightRecords)
          ..where(
            (r) =>
                r.catId.equals(catId) &
                r.recordedAt.isBiggerOrEqualValue(cutoff),
          )
          ..orderBy([(r) => OrderingTerm.asc(r.recordedAt)]))
        .get();
  }
}
