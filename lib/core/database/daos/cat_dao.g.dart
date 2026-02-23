// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_dao.dart';

// ignore_for_file: type=lint
mixin _$CatDaoMixin on DatabaseAccessor<AppDatabase> {
  $CatsTable get cats => attachedDatabase.cats;
  CatDaoManager get managers => CatDaoManager(this);
}

class CatDaoManager {
  final _$CatDaoMixin _db;
  CatDaoManager(this._db);
  $$CatsTableTableManager get cats =>
      $$CatsTableTableManager(_db.attachedDatabase, _db.cats);
}
