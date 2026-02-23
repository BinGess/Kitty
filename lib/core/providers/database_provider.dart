import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final catDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).catDao;
});

final healthDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).healthDao;
});
