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

  Future<int> deleteCat(int id) =>
      (delete(cats)..where((c) => c.id.equals(id))).go();
}
