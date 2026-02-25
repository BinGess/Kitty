import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/cats_table.dart';
import 'tables/weight_records_table.dart';
import 'tables/diet_records_table.dart';
import 'tables/water_records_table.dart';
import 'tables/excretion_records_table.dart';
import 'daos/cat_dao.dart';
import 'daos/health_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Cats, WeightRecords, DietRecords, WaterRecords, ExcretionRecords],
  daos: [CatDao, HealthDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(cats, cats.sex);
        await m.addColumn(cats, cats.isNeutered);
        await m.addColumn(cats, cats.weightGoalMinKg);
        await m.addColumn(cats, cats.weightGoalMaxKg);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'meow_talk_db');
  }
}
