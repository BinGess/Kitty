// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatsTable extends Cats with TableInfo<$CatsTable, Cat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetWaterMlMeta = const VerificationMeta(
    'targetWaterMl',
  );
  @override
  late final GeneratedColumn<double> targetWaterMl = GeneratedColumn<double>(
    'target_water_ml',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(200.0),
  );
  static const VerificationMeta _targetMealsPerDayMeta = const VerificationMeta(
    'targetMealsPerDay',
  );
  @override
  late final GeneratedColumn<int> targetMealsPerDay = GeneratedColumn<int>(
    'target_meals_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    breed,
    birthDate,
    photoPath,
    targetWaterMl,
    targetMealsPerDay,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cats';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('breed')) {
      context.handle(
        _breedMeta,
        breed.isAcceptableOrUnknown(data['breed']!, _breedMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('target_water_ml')) {
      context.handle(
        _targetWaterMlMeta,
        targetWaterMl.isAcceptableOrUnknown(
          data['target_water_ml']!,
          _targetWaterMlMeta,
        ),
      );
    }
    if (data.containsKey('target_meals_per_day')) {
      context.handle(
        _targetMealsPerDayMeta,
        targetMealsPerDay.isAcceptableOrUnknown(
          data['target_meals_per_day']!,
          _targetMealsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      breed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      targetWaterMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_water_ml'],
      )!,
      targetMealsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_meals_per_day'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatsTable createAlias(String alias) {
    return $CatsTable(attachedDatabase, alias);
  }
}

class Cat extends DataClass implements Insertable<Cat> {
  final int id;
  final String name;
  final String? breed;
  final DateTime? birthDate;
  final String? photoPath;
  final double targetWaterMl;
  final int targetMealsPerDay;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Cat({
    required this.id,
    required this.name,
    this.breed,
    this.birthDate,
    this.photoPath,
    required this.targetWaterMl,
    required this.targetMealsPerDay,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['target_water_ml'] = Variable<double>(targetWaterMl);
    map['target_meals_per_day'] = Variable<int>(targetMealsPerDay);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatsCompanion toCompanion(bool nullToAbsent) {
    return CatsCompanion(
      id: Value(id),
      name: Value(name),
      breed: breed == null && nullToAbsent
          ? const Value.absent()
          : Value(breed),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      targetWaterMl: Value(targetWaterMl),
      targetMealsPerDay: Value(targetMealsPerDay),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Cat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cat(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      breed: serializer.fromJson<String?>(json['breed']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      targetWaterMl: serializer.fromJson<double>(json['targetWaterMl']),
      targetMealsPerDay: serializer.fromJson<int>(json['targetMealsPerDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'breed': serializer.toJson<String?>(breed),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'photoPath': serializer.toJson<String?>(photoPath),
      'targetWaterMl': serializer.toJson<double>(targetWaterMl),
      'targetMealsPerDay': serializer.toJson<int>(targetMealsPerDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Cat copyWith({
    int? id,
    String? name,
    Value<String?> breed = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    double? targetWaterMl,
    int? targetMealsPerDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Cat(
    id: id ?? this.id,
    name: name ?? this.name,
    breed: breed.present ? breed.value : this.breed,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    targetWaterMl: targetWaterMl ?? this.targetWaterMl,
    targetMealsPerDay: targetMealsPerDay ?? this.targetMealsPerDay,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Cat copyWithCompanion(CatsCompanion data) {
    return Cat(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      breed: data.breed.present ? data.breed.value : this.breed,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      targetWaterMl: data.targetWaterMl.present
          ? data.targetWaterMl.value
          : this.targetWaterMl,
      targetMealsPerDay: data.targetMealsPerDay.present
          ? data.targetMealsPerDay.value
          : this.targetMealsPerDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cat(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('birthDate: $birthDate, ')
          ..write('photoPath: $photoPath, ')
          ..write('targetWaterMl: $targetWaterMl, ')
          ..write('targetMealsPerDay: $targetMealsPerDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    breed,
    birthDate,
    photoPath,
    targetWaterMl,
    targetMealsPerDay,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cat &&
          other.id == this.id &&
          other.name == this.name &&
          other.breed == this.breed &&
          other.birthDate == this.birthDate &&
          other.photoPath == this.photoPath &&
          other.targetWaterMl == this.targetWaterMl &&
          other.targetMealsPerDay == this.targetMealsPerDay &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CatsCompanion extends UpdateCompanion<Cat> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> breed;
  final Value<DateTime?> birthDate;
  final Value<String?> photoPath;
  final Value<double> targetWaterMl;
  final Value<int> targetMealsPerDay;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CatsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.breed = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.targetWaterMl = const Value.absent(),
    this.targetMealsPerDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CatsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.breed = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.targetWaterMl = const Value.absent(),
    this.targetMealsPerDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Cat> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? breed,
    Expression<DateTime>? birthDate,
    Expression<String>? photoPath,
    Expression<double>? targetWaterMl,
    Expression<int>? targetMealsPerDay,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (breed != null) 'breed': breed,
      if (birthDate != null) 'birth_date': birthDate,
      if (photoPath != null) 'photo_path': photoPath,
      if (targetWaterMl != null) 'target_water_ml': targetWaterMl,
      if (targetMealsPerDay != null) 'target_meals_per_day': targetMealsPerDay,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CatsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? breed,
    Value<DateTime?>? birthDate,
    Value<String?>? photoPath,
    Value<double>? targetWaterMl,
    Value<int>? targetMealsPerDay,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CatsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      photoPath: photoPath ?? this.photoPath,
      targetWaterMl: targetWaterMl ?? this.targetWaterMl,
      targetMealsPerDay: targetMealsPerDay ?? this.targetMealsPerDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (targetWaterMl.present) {
      map['target_water_ml'] = Variable<double>(targetWaterMl.value);
    }
    if (targetMealsPerDay.present) {
      map['target_meals_per_day'] = Variable<int>(targetMealsPerDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('breed: $breed, ')
          ..write('birthDate: $birthDate, ')
          ..write('photoPath: $photoPath, ')
          ..write('targetWaterMl: $targetWaterMl, ')
          ..write('targetMealsPerDay: $targetMealsPerDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WeightRecordsTable extends WeightRecords
    with TableInfo<$WeightRecordsTable, WeightRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<int> catId = GeneratedColumn<int>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cats (id)',
    ),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodAnnotationMeta = const VerificationMeta(
    'moodAnnotation',
  );
  @override
  late final GeneratedColumn<String> moodAnnotation = GeneratedColumn<String>(
    'mood_annotation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    weightKg,
    moodAnnotation,
    recordedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('mood_annotation')) {
      context.handle(
        _moodAnnotationMeta,
        moodAnnotation.isAcceptableOrUnknown(
          data['mood_annotation']!,
          _moodAnnotationMeta,
        ),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cat_id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      moodAnnotation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_annotation'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeightRecordsTable createAlias(String alias) {
    return $WeightRecordsTable(attachedDatabase, alias);
  }
}

class WeightRecord extends DataClass implements Insertable<WeightRecord> {
  final int id;
  final int catId;
  final double weightKg;
  final String? moodAnnotation;
  final DateTime recordedAt;
  final DateTime createdAt;
  const WeightRecord({
    required this.id,
    required this.catId,
    required this.weightKg,
    this.moodAnnotation,
    required this.recordedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cat_id'] = Variable<int>(catId);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || moodAnnotation != null) {
      map['mood_annotation'] = Variable<String>(moodAnnotation);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WeightRecordsCompanion toCompanion(bool nullToAbsent) {
    return WeightRecordsCompanion(
      id: Value(id),
      catId: Value(catId),
      weightKg: Value(weightKg),
      moodAnnotation: moodAnnotation == null && nullToAbsent
          ? const Value.absent()
          : Value(moodAnnotation),
      recordedAt: Value(recordedAt),
      createdAt: Value(createdAt),
    );
  }

  factory WeightRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRecord(
      id: serializer.fromJson<int>(json['id']),
      catId: serializer.fromJson<int>(json['catId']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      moodAnnotation: serializer.fromJson<String?>(json['moodAnnotation']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catId': serializer.toJson<int>(catId),
      'weightKg': serializer.toJson<double>(weightKg),
      'moodAnnotation': serializer.toJson<String?>(moodAnnotation),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WeightRecord copyWith({
    int? id,
    int? catId,
    double? weightKg,
    Value<String?> moodAnnotation = const Value.absent(),
    DateTime? recordedAt,
    DateTime? createdAt,
  }) => WeightRecord(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    weightKg: weightKg ?? this.weightKg,
    moodAnnotation: moodAnnotation.present
        ? moodAnnotation.value
        : this.moodAnnotation,
    recordedAt: recordedAt ?? this.recordedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  WeightRecord copyWithCompanion(WeightRecordsCompanion data) {
    return WeightRecord(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      moodAnnotation: data.moodAnnotation.present
          ? data.moodAnnotation.value
          : this.moodAnnotation,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecord(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('weightKg: $weightKg, ')
          ..write('moodAnnotation: $moodAnnotation, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, catId, weightKg, moodAnnotation, recordedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRecord &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.weightKg == this.weightKg &&
          other.moodAnnotation == this.moodAnnotation &&
          other.recordedAt == this.recordedAt &&
          other.createdAt == this.createdAt);
}

class WeightRecordsCompanion extends UpdateCompanion<WeightRecord> {
  final Value<int> id;
  final Value<int> catId;
  final Value<double> weightKg;
  final Value<String?> moodAnnotation;
  final Value<DateTime> recordedAt;
  final Value<DateTime> createdAt;
  const WeightRecordsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.moodAnnotation = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WeightRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int catId,
    required double weightKg,
    this.moodAnnotation = const Value.absent(),
    required DateTime recordedAt,
    this.createdAt = const Value.absent(),
  }) : catId = Value(catId),
       weightKg = Value(weightKg),
       recordedAt = Value(recordedAt);
  static Insertable<WeightRecord> custom({
    Expression<int>? id,
    Expression<int>? catId,
    Expression<double>? weightKg,
    Expression<String>? moodAnnotation,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (moodAnnotation != null) 'mood_annotation': moodAnnotation,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WeightRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? catId,
    Value<double>? weightKg,
    Value<String?>? moodAnnotation,
    Value<DateTime>? recordedAt,
    Value<DateTime>? createdAt,
  }) {
    return WeightRecordsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      weightKg: weightKg ?? this.weightKg,
      moodAnnotation: moodAnnotation ?? this.moodAnnotation,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<int>(catId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (moodAnnotation.present) {
      map['mood_annotation'] = Variable<String>(moodAnnotation.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('weightKg: $weightKg, ')
          ..write('moodAnnotation: $moodAnnotation, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DietRecordsTable extends DietRecords
    with TableInfo<$DietRecordsTable, DietRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DietRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<int> catId = GeneratedColumn<int>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cats (id)',
    ),
  );
  static const VerificationMeta _brandTagMeta = const VerificationMeta(
    'brandTag',
  );
  @override
  late final GeneratedColumn<String> brandTag = GeneratedColumn<String>(
    'brand_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountGramsMeta = const VerificationMeta(
    'amountGrams',
  );
  @override
  late final GeneratedColumn<double> amountGrams = GeneratedColumn<double>(
    'amount_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodTypeMeta = const VerificationMeta(
    'foodType',
  );
  @override
  late final GeneratedColumn<String> foodType = GeneratedColumn<String>(
    'food_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    brandTag,
    amountGrams,
    foodType,
    recordedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diet_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DietRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('brand_tag')) {
      context.handle(
        _brandTagMeta,
        brandTag.isAcceptableOrUnknown(data['brand_tag']!, _brandTagMeta),
      );
    }
    if (data.containsKey('amount_grams')) {
      context.handle(
        _amountGramsMeta,
        amountGrams.isAcceptableOrUnknown(
          data['amount_grams']!,
          _amountGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountGramsMeta);
    }
    if (data.containsKey('food_type')) {
      context.handle(
        _foodTypeMeta,
        foodType.isAcceptableOrUnknown(data['food_type']!, _foodTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_foodTypeMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DietRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DietRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cat_id'],
      )!,
      brandTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_tag'],
      ),
      amountGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_grams'],
      )!,
      foodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_type'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DietRecordsTable createAlias(String alias) {
    return $DietRecordsTable(attachedDatabase, alias);
  }
}

class DietRecord extends DataClass implements Insertable<DietRecord> {
  final int id;
  final int catId;
  final String? brandTag;
  final double amountGrams;
  final String foodType;
  final DateTime recordedAt;
  final DateTime createdAt;
  const DietRecord({
    required this.id,
    required this.catId,
    this.brandTag,
    required this.amountGrams,
    required this.foodType,
    required this.recordedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cat_id'] = Variable<int>(catId);
    if (!nullToAbsent || brandTag != null) {
      map['brand_tag'] = Variable<String>(brandTag);
    }
    map['amount_grams'] = Variable<double>(amountGrams);
    map['food_type'] = Variable<String>(foodType);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DietRecordsCompanion toCompanion(bool nullToAbsent) {
    return DietRecordsCompanion(
      id: Value(id),
      catId: Value(catId),
      brandTag: brandTag == null && nullToAbsent
          ? const Value.absent()
          : Value(brandTag),
      amountGrams: Value(amountGrams),
      foodType: Value(foodType),
      recordedAt: Value(recordedAt),
      createdAt: Value(createdAt),
    );
  }

  factory DietRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DietRecord(
      id: serializer.fromJson<int>(json['id']),
      catId: serializer.fromJson<int>(json['catId']),
      brandTag: serializer.fromJson<String?>(json['brandTag']),
      amountGrams: serializer.fromJson<double>(json['amountGrams']),
      foodType: serializer.fromJson<String>(json['foodType']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catId': serializer.toJson<int>(catId),
      'brandTag': serializer.toJson<String?>(brandTag),
      'amountGrams': serializer.toJson<double>(amountGrams),
      'foodType': serializer.toJson<String>(foodType),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DietRecord copyWith({
    int? id,
    int? catId,
    Value<String?> brandTag = const Value.absent(),
    double? amountGrams,
    String? foodType,
    DateTime? recordedAt,
    DateTime? createdAt,
  }) => DietRecord(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    brandTag: brandTag.present ? brandTag.value : this.brandTag,
    amountGrams: amountGrams ?? this.amountGrams,
    foodType: foodType ?? this.foodType,
    recordedAt: recordedAt ?? this.recordedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  DietRecord copyWithCompanion(DietRecordsCompanion data) {
    return DietRecord(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      brandTag: data.brandTag.present ? data.brandTag.value : this.brandTag,
      amountGrams: data.amountGrams.present
          ? data.amountGrams.value
          : this.amountGrams,
      foodType: data.foodType.present ? data.foodType.value : this.foodType,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DietRecord(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('brandTag: $brandTag, ')
          ..write('amountGrams: $amountGrams, ')
          ..write('foodType: $foodType, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    brandTag,
    amountGrams,
    foodType,
    recordedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DietRecord &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.brandTag == this.brandTag &&
          other.amountGrams == this.amountGrams &&
          other.foodType == this.foodType &&
          other.recordedAt == this.recordedAt &&
          other.createdAt == this.createdAt);
}

class DietRecordsCompanion extends UpdateCompanion<DietRecord> {
  final Value<int> id;
  final Value<int> catId;
  final Value<String?> brandTag;
  final Value<double> amountGrams;
  final Value<String> foodType;
  final Value<DateTime> recordedAt;
  final Value<DateTime> createdAt;
  const DietRecordsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.brandTag = const Value.absent(),
    this.amountGrams = const Value.absent(),
    this.foodType = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DietRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int catId,
    this.brandTag = const Value.absent(),
    required double amountGrams,
    required String foodType,
    required DateTime recordedAt,
    this.createdAt = const Value.absent(),
  }) : catId = Value(catId),
       amountGrams = Value(amountGrams),
       foodType = Value(foodType),
       recordedAt = Value(recordedAt);
  static Insertable<DietRecord> custom({
    Expression<int>? id,
    Expression<int>? catId,
    Expression<String>? brandTag,
    Expression<double>? amountGrams,
    Expression<String>? foodType,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (brandTag != null) 'brand_tag': brandTag,
      if (amountGrams != null) 'amount_grams': amountGrams,
      if (foodType != null) 'food_type': foodType,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DietRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? catId,
    Value<String?>? brandTag,
    Value<double>? amountGrams,
    Value<String>? foodType,
    Value<DateTime>? recordedAt,
    Value<DateTime>? createdAt,
  }) {
    return DietRecordsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      brandTag: brandTag ?? this.brandTag,
      amountGrams: amountGrams ?? this.amountGrams,
      foodType: foodType ?? this.foodType,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<int>(catId.value);
    }
    if (brandTag.present) {
      map['brand_tag'] = Variable<String>(brandTag.value);
    }
    if (amountGrams.present) {
      map['amount_grams'] = Variable<double>(amountGrams.value);
    }
    if (foodType.present) {
      map['food_type'] = Variable<String>(foodType.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DietRecordsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('brandTag: $brandTag, ')
          ..write('amountGrams: $amountGrams, ')
          ..write('foodType: $foodType, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WaterRecordsTable extends WaterRecords
    with TableInfo<$WaterRecordsTable, WaterRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<int> catId = GeneratedColumn<int>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cats (id)',
    ),
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<double> amountMl = GeneratedColumn<double>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    amountMl,
    recordedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cat_id'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_ml'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WaterRecordsTable createAlias(String alias) {
    return $WaterRecordsTable(attachedDatabase, alias);
  }
}

class WaterRecord extends DataClass implements Insertable<WaterRecord> {
  final int id;
  final int catId;
  final double amountMl;
  final DateTime recordedAt;
  final DateTime createdAt;
  const WaterRecord({
    required this.id,
    required this.catId,
    required this.amountMl,
    required this.recordedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cat_id'] = Variable<int>(catId);
    map['amount_ml'] = Variable<double>(amountMl);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WaterRecordsCompanion toCompanion(bool nullToAbsent) {
    return WaterRecordsCompanion(
      id: Value(id),
      catId: Value(catId),
      amountMl: Value(amountMl),
      recordedAt: Value(recordedAt),
      createdAt: Value(createdAt),
    );
  }

  factory WaterRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterRecord(
      id: serializer.fromJson<int>(json['id']),
      catId: serializer.fromJson<int>(json['catId']),
      amountMl: serializer.fromJson<double>(json['amountMl']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catId': serializer.toJson<int>(catId),
      'amountMl': serializer.toJson<double>(amountMl),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WaterRecord copyWith({
    int? id,
    int? catId,
    double? amountMl,
    DateTime? recordedAt,
    DateTime? createdAt,
  }) => WaterRecord(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    amountMl: amountMl ?? this.amountMl,
    recordedAt: recordedAt ?? this.recordedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  WaterRecord copyWithCompanion(WaterRecordsCompanion data) {
    return WaterRecord(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterRecord(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('amountMl: $amountMl, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, catId, amountMl, recordedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterRecord &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.amountMl == this.amountMl &&
          other.recordedAt == this.recordedAt &&
          other.createdAt == this.createdAt);
}

class WaterRecordsCompanion extends UpdateCompanion<WaterRecord> {
  final Value<int> id;
  final Value<int> catId;
  final Value<double> amountMl;
  final Value<DateTime> recordedAt;
  final Value<DateTime> createdAt;
  const WaterRecordsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WaterRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int catId,
    required double amountMl,
    required DateTime recordedAt,
    this.createdAt = const Value.absent(),
  }) : catId = Value(catId),
       amountMl = Value(amountMl),
       recordedAt = Value(recordedAt);
  static Insertable<WaterRecord> custom({
    Expression<int>? id,
    Expression<int>? catId,
    Expression<double>? amountMl,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (amountMl != null) 'amount_ml': amountMl,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WaterRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? catId,
    Value<double>? amountMl,
    Value<DateTime>? recordedAt,
    Value<DateTime>? createdAt,
  }) {
    return WaterRecordsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      amountMl: amountMl ?? this.amountMl,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<int>(catId.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<double>(amountMl.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterRecordsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('amountMl: $amountMl, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExcretionRecordsTable extends ExcretionRecords
    with TableInfo<$ExcretionRecordsTable, ExcretionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExcretionRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<int> catId = GeneratedColumn<int>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cats (id)',
    ),
  );
  static const VerificationMeta _excretionTypeMeta = const VerificationMeta(
    'excretionType',
  );
  @override
  late final GeneratedColumn<String> excretionType = GeneratedColumn<String>(
    'excretion_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bristolScaleMeta = const VerificationMeta(
    'bristolScale',
  );
  @override
  late final GeneratedColumn<int> bristolScale = GeneratedColumn<int>(
    'bristol_scale',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urineAmountMeta = const VerificationMeta(
    'urineAmount',
  );
  @override
  late final GeneratedColumn<int> urineAmount = GeneratedColumn<int>(
    'urine_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasBloodMeta = const VerificationMeta(
    'hasBlood',
  );
  @override
  late final GeneratedColumn<bool> hasBlood = GeneratedColumn<bool>(
    'has_blood',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_blood" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasAnomalyMeta = const VerificationMeta(
    'hasAnomaly',
  );
  @override
  late final GeneratedColumn<bool> hasAnomaly = GeneratedColumn<bool>(
    'has_anomaly',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_anomaly" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    excretionType,
    bristolScale,
    urineAmount,
    hasBlood,
    hasAnomaly,
    notes,
    recordedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'excretion_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExcretionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('excretion_type')) {
      context.handle(
        _excretionTypeMeta,
        excretionType.isAcceptableOrUnknown(
          data['excretion_type']!,
          _excretionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_excretionTypeMeta);
    }
    if (data.containsKey('bristol_scale')) {
      context.handle(
        _bristolScaleMeta,
        bristolScale.isAcceptableOrUnknown(
          data['bristol_scale']!,
          _bristolScaleMeta,
        ),
      );
    }
    if (data.containsKey('urine_amount')) {
      context.handle(
        _urineAmountMeta,
        urineAmount.isAcceptableOrUnknown(
          data['urine_amount']!,
          _urineAmountMeta,
        ),
      );
    }
    if (data.containsKey('has_blood')) {
      context.handle(
        _hasBloodMeta,
        hasBlood.isAcceptableOrUnknown(data['has_blood']!, _hasBloodMeta),
      );
    }
    if (data.containsKey('has_anomaly')) {
      context.handle(
        _hasAnomalyMeta,
        hasAnomaly.isAcceptableOrUnknown(data['has_anomaly']!, _hasAnomalyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExcretionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExcretionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cat_id'],
      )!,
      excretionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}excretion_type'],
      )!,
      bristolScale: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bristol_scale'],
      ),
      urineAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urine_amount'],
      ),
      hasBlood: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_blood'],
      )!,
      hasAnomaly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_anomaly'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExcretionRecordsTable createAlias(String alias) {
    return $ExcretionRecordsTable(attachedDatabase, alias);
  }
}

class ExcretionRecord extends DataClass implements Insertable<ExcretionRecord> {
  final int id;
  final int catId;
  final String excretionType;
  final int? bristolScale;
  final int? urineAmount;
  final bool hasBlood;
  final bool hasAnomaly;
  final String? notes;
  final DateTime recordedAt;
  final DateTime createdAt;
  const ExcretionRecord({
    required this.id,
    required this.catId,
    required this.excretionType,
    this.bristolScale,
    this.urineAmount,
    required this.hasBlood,
    required this.hasAnomaly,
    this.notes,
    required this.recordedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cat_id'] = Variable<int>(catId);
    map['excretion_type'] = Variable<String>(excretionType);
    if (!nullToAbsent || bristolScale != null) {
      map['bristol_scale'] = Variable<int>(bristolScale);
    }
    if (!nullToAbsent || urineAmount != null) {
      map['urine_amount'] = Variable<int>(urineAmount);
    }
    map['has_blood'] = Variable<bool>(hasBlood);
    map['has_anomaly'] = Variable<bool>(hasAnomaly);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExcretionRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExcretionRecordsCompanion(
      id: Value(id),
      catId: Value(catId),
      excretionType: Value(excretionType),
      bristolScale: bristolScale == null && nullToAbsent
          ? const Value.absent()
          : Value(bristolScale),
      urineAmount: urineAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(urineAmount),
      hasBlood: Value(hasBlood),
      hasAnomaly: Value(hasAnomaly),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      recordedAt: Value(recordedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ExcretionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExcretionRecord(
      id: serializer.fromJson<int>(json['id']),
      catId: serializer.fromJson<int>(json['catId']),
      excretionType: serializer.fromJson<String>(json['excretionType']),
      bristolScale: serializer.fromJson<int?>(json['bristolScale']),
      urineAmount: serializer.fromJson<int?>(json['urineAmount']),
      hasBlood: serializer.fromJson<bool>(json['hasBlood']),
      hasAnomaly: serializer.fromJson<bool>(json['hasAnomaly']),
      notes: serializer.fromJson<String?>(json['notes']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'catId': serializer.toJson<int>(catId),
      'excretionType': serializer.toJson<String>(excretionType),
      'bristolScale': serializer.toJson<int?>(bristolScale),
      'urineAmount': serializer.toJson<int?>(urineAmount),
      'hasBlood': serializer.toJson<bool>(hasBlood),
      'hasAnomaly': serializer.toJson<bool>(hasAnomaly),
      'notes': serializer.toJson<String?>(notes),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExcretionRecord copyWith({
    int? id,
    int? catId,
    String? excretionType,
    Value<int?> bristolScale = const Value.absent(),
    Value<int?> urineAmount = const Value.absent(),
    bool? hasBlood,
    bool? hasAnomaly,
    Value<String?> notes = const Value.absent(),
    DateTime? recordedAt,
    DateTime? createdAt,
  }) => ExcretionRecord(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    excretionType: excretionType ?? this.excretionType,
    bristolScale: bristolScale.present ? bristolScale.value : this.bristolScale,
    urineAmount: urineAmount.present ? urineAmount.value : this.urineAmount,
    hasBlood: hasBlood ?? this.hasBlood,
    hasAnomaly: hasAnomaly ?? this.hasAnomaly,
    notes: notes.present ? notes.value : this.notes,
    recordedAt: recordedAt ?? this.recordedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ExcretionRecord copyWithCompanion(ExcretionRecordsCompanion data) {
    return ExcretionRecord(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      excretionType: data.excretionType.present
          ? data.excretionType.value
          : this.excretionType,
      bristolScale: data.bristolScale.present
          ? data.bristolScale.value
          : this.bristolScale,
      urineAmount: data.urineAmount.present
          ? data.urineAmount.value
          : this.urineAmount,
      hasBlood: data.hasBlood.present ? data.hasBlood.value : this.hasBlood,
      hasAnomaly: data.hasAnomaly.present
          ? data.hasAnomaly.value
          : this.hasAnomaly,
      notes: data.notes.present ? data.notes.value : this.notes,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExcretionRecord(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('excretionType: $excretionType, ')
          ..write('bristolScale: $bristolScale, ')
          ..write('urineAmount: $urineAmount, ')
          ..write('hasBlood: $hasBlood, ')
          ..write('hasAnomaly: $hasAnomaly, ')
          ..write('notes: $notes, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    excretionType,
    bristolScale,
    urineAmount,
    hasBlood,
    hasAnomaly,
    notes,
    recordedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExcretionRecord &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.excretionType == this.excretionType &&
          other.bristolScale == this.bristolScale &&
          other.urineAmount == this.urineAmount &&
          other.hasBlood == this.hasBlood &&
          other.hasAnomaly == this.hasAnomaly &&
          other.notes == this.notes &&
          other.recordedAt == this.recordedAt &&
          other.createdAt == this.createdAt);
}

class ExcretionRecordsCompanion extends UpdateCompanion<ExcretionRecord> {
  final Value<int> id;
  final Value<int> catId;
  final Value<String> excretionType;
  final Value<int?> bristolScale;
  final Value<int?> urineAmount;
  final Value<bool> hasBlood;
  final Value<bool> hasAnomaly;
  final Value<String?> notes;
  final Value<DateTime> recordedAt;
  final Value<DateTime> createdAt;
  const ExcretionRecordsCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.excretionType = const Value.absent(),
    this.bristolScale = const Value.absent(),
    this.urineAmount = const Value.absent(),
    this.hasBlood = const Value.absent(),
    this.hasAnomaly = const Value.absent(),
    this.notes = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExcretionRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int catId,
    required String excretionType,
    this.bristolScale = const Value.absent(),
    this.urineAmount = const Value.absent(),
    this.hasBlood = const Value.absent(),
    this.hasAnomaly = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime recordedAt,
    this.createdAt = const Value.absent(),
  }) : catId = Value(catId),
       excretionType = Value(excretionType),
       recordedAt = Value(recordedAt);
  static Insertable<ExcretionRecord> custom({
    Expression<int>? id,
    Expression<int>? catId,
    Expression<String>? excretionType,
    Expression<int>? bristolScale,
    Expression<int>? urineAmount,
    Expression<bool>? hasBlood,
    Expression<bool>? hasAnomaly,
    Expression<String>? notes,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (excretionType != null) 'excretion_type': excretionType,
      if (bristolScale != null) 'bristol_scale': bristolScale,
      if (urineAmount != null) 'urine_amount': urineAmount,
      if (hasBlood != null) 'has_blood': hasBlood,
      if (hasAnomaly != null) 'has_anomaly': hasAnomaly,
      if (notes != null) 'notes': notes,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExcretionRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? catId,
    Value<String>? excretionType,
    Value<int?>? bristolScale,
    Value<int?>? urineAmount,
    Value<bool>? hasBlood,
    Value<bool>? hasAnomaly,
    Value<String?>? notes,
    Value<DateTime>? recordedAt,
    Value<DateTime>? createdAt,
  }) {
    return ExcretionRecordsCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      excretionType: excretionType ?? this.excretionType,
      bristolScale: bristolScale ?? this.bristolScale,
      urineAmount: urineAmount ?? this.urineAmount,
      hasBlood: hasBlood ?? this.hasBlood,
      hasAnomaly: hasAnomaly ?? this.hasAnomaly,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<int>(catId.value);
    }
    if (excretionType.present) {
      map['excretion_type'] = Variable<String>(excretionType.value);
    }
    if (bristolScale.present) {
      map['bristol_scale'] = Variable<int>(bristolScale.value);
    }
    if (urineAmount.present) {
      map['urine_amount'] = Variable<int>(urineAmount.value);
    }
    if (hasBlood.present) {
      map['has_blood'] = Variable<bool>(hasBlood.value);
    }
    if (hasAnomaly.present) {
      map['has_anomaly'] = Variable<bool>(hasAnomaly.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExcretionRecordsCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('excretionType: $excretionType, ')
          ..write('bristolScale: $bristolScale, ')
          ..write('urineAmount: $urineAmount, ')
          ..write('hasBlood: $hasBlood, ')
          ..write('hasAnomaly: $hasAnomaly, ')
          ..write('notes: $notes, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatsTable cats = $CatsTable(this);
  late final $WeightRecordsTable weightRecords = $WeightRecordsTable(this);
  late final $DietRecordsTable dietRecords = $DietRecordsTable(this);
  late final $WaterRecordsTable waterRecords = $WaterRecordsTable(this);
  late final $ExcretionRecordsTable excretionRecords = $ExcretionRecordsTable(
    this,
  );
  late final CatDao catDao = CatDao(this as AppDatabase);
  late final HealthDao healthDao = HealthDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cats,
    weightRecords,
    dietRecords,
    waterRecords,
    excretionRecords,
  ];
}

typedef $$CatsTableCreateCompanionBuilder =
    CatsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> breed,
      Value<DateTime?> birthDate,
      Value<String?> photoPath,
      Value<double> targetWaterMl,
      Value<int> targetMealsPerDay,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CatsTableUpdateCompanionBuilder =
    CatsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> breed,
      Value<DateTime?> birthDate,
      Value<String?> photoPath,
      Value<double> targetWaterMl,
      Value<int> targetMealsPerDay,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CatsTableReferences
    extends BaseReferences<_$AppDatabase, $CatsTable, Cat> {
  $$CatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WeightRecordsTable, List<WeightRecord>>
  _weightRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weightRecords,
    aliasName: $_aliasNameGenerator(db.cats.id, db.weightRecords.catId),
  );

  $$WeightRecordsTableProcessedTableManager get weightRecordsRefs {
    final manager = $$WeightRecordsTableTableManager(
      $_db,
      $_db.weightRecords,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_weightRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DietRecordsTable, List<DietRecord>>
  _dietRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dietRecords,
    aliasName: $_aliasNameGenerator(db.cats.id, db.dietRecords.catId),
  );

  $$DietRecordsTableProcessedTableManager get dietRecordsRefs {
    final manager = $$DietRecordsTableTableManager(
      $_db,
      $_db.dietRecords,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dietRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WaterRecordsTable, List<WaterRecord>>
  _waterRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.waterRecords,
    aliasName: $_aliasNameGenerator(db.cats.id, db.waterRecords.catId),
  );

  $$WaterRecordsTableProcessedTableManager get waterRecordsRefs {
    final manager = $$WaterRecordsTableTableManager(
      $_db,
      $_db.waterRecords,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_waterRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExcretionRecordsTable, List<ExcretionRecord>>
  _excretionRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.excretionRecords,
    aliasName: $_aliasNameGenerator(db.cats.id, db.excretionRecords.catId),
  );

  $$ExcretionRecordsTableProcessedTableManager get excretionRecordsRefs {
    final manager = $$ExcretionRecordsTableTableManager(
      $_db,
      $_db.excretionRecords,
    ).filter((f) => f.catId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _excretionRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CatsTableFilterComposer extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWaterMl => $composableBuilder(
    column: $table.targetWaterMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMealsPerDay => $composableBuilder(
    column: $table.targetMealsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weightRecordsRefs(
    Expression<bool> Function($$WeightRecordsTableFilterComposer f) f,
  ) {
    final $$WeightRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightRecordsTableFilterComposer(
            $db: $db,
            $table: $db.weightRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dietRecordsRefs(
    Expression<bool> Function($$DietRecordsTableFilterComposer f) f,
  ) {
    final $$DietRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dietRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DietRecordsTableFilterComposer(
            $db: $db,
            $table: $db.dietRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> waterRecordsRefs(
    Expression<bool> Function($$WaterRecordsTableFilterComposer f) f,
  ) {
    final $$WaterRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waterRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaterRecordsTableFilterComposer(
            $db: $db,
            $table: $db.waterRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> excretionRecordsRefs(
    Expression<bool> Function($$ExcretionRecordsTableFilterComposer f) f,
  ) {
    final $$ExcretionRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.excretionRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExcretionRecordsTableFilterComposer(
            $db: $db,
            $table: $db.excretionRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatsTableOrderingComposer extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWaterMl => $composableBuilder(
    column: $table.targetWaterMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMealsPerDay => $composableBuilder(
    column: $table.targetMealsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatsTable> {
  $$CatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<double> get targetWaterMl => $composableBuilder(
    column: $table.targetWaterMl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMealsPerDay => $composableBuilder(
    column: $table.targetMealsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> weightRecordsRefs<T extends Object>(
    Expression<T> Function($$WeightRecordsTableAnnotationComposer a) f,
  ) {
    final $$WeightRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.weightRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dietRecordsRefs<T extends Object>(
    Expression<T> Function($$DietRecordsTableAnnotationComposer a) f,
  ) {
    final $$DietRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dietRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DietRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.dietRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> waterRecordsRefs<T extends Object>(
    Expression<T> Function($$WaterRecordsTableAnnotationComposer a) f,
  ) {
    final $$WaterRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waterRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaterRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.waterRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> excretionRecordsRefs<T extends Object>(
    Expression<T> Function($$ExcretionRecordsTableAnnotationComposer a) f,
  ) {
    final $$ExcretionRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.excretionRecords,
      getReferencedColumn: (t) => t.catId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExcretionRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.excretionRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatsTable,
          Cat,
          $$CatsTableFilterComposer,
          $$CatsTableOrderingComposer,
          $$CatsTableAnnotationComposer,
          $$CatsTableCreateCompanionBuilder,
          $$CatsTableUpdateCompanionBuilder,
          (Cat, $$CatsTableReferences),
          Cat,
          PrefetchHooks Function({
            bool weightRecordsRefs,
            bool dietRecordsRefs,
            bool waterRecordsRefs,
            bool excretionRecordsRefs,
          })
        > {
  $$CatsTableTableManager(_$AppDatabase db, $CatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double> targetWaterMl = const Value.absent(),
                Value<int> targetMealsPerDay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CatsCompanion(
                id: id,
                name: name,
                breed: breed,
                birthDate: birthDate,
                photoPath: photoPath,
                targetWaterMl: targetWaterMl,
                targetMealsPerDay: targetMealsPerDay,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> breed = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double> targetWaterMl = const Value.absent(),
                Value<int> targetMealsPerDay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CatsCompanion.insert(
                id: id,
                name: name,
                breed: breed,
                birthDate: birthDate,
                photoPath: photoPath,
                targetWaterMl: targetWaterMl,
                targetMealsPerDay: targetMealsPerDay,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CatsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                weightRecordsRefs = false,
                dietRecordsRefs = false,
                waterRecordsRefs = false,
                excretionRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weightRecordsRefs) db.weightRecords,
                    if (dietRecordsRefs) db.dietRecords,
                    if (waterRecordsRefs) db.waterRecords,
                    if (excretionRecordsRefs) db.excretionRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weightRecordsRefs)
                        await $_getPrefetchedData<
                          Cat,
                          $CatsTable,
                          WeightRecord
                        >(
                          currentTable: table,
                          referencedTable: $$CatsTableReferences
                              ._weightRecordsRefsTable(db),
                          managerFromTypedResult: (p0) => $$CatsTableReferences(
                            db,
                            table,
                            p0,
                          ).weightRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dietRecordsRefs)
                        await $_getPrefetchedData<Cat, $CatsTable, DietRecord>(
                          currentTable: table,
                          referencedTable: $$CatsTableReferences
                              ._dietRecordsRefsTable(db),
                          managerFromTypedResult: (p0) => $$CatsTableReferences(
                            db,
                            table,
                            p0,
                          ).dietRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (waterRecordsRefs)
                        await $_getPrefetchedData<Cat, $CatsTable, WaterRecord>(
                          currentTable: table,
                          referencedTable: $$CatsTableReferences
                              ._waterRecordsRefsTable(db),
                          managerFromTypedResult: (p0) => $$CatsTableReferences(
                            db,
                            table,
                            p0,
                          ).waterRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (excretionRecordsRefs)
                        await $_getPrefetchedData<
                          Cat,
                          $CatsTable,
                          ExcretionRecord
                        >(
                          currentTable: table,
                          referencedTable: $$CatsTableReferences
                              ._excretionRecordsRefsTable(db),
                          managerFromTypedResult: (p0) => $$CatsTableReferences(
                            db,
                            table,
                            p0,
                          ).excretionRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.catId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatsTable,
      Cat,
      $$CatsTableFilterComposer,
      $$CatsTableOrderingComposer,
      $$CatsTableAnnotationComposer,
      $$CatsTableCreateCompanionBuilder,
      $$CatsTableUpdateCompanionBuilder,
      (Cat, $$CatsTableReferences),
      Cat,
      PrefetchHooks Function({
        bool weightRecordsRefs,
        bool dietRecordsRefs,
        bool waterRecordsRefs,
        bool excretionRecordsRefs,
      })
    >;
typedef $$WeightRecordsTableCreateCompanionBuilder =
    WeightRecordsCompanion Function({
      Value<int> id,
      required int catId,
      required double weightKg,
      Value<String?> moodAnnotation,
      required DateTime recordedAt,
      Value<DateTime> createdAt,
    });
typedef $$WeightRecordsTableUpdateCompanionBuilder =
    WeightRecordsCompanion Function({
      Value<int> id,
      Value<int> catId,
      Value<double> weightKg,
      Value<String?> moodAnnotation,
      Value<DateTime> recordedAt,
      Value<DateTime> createdAt,
    });

final class $$WeightRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRecord> {
  $$WeightRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CatsTable _catIdTable(_$AppDatabase db) => db.cats.createAlias(
    $_aliasNameGenerator(db.weightRecords.catId, db.cats.id),
  );

  $$CatsTableProcessedTableManager get catId {
    final $_column = $_itemColumn<int>('cat_id')!;

    final manager = $$CatsTableTableManager(
      $_db,
      $_db.cats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeightRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodAnnotation => $composableBuilder(
    column: $table.moodAnnotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CatsTableFilterComposer get catId {
    final $$CatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableFilterComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodAnnotation => $composableBuilder(
    column: $table.moodAnnotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatsTableOrderingComposer get catId {
    final $$CatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableOrderingComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get moodAnnotation => $composableBuilder(
    column: $table.moodAnnotation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CatsTableAnnotationComposer get catId {
    final $$CatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableAnnotationComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightRecordsTable,
          WeightRecord,
          $$WeightRecordsTableFilterComposer,
          $$WeightRecordsTableOrderingComposer,
          $$WeightRecordsTableAnnotationComposer,
          $$WeightRecordsTableCreateCompanionBuilder,
          $$WeightRecordsTableUpdateCompanionBuilder,
          (WeightRecord, $$WeightRecordsTableReferences),
          WeightRecord,
          PrefetchHooks Function({bool catId})
        > {
  $$WeightRecordsTableTableManager(_$AppDatabase db, $WeightRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> catId = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String?> moodAnnotation = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WeightRecordsCompanion(
                id: id,
                catId: catId,
                weightKg: weightKg,
                moodAnnotation: moodAnnotation,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int catId,
                required double weightKg,
                Value<String?> moodAnnotation = const Value.absent(),
                required DateTime recordedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => WeightRecordsCompanion.insert(
                id: id,
                catId: catId,
                weightKg: weightKg,
                moodAnnotation: moodAnnotation,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeightRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable: $$WeightRecordsTableReferences
                                    ._catIdTable(db),
                                referencedColumn: $$WeightRecordsTableReferences
                                    ._catIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeightRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightRecordsTable,
      WeightRecord,
      $$WeightRecordsTableFilterComposer,
      $$WeightRecordsTableOrderingComposer,
      $$WeightRecordsTableAnnotationComposer,
      $$WeightRecordsTableCreateCompanionBuilder,
      $$WeightRecordsTableUpdateCompanionBuilder,
      (WeightRecord, $$WeightRecordsTableReferences),
      WeightRecord,
      PrefetchHooks Function({bool catId})
    >;
typedef $$DietRecordsTableCreateCompanionBuilder =
    DietRecordsCompanion Function({
      Value<int> id,
      required int catId,
      Value<String?> brandTag,
      required double amountGrams,
      required String foodType,
      required DateTime recordedAt,
      Value<DateTime> createdAt,
    });
typedef $$DietRecordsTableUpdateCompanionBuilder =
    DietRecordsCompanion Function({
      Value<int> id,
      Value<int> catId,
      Value<String?> brandTag,
      Value<double> amountGrams,
      Value<String> foodType,
      Value<DateTime> recordedAt,
      Value<DateTime> createdAt,
    });

final class $$DietRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $DietRecordsTable, DietRecord> {
  $$DietRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CatsTable _catIdTable(_$AppDatabase db) => db.cats.createAlias(
    $_aliasNameGenerator(db.dietRecords.catId, db.cats.id),
  );

  $$CatsTableProcessedTableManager get catId {
    final $_column = $_itemColumn<int>('cat_id')!;

    final manager = $$CatsTableTableManager(
      $_db,
      $_db.cats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DietRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DietRecordsTable> {
  $$DietRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandTag => $composableBuilder(
    column: $table.brandTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountGrams => $composableBuilder(
    column: $table.amountGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodType => $composableBuilder(
    column: $table.foodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CatsTableFilterComposer get catId {
    final $$CatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableFilterComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DietRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DietRecordsTable> {
  $$DietRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandTag => $composableBuilder(
    column: $table.brandTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountGrams => $composableBuilder(
    column: $table.amountGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodType => $composableBuilder(
    column: $table.foodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatsTableOrderingComposer get catId {
    final $$CatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableOrderingComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DietRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DietRecordsTable> {
  $$DietRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brandTag =>
      $composableBuilder(column: $table.brandTag, builder: (column) => column);

  GeneratedColumn<double> get amountGrams => $composableBuilder(
    column: $table.amountGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodType =>
      $composableBuilder(column: $table.foodType, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CatsTableAnnotationComposer get catId {
    final $$CatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableAnnotationComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DietRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DietRecordsTable,
          DietRecord,
          $$DietRecordsTableFilterComposer,
          $$DietRecordsTableOrderingComposer,
          $$DietRecordsTableAnnotationComposer,
          $$DietRecordsTableCreateCompanionBuilder,
          $$DietRecordsTableUpdateCompanionBuilder,
          (DietRecord, $$DietRecordsTableReferences),
          DietRecord,
          PrefetchHooks Function({bool catId})
        > {
  $$DietRecordsTableTableManager(_$AppDatabase db, $DietRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DietRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DietRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DietRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> catId = const Value.absent(),
                Value<String?> brandTag = const Value.absent(),
                Value<double> amountGrams = const Value.absent(),
                Value<String> foodType = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DietRecordsCompanion(
                id: id,
                catId: catId,
                brandTag: brandTag,
                amountGrams: amountGrams,
                foodType: foodType,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int catId,
                Value<String?> brandTag = const Value.absent(),
                required double amountGrams,
                required String foodType,
                required DateTime recordedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => DietRecordsCompanion.insert(
                id: id,
                catId: catId,
                brandTag: brandTag,
                amountGrams: amountGrams,
                foodType: foodType,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DietRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable: $$DietRecordsTableReferences
                                    ._catIdTable(db),
                                referencedColumn: $$DietRecordsTableReferences
                                    ._catIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DietRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DietRecordsTable,
      DietRecord,
      $$DietRecordsTableFilterComposer,
      $$DietRecordsTableOrderingComposer,
      $$DietRecordsTableAnnotationComposer,
      $$DietRecordsTableCreateCompanionBuilder,
      $$DietRecordsTableUpdateCompanionBuilder,
      (DietRecord, $$DietRecordsTableReferences),
      DietRecord,
      PrefetchHooks Function({bool catId})
    >;
typedef $$WaterRecordsTableCreateCompanionBuilder =
    WaterRecordsCompanion Function({
      Value<int> id,
      required int catId,
      required double amountMl,
      required DateTime recordedAt,
      Value<DateTime> createdAt,
    });
typedef $$WaterRecordsTableUpdateCompanionBuilder =
    WaterRecordsCompanion Function({
      Value<int> id,
      Value<int> catId,
      Value<double> amountMl,
      Value<DateTime> recordedAt,
      Value<DateTime> createdAt,
    });

final class $$WaterRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $WaterRecordsTable, WaterRecord> {
  $$WaterRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CatsTable _catIdTable(_$AppDatabase db) => db.cats.createAlias(
    $_aliasNameGenerator(db.waterRecords.catId, db.cats.id),
  );

  $$CatsTableProcessedTableManager get catId {
    final $_column = $_itemColumn<int>('cat_id')!;

    final manager = $$CatsTableTableManager(
      $_db,
      $_db.cats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WaterRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CatsTableFilterComposer get catId {
    final $$CatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableFilterComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatsTableOrderingComposer get catId {
    final $$CatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableOrderingComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CatsTableAnnotationComposer get catId {
    final $$CatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableAnnotationComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterRecordsTable,
          WaterRecord,
          $$WaterRecordsTableFilterComposer,
          $$WaterRecordsTableOrderingComposer,
          $$WaterRecordsTableAnnotationComposer,
          $$WaterRecordsTableCreateCompanionBuilder,
          $$WaterRecordsTableUpdateCompanionBuilder,
          (WaterRecord, $$WaterRecordsTableReferences),
          WaterRecord,
          PrefetchHooks Function({bool catId})
        > {
  $$WaterRecordsTableTableManager(_$AppDatabase db, $WaterRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> catId = const Value.absent(),
                Value<double> amountMl = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WaterRecordsCompanion(
                id: id,
                catId: catId,
                amountMl: amountMl,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int catId,
                required double amountMl,
                required DateTime recordedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => WaterRecordsCompanion.insert(
                id: id,
                catId: catId,
                amountMl: amountMl,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WaterRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable: $$WaterRecordsTableReferences
                                    ._catIdTable(db),
                                referencedColumn: $$WaterRecordsTableReferences
                                    ._catIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WaterRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterRecordsTable,
      WaterRecord,
      $$WaterRecordsTableFilterComposer,
      $$WaterRecordsTableOrderingComposer,
      $$WaterRecordsTableAnnotationComposer,
      $$WaterRecordsTableCreateCompanionBuilder,
      $$WaterRecordsTableUpdateCompanionBuilder,
      (WaterRecord, $$WaterRecordsTableReferences),
      WaterRecord,
      PrefetchHooks Function({bool catId})
    >;
typedef $$ExcretionRecordsTableCreateCompanionBuilder =
    ExcretionRecordsCompanion Function({
      Value<int> id,
      required int catId,
      required String excretionType,
      Value<int?> bristolScale,
      Value<int?> urineAmount,
      Value<bool> hasBlood,
      Value<bool> hasAnomaly,
      Value<String?> notes,
      required DateTime recordedAt,
      Value<DateTime> createdAt,
    });
typedef $$ExcretionRecordsTableUpdateCompanionBuilder =
    ExcretionRecordsCompanion Function({
      Value<int> id,
      Value<int> catId,
      Value<String> excretionType,
      Value<int?> bristolScale,
      Value<int?> urineAmount,
      Value<bool> hasBlood,
      Value<bool> hasAnomaly,
      Value<String?> notes,
      Value<DateTime> recordedAt,
      Value<DateTime> createdAt,
    });

final class $$ExcretionRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExcretionRecordsTable, ExcretionRecord> {
  $$ExcretionRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CatsTable _catIdTable(_$AppDatabase db) => db.cats.createAlias(
    $_aliasNameGenerator(db.excretionRecords.catId, db.cats.id),
  );

  $$CatsTableProcessedTableManager get catId {
    final $_column = $_itemColumn<int>('cat_id')!;

    final manager = $$CatsTableTableManager(
      $_db,
      $_db.cats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_catIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExcretionRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ExcretionRecordsTable> {
  $$ExcretionRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get excretionType => $composableBuilder(
    column: $table.excretionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bristolScale => $composableBuilder(
    column: $table.bristolScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urineAmount => $composableBuilder(
    column: $table.urineAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasBlood => $composableBuilder(
    column: $table.hasBlood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasAnomaly => $composableBuilder(
    column: $table.hasAnomaly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CatsTableFilterComposer get catId {
    final $$CatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableFilterComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExcretionRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExcretionRecordsTable> {
  $$ExcretionRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get excretionType => $composableBuilder(
    column: $table.excretionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bristolScale => $composableBuilder(
    column: $table.bristolScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urineAmount => $composableBuilder(
    column: $table.urineAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasBlood => $composableBuilder(
    column: $table.hasBlood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasAnomaly => $composableBuilder(
    column: $table.hasAnomaly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CatsTableOrderingComposer get catId {
    final $$CatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableOrderingComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExcretionRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExcretionRecordsTable> {
  $$ExcretionRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get excretionType => $composableBuilder(
    column: $table.excretionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bristolScale => $composableBuilder(
    column: $table.bristolScale,
    builder: (column) => column,
  );

  GeneratedColumn<int> get urineAmount => $composableBuilder(
    column: $table.urineAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasBlood =>
      $composableBuilder(column: $table.hasBlood, builder: (column) => column);

  GeneratedColumn<bool> get hasAnomaly => $composableBuilder(
    column: $table.hasAnomaly,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CatsTableAnnotationComposer get catId {
    final $$CatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.catId,
      referencedTable: $db.cats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatsTableAnnotationComposer(
            $db: $db,
            $table: $db.cats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExcretionRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExcretionRecordsTable,
          ExcretionRecord,
          $$ExcretionRecordsTableFilterComposer,
          $$ExcretionRecordsTableOrderingComposer,
          $$ExcretionRecordsTableAnnotationComposer,
          $$ExcretionRecordsTableCreateCompanionBuilder,
          $$ExcretionRecordsTableUpdateCompanionBuilder,
          (ExcretionRecord, $$ExcretionRecordsTableReferences),
          ExcretionRecord,
          PrefetchHooks Function({bool catId})
        > {
  $$ExcretionRecordsTableTableManager(
    _$AppDatabase db,
    $ExcretionRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExcretionRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExcretionRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExcretionRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> catId = const Value.absent(),
                Value<String> excretionType = const Value.absent(),
                Value<int?> bristolScale = const Value.absent(),
                Value<int?> urineAmount = const Value.absent(),
                Value<bool> hasBlood = const Value.absent(),
                Value<bool> hasAnomaly = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExcretionRecordsCompanion(
                id: id,
                catId: catId,
                excretionType: excretionType,
                bristolScale: bristolScale,
                urineAmount: urineAmount,
                hasBlood: hasBlood,
                hasAnomaly: hasAnomaly,
                notes: notes,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int catId,
                required String excretionType,
                Value<int?> bristolScale = const Value.absent(),
                Value<int?> urineAmount = const Value.absent(),
                Value<bool> hasBlood = const Value.absent(),
                Value<bool> hasAnomaly = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime recordedAt,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExcretionRecordsCompanion.insert(
                id: id,
                catId: catId,
                excretionType: excretionType,
                bristolScale: bristolScale,
                urineAmount: urineAmount,
                hasBlood: hasBlood,
                hasAnomaly: hasAnomaly,
                notes: notes,
                recordedAt: recordedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExcretionRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({catId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (catId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.catId,
                                referencedTable:
                                    $$ExcretionRecordsTableReferences
                                        ._catIdTable(db),
                                referencedColumn:
                                    $$ExcretionRecordsTableReferences
                                        ._catIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExcretionRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExcretionRecordsTable,
      ExcretionRecord,
      $$ExcretionRecordsTableFilterComposer,
      $$ExcretionRecordsTableOrderingComposer,
      $$ExcretionRecordsTableAnnotationComposer,
      $$ExcretionRecordsTableCreateCompanionBuilder,
      $$ExcretionRecordsTableUpdateCompanionBuilder,
      (ExcretionRecord, $$ExcretionRecordsTableReferences),
      ExcretionRecord,
      PrefetchHooks Function({bool catId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatsTableTableManager get cats => $$CatsTableTableManager(_db, _db.cats);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db, _db.weightRecords);
  $$DietRecordsTableTableManager get dietRecords =>
      $$DietRecordsTableTableManager(_db, _db.dietRecords);
  $$WaterRecordsTableTableManager get waterRecords =>
      $$WaterRecordsTableTableManager(_db, _db.waterRecords);
  $$ExcretionRecordsTableTableManager get excretionRecords =>
      $$ExcretionRecordsTableTableManager(_db, _db.excretionRecords);
}
