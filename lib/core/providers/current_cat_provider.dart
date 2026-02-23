import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import '../database/daos/cat_dao.dart';
import 'database_provider.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final currentCatProvider =
    NotifierProvider<CurrentCatNotifier, Cat?>(CurrentCatNotifier.new);

class CurrentCatNotifier extends Notifier<Cat?> {
  @override
  Cat? build() {
    _loadLastSelected();
    return null;
  }

  CatDao get _catDao => ref.read(catDaoProvider);
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  Future<void> _loadLastSelected() async {
    Cat? found;
    final lastCatId = _prefs.getInt('current_cat_id');
    if (lastCatId != null) {
      found = await _catDao.getCatById(lastCatId);
    }
    if (found == null) {
      final cats = await _catDao.getAllCats();
      if (cats.isNotEmpty) {
        found = cats.first;
      }
    }
    if (found != null) {
      await select(found);
    } else {
      await _createDefaultCat();
    }
  }

  Future<void> _createDefaultCat() async {
    final id = await _catDao.insertCat(CatsCompanion(
      name: const Value('我的猫咪'),
      breed: const Value('未知品种'),
      targetWaterMl: const Value(200.0),
      targetMealsPerDay: const Value(3),
    ));
    final cat = await _catDao.getCatById(id);
    if (cat != null) {
      await select(cat);
    }
  }

  Future<void> select(Cat cat) async {
    await _prefs.setInt('current_cat_id', cat.id);
    state = cat;
  }

  Future<void> refresh() async {
    if (state != null) {
      state = await _catDao.getCatById(state!.id);
    }
  }
}
