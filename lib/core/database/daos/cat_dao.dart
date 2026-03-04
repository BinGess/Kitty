import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cats_table.dart';

part 'cat_dao.g.dart';

@DriftAccessor(tables: [Cats])
class CatDao extends DatabaseAccessor<AppDatabase> with _$CatDaoMixin {
  CatDao(super.db);

  Future<List<Cat>> getAllCats() => select(cats).get();

  Stream<List<Cat>> watchAllCats() => select(cats).watch();

  Future<Cat?> getCatById(int id) =>
      (select(cats)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCat(CatsCompanion cat) => into(cats).insert(cat);

  Future<bool> updateCat(Insertable<Cat> cat) => update(cats).replace(cat);

  Future<bool> updatePersonalityResult({
    required int catId,
    required String code,
    required bool hasDualPersonality,
    required String mode,
    required String dimensionScoresJson,
    required String maxScoresJson,
    DateTime? testedAt,
  }) async {
    final affected = await (update(cats)..where((c) => c.id.equals(catId)))
        .write(
          CatsCompanion(
            personalityCode: Value(code),
            personalityHasDual: Value(hasDualPersonality),
            personalityTestMode: Value(mode),
            personalityDimensionScores: Value(dimensionScoresJson),
            personalityMaxScores: Value(maxScoresJson),
            personalityTestedAt: Value(testedAt ?? DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return affected > 0;
  }

  Future<int> deleteCat(int id) =>
      (delete(cats)..where((c) => c.id.equals(id))).go();
}
