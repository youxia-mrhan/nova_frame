// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nova_database.dart';

// ignore_for_file: type=lint
class $ApiCacheTableTable extends ApiCacheTable
    with TableInfo<$ApiCacheTableTable, ApiCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expireAtMsMeta = const VerificationMeta(
    'expireAtMs',
  );
  @override
  late final GeneratedColumn<int> expireAtMs = GeneratedColumn<int>(
    'expire_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, json, updatedAtMs, expireAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_cache_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApiCacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('expire_at_ms')) {
      context.handle(
        _expireAtMsMeta,
        expireAtMs.isAcceptableOrUnknown(
          data['expire_at_ms']!,
          _expireAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  ApiCacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiCacheTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      expireAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expire_at_ms'],
      ),
    );
  }

  @override
  $ApiCacheTableTable createAlias(String alias) {
    return $ApiCacheTableTable(attachedDatabase, alias);
  }
}

class ApiCacheTableData extends DataClass
    implements Insertable<ApiCacheTableData> {
  final String key;
  final String json;
  final int updatedAtMs;
  final int? expireAtMs;
  const ApiCacheTableData({
    required this.key,
    required this.json,
    required this.updatedAtMs,
    this.expireAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['json'] = Variable<String>(json);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    if (!nullToAbsent || expireAtMs != null) {
      map['expire_at_ms'] = Variable<int>(expireAtMs);
    }
    return map;
  }

  ApiCacheTableCompanion toCompanion(bool nullToAbsent) {
    return ApiCacheTableCompanion(
      key: Value(key),
      json: Value(json),
      updatedAtMs: Value(updatedAtMs),
      expireAtMs: expireAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(expireAtMs),
    );
  }

  factory ApiCacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiCacheTableData(
      key: serializer.fromJson<String>(json['key']),
      json: serializer.fromJson<String>(json['json']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      expireAtMs: serializer.fromJson<int?>(json['expireAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'json': serializer.toJson<String>(json),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'expireAtMs': serializer.toJson<int?>(expireAtMs),
    };
  }

  ApiCacheTableData copyWith({
    String? key,
    String? json,
    int? updatedAtMs,
    Value<int?> expireAtMs = const Value.absent(),
  }) => ApiCacheTableData(
    key: key ?? this.key,
    json: json ?? this.json,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    expireAtMs: expireAtMs.present ? expireAtMs.value : this.expireAtMs,
  );
  ApiCacheTableData copyWithCompanion(ApiCacheTableCompanion data) {
    return ApiCacheTableData(
      key: data.key.present ? data.key.value : this.key,
      json: data.json.present ? data.json.value : this.json,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      expireAtMs: data.expireAtMs.present
          ? data.expireAtMs.value
          : this.expireAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiCacheTableData(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('expireAtMs: $expireAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, json, updatedAtMs, expireAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiCacheTableData &&
          other.key == this.key &&
          other.json == this.json &&
          other.updatedAtMs == this.updatedAtMs &&
          other.expireAtMs == this.expireAtMs);
}

class ApiCacheTableCompanion extends UpdateCompanion<ApiCacheTableData> {
  final Value<String> key;
  final Value<String> json;
  final Value<int> updatedAtMs;
  final Value<int?> expireAtMs;
  final Value<int> rowid;
  const ApiCacheTableCompanion({
    this.key = const Value.absent(),
    this.json = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.expireAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ApiCacheTableCompanion.insert({
    required String key,
    required String json,
    required int updatedAtMs,
    this.expireAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       json = Value(json),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<ApiCacheTableData> custom({
    Expression<String>? key,
    Expression<String>? json,
    Expression<int>? updatedAtMs,
    Expression<int>? expireAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (json != null) 'json': json,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (expireAtMs != null) 'expire_at_ms': expireAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ApiCacheTableCompanion copyWith({
    Value<String>? key,
    Value<String>? json,
    Value<int>? updatedAtMs,
    Value<int?>? expireAtMs,
    Value<int>? rowid,
  }) {
    return ApiCacheTableCompanion(
      key: key ?? this.key,
      json: json ?? this.json,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      expireAtMs: expireAtMs ?? this.expireAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (expireAtMs.present) {
      map['expire_at_ms'] = Variable<int>(expireAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiCacheTableCompanion(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('expireAtMs: $expireAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionTableTable extends SessionTable
    with TableInfo<$SessionTableTable, SessionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageLabelMeta = const VerificationMeta(
    'pageLabel',
  );
  @override
  late final GeneratedColumn<String> pageLabel = GeneratedColumn<String>(
    'page_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeTypeMeta = const VerificationMeta(
    'routeType',
  );
  @override
  late final GeneratedColumn<String> routeType = GeneratedColumn<String>(
    'route_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeKeyMeta = const VerificationMeta(
    'routeKey',
  );
  @override
  late final GeneratedColumn<String> routeKey = GeneratedColumn<String>(
    'route_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _routePathMeta = const VerificationMeta(
    'routePath',
  );
  @override
  late final GeneratedColumn<String> routePath = GeneratedColumn<String>(
    'route_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _entryRouteNavOpMeta = const VerificationMeta(
    'entryRouteNavOp',
  );
  @override
  late final GeneratedColumn<String> entryRouteNavOp = GeneratedColumn<String>(
    'entry_route_nav_op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('push'),
  );
  static const VerificationMeta _exitRouteNavOpMeta = const VerificationMeta(
    'exitRouteNavOp',
  );
  @override
  late final GeneratedColumn<String> exitRouteNavOp = GeneratedColumn<String>(
    'exit_route_nav_op',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enterAtMsMeta = const VerificationMeta(
    'enterAtMs',
  );
  @override
  late final GeneratedColumn<int> enterAtMs = GeneratedColumn<int>(
    'enter_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exitAtMsMeta = const VerificationMeta(
    'exitAtMs',
  );
  @override
  late final GeneratedColumn<int> exitAtMs = GeneratedColumn<int>(
    'exit_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    userId,
    pageLabel,
    routeType,
    routeKey,
    routePath,
    entryRouteNavOp,
    exitRouteNavOp,
    enterAtMs,
    exitAtMs,
    durationMs,
    schemaVersion,
    appVersion,
    platform,
    syncStatus,
    retryCount,
    lastError,
    createdAtMs,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'page_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('page_label')) {
      context.handle(
        _pageLabelMeta,
        pageLabel.isAcceptableOrUnknown(data['page_label']!, _pageLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_pageLabelMeta);
    }
    if (data.containsKey('route_type')) {
      context.handle(
        _routeTypeMeta,
        routeType.isAcceptableOrUnknown(data['route_type']!, _routeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_routeTypeMeta);
    }
    if (data.containsKey('route_key')) {
      context.handle(
        _routeKeyMeta,
        routeKey.isAcceptableOrUnknown(data['route_key']!, _routeKeyMeta),
      );
    }
    if (data.containsKey('route_path')) {
      context.handle(
        _routePathMeta,
        routePath.isAcceptableOrUnknown(data['route_path']!, _routePathMeta),
      );
    }
    if (data.containsKey('entry_route_nav_op')) {
      context.handle(
        _entryRouteNavOpMeta,
        entryRouteNavOp.isAcceptableOrUnknown(
          data['entry_route_nav_op']!,
          _entryRouteNavOpMeta,
        ),
      );
    }
    if (data.containsKey('exit_route_nav_op')) {
      context.handle(
        _exitRouteNavOpMeta,
        exitRouteNavOp.isAcceptableOrUnknown(
          data['exit_route_nav_op']!,
          _exitRouteNavOpMeta,
        ),
      );
    }
    if (data.containsKey('enter_at_ms')) {
      context.handle(
        _enterAtMsMeta,
        enterAtMs.isAcceptableOrUnknown(data['enter_at_ms']!, _enterAtMsMeta),
      );
    } else if (isInserting) {
      context.missing(_enterAtMsMeta);
    }
    if (data.containsKey('exit_at_ms')) {
      context.handle(
        _exitAtMsMeta,
        exitAtMs.isAcceptableOrUnknown(data['exit_at_ms']!, _exitAtMsMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  SessionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionTableData(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      pageLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}page_label'],
      )!,
      routeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_type'],
      )!,
      routeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_key'],
      ),
      routePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_path'],
      )!,
      entryRouteNavOp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_route_nav_op'],
      )!,
      exitRouteNavOp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exit_route_nav_op'],
      ),
      enterAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enter_at_ms'],
      )!,
      exitAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exit_at_ms'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      ),
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $SessionTableTable createAlias(String alias) {
    return $SessionTableTable(attachedDatabase, alias);
  }
}

class SessionTableData extends DataClass
    implements Insertable<SessionTableData> {
  final String sessionId;
  final String? userId;
  final String pageLabel;
  final String routeType;
  final String? routeKey;
  final String routePath;
  final String entryRouteNavOp;
  final String? exitRouteNavOp;
  final int enterAtMs;
  final int? exitAtMs;
  final int? durationMs;
  final int schemaVersion;
  final String? appVersion;
  final String? platform;
  final int syncStatus;
  final int retryCount;
  final String? lastError;
  final int createdAtMs;
  final int updatedAtMs;
  const SessionTableData({
    required this.sessionId,
    this.userId,
    required this.pageLabel,
    required this.routeType,
    this.routeKey,
    required this.routePath,
    required this.entryRouteNavOp,
    this.exitRouteNavOp,
    required this.enterAtMs,
    this.exitAtMs,
    this.durationMs,
    required this.schemaVersion,
    this.appVersion,
    this.platform,
    required this.syncStatus,
    required this.retryCount,
    this.lastError,
    required this.createdAtMs,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['page_label'] = Variable<String>(pageLabel);
    map['route_type'] = Variable<String>(routeType);
    if (!nullToAbsent || routeKey != null) {
      map['route_key'] = Variable<String>(routeKey);
    }
    map['route_path'] = Variable<String>(routePath);
    map['entry_route_nav_op'] = Variable<String>(entryRouteNavOp);
    if (!nullToAbsent || exitRouteNavOp != null) {
      map['exit_route_nav_op'] = Variable<String>(exitRouteNavOp);
    }
    map['enter_at_ms'] = Variable<int>(enterAtMs);
    if (!nullToAbsent || exitAtMs != null) {
      map['exit_at_ms'] = Variable<int>(exitAtMs);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['schema_version'] = Variable<int>(schemaVersion);
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String>(appVersion);
    }
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(platform);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  SessionTableCompanion toCompanion(bool nullToAbsent) {
    return SessionTableCompanion(
      sessionId: Value(sessionId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      pageLabel: Value(pageLabel),
      routeType: Value(routeType),
      routeKey: routeKey == null && nullToAbsent
          ? const Value.absent()
          : Value(routeKey),
      routePath: Value(routePath),
      entryRouteNavOp: Value(entryRouteNavOp),
      exitRouteNavOp: exitRouteNavOp == null && nullToAbsent
          ? const Value.absent()
          : Value(exitRouteNavOp),
      enterAtMs: Value(enterAtMs),
      exitAtMs: exitAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(exitAtMs),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      schemaVersion: Value(schemaVersion),
      appVersion: appVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(appVersion),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      syncStatus: Value(syncStatus),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAtMs: Value(createdAtMs),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory SessionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionTableData(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      userId: serializer.fromJson<String?>(json['userId']),
      pageLabel: serializer.fromJson<String>(json['pageLabel']),
      routeType: serializer.fromJson<String>(json['routeType']),
      routeKey: serializer.fromJson<String?>(json['routeKey']),
      routePath: serializer.fromJson<String>(json['routePath']),
      entryRouteNavOp: serializer.fromJson<String>(json['entryRouteNavOp']),
      exitRouteNavOp: serializer.fromJson<String?>(json['exitRouteNavOp']),
      enterAtMs: serializer.fromJson<int>(json['enterAtMs']),
      exitAtMs: serializer.fromJson<int?>(json['exitAtMs']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      appVersion: serializer.fromJson<String?>(json['appVersion']),
      platform: serializer.fromJson<String?>(json['platform']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'userId': serializer.toJson<String?>(userId),
      'pageLabel': serializer.toJson<String>(pageLabel),
      'routeType': serializer.toJson<String>(routeType),
      'routeKey': serializer.toJson<String?>(routeKey),
      'routePath': serializer.toJson<String>(routePath),
      'entryRouteNavOp': serializer.toJson<String>(entryRouteNavOp),
      'exitRouteNavOp': serializer.toJson<String?>(exitRouteNavOp),
      'enterAtMs': serializer.toJson<int>(enterAtMs),
      'exitAtMs': serializer.toJson<int?>(exitAtMs),
      'durationMs': serializer.toJson<int?>(durationMs),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'appVersion': serializer.toJson<String?>(appVersion),
      'platform': serializer.toJson<String?>(platform),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  SessionTableData copyWith({
    String? sessionId,
    Value<String?> userId = const Value.absent(),
    String? pageLabel,
    String? routeType,
    Value<String?> routeKey = const Value.absent(),
    String? routePath,
    String? entryRouteNavOp,
    Value<String?> exitRouteNavOp = const Value.absent(),
    int? enterAtMs,
    Value<int?> exitAtMs = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    int? schemaVersion,
    Value<String?> appVersion = const Value.absent(),
    Value<String?> platform = const Value.absent(),
    int? syncStatus,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    int? createdAtMs,
    int? updatedAtMs,
  }) => SessionTableData(
    sessionId: sessionId ?? this.sessionId,
    userId: userId.present ? userId.value : this.userId,
    pageLabel: pageLabel ?? this.pageLabel,
    routeType: routeType ?? this.routeType,
    routeKey: routeKey.present ? routeKey.value : this.routeKey,
    routePath: routePath ?? this.routePath,
    entryRouteNavOp: entryRouteNavOp ?? this.entryRouteNavOp,
    exitRouteNavOp: exitRouteNavOp.present
        ? exitRouteNavOp.value
        : this.exitRouteNavOp,
    enterAtMs: enterAtMs ?? this.enterAtMs,
    exitAtMs: exitAtMs.present ? exitAtMs.value : this.exitAtMs,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    appVersion: appVersion.present ? appVersion.value : this.appVersion,
    platform: platform.present ? platform.value : this.platform,
    syncStatus: syncStatus ?? this.syncStatus,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  SessionTableData copyWithCompanion(SessionTableCompanion data) {
    return SessionTableData(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      pageLabel: data.pageLabel.present ? data.pageLabel.value : this.pageLabel,
      routeType: data.routeType.present ? data.routeType.value : this.routeType,
      routeKey: data.routeKey.present ? data.routeKey.value : this.routeKey,
      routePath: data.routePath.present ? data.routePath.value : this.routePath,
      entryRouteNavOp: data.entryRouteNavOp.present
          ? data.entryRouteNavOp.value
          : this.entryRouteNavOp,
      exitRouteNavOp: data.exitRouteNavOp.present
          ? data.exitRouteNavOp.value
          : this.exitRouteNavOp,
      enterAtMs: data.enterAtMs.present ? data.enterAtMs.value : this.enterAtMs,
      exitAtMs: data.exitAtMs.present ? data.exitAtMs.value : this.exitAtMs,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      platform: data.platform.present ? data.platform.value : this.platform,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionTableData(')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('pageLabel: $pageLabel, ')
          ..write('routeType: $routeType, ')
          ..write('routeKey: $routeKey, ')
          ..write('routePath: $routePath, ')
          ..write('entryRouteNavOp: $entryRouteNavOp, ')
          ..write('exitRouteNavOp: $exitRouteNavOp, ')
          ..write('enterAtMs: $enterAtMs, ')
          ..write('exitAtMs: $exitAtMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('appVersion: $appVersion, ')
          ..write('platform: $platform, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    userId,
    pageLabel,
    routeType,
    routeKey,
    routePath,
    entryRouteNavOp,
    exitRouteNavOp,
    enterAtMs,
    exitAtMs,
    durationMs,
    schemaVersion,
    appVersion,
    platform,
    syncStatus,
    retryCount,
    lastError,
    createdAtMs,
    updatedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionTableData &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.pageLabel == this.pageLabel &&
          other.routeType == this.routeType &&
          other.routeKey == this.routeKey &&
          other.routePath == this.routePath &&
          other.entryRouteNavOp == this.entryRouteNavOp &&
          other.exitRouteNavOp == this.exitRouteNavOp &&
          other.enterAtMs == this.enterAtMs &&
          other.exitAtMs == this.exitAtMs &&
          other.durationMs == this.durationMs &&
          other.schemaVersion == this.schemaVersion &&
          other.appVersion == this.appVersion &&
          other.platform == this.platform &&
          other.syncStatus == this.syncStatus &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAtMs == this.createdAtMs &&
          other.updatedAtMs == this.updatedAtMs);
}

class SessionTableCompanion extends UpdateCompanion<SessionTableData> {
  final Value<String> sessionId;
  final Value<String?> userId;
  final Value<String> pageLabel;
  final Value<String> routeType;
  final Value<String?> routeKey;
  final Value<String> routePath;
  final Value<String> entryRouteNavOp;
  final Value<String?> exitRouteNavOp;
  final Value<int> enterAtMs;
  final Value<int?> exitAtMs;
  final Value<int?> durationMs;
  final Value<int> schemaVersion;
  final Value<String?> appVersion;
  final Value<String?> platform;
  final Value<int> syncStatus;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<int> createdAtMs;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const SessionTableCompanion({
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.pageLabel = const Value.absent(),
    this.routeType = const Value.absent(),
    this.routeKey = const Value.absent(),
    this.routePath = const Value.absent(),
    this.entryRouteNavOp = const Value.absent(),
    this.exitRouteNavOp = const Value.absent(),
    this.enterAtMs = const Value.absent(),
    this.exitAtMs = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.platform = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionTableCompanion.insert({
    required String sessionId,
    this.userId = const Value.absent(),
    required String pageLabel,
    required String routeType,
    this.routeKey = const Value.absent(),
    this.routePath = const Value.absent(),
    this.entryRouteNavOp = const Value.absent(),
    this.exitRouteNavOp = const Value.absent(),
    required int enterAtMs,
    this.exitAtMs = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.platform = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required int createdAtMs,
    required int updatedAtMs,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       pageLabel = Value(pageLabel),
       routeType = Value(routeType),
       enterAtMs = Value(enterAtMs),
       createdAtMs = Value(createdAtMs),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<SessionTableData> custom({
    Expression<String>? sessionId,
    Expression<String>? userId,
    Expression<String>? pageLabel,
    Expression<String>? routeType,
    Expression<String>? routeKey,
    Expression<String>? routePath,
    Expression<String>? entryRouteNavOp,
    Expression<String>? exitRouteNavOp,
    Expression<int>? enterAtMs,
    Expression<int>? exitAtMs,
    Expression<int>? durationMs,
    Expression<int>? schemaVersion,
    Expression<String>? appVersion,
    Expression<String>? platform,
    Expression<int>? syncStatus,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<int>? createdAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (pageLabel != null) 'page_label': pageLabel,
      if (routeType != null) 'route_type': routeType,
      if (routeKey != null) 'route_key': routeKey,
      if (routePath != null) 'route_path': routePath,
      if (entryRouteNavOp != null) 'entry_route_nav_op': entryRouteNavOp,
      if (exitRouteNavOp != null) 'exit_route_nav_op': exitRouteNavOp,
      if (enterAtMs != null) 'enter_at_ms': enterAtMs,
      if (exitAtMs != null) 'exit_at_ms': exitAtMs,
      if (durationMs != null) 'duration_ms': durationMs,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (appVersion != null) 'app_version': appVersion,
      if (platform != null) 'platform': platform,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionTableCompanion copyWith({
    Value<String>? sessionId,
    Value<String?>? userId,
    Value<String>? pageLabel,
    Value<String>? routeType,
    Value<String?>? routeKey,
    Value<String>? routePath,
    Value<String>? entryRouteNavOp,
    Value<String?>? exitRouteNavOp,
    Value<int>? enterAtMs,
    Value<int?>? exitAtMs,
    Value<int?>? durationMs,
    Value<int>? schemaVersion,
    Value<String?>? appVersion,
    Value<String?>? platform,
    Value<int>? syncStatus,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<int>? createdAtMs,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return SessionTableCompanion(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      pageLabel: pageLabel ?? this.pageLabel,
      routeType: routeType ?? this.routeType,
      routeKey: routeKey ?? this.routeKey,
      routePath: routePath ?? this.routePath,
      entryRouteNavOp: entryRouteNavOp ?? this.entryRouteNavOp,
      exitRouteNavOp: exitRouteNavOp ?? this.exitRouteNavOp,
      enterAtMs: enterAtMs ?? this.enterAtMs,
      exitAtMs: exitAtMs ?? this.exitAtMs,
      durationMs: durationMs ?? this.durationMs,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      appVersion: appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (pageLabel.present) {
      map['page_label'] = Variable<String>(pageLabel.value);
    }
    if (routeType.present) {
      map['route_type'] = Variable<String>(routeType.value);
    }
    if (routeKey.present) {
      map['route_key'] = Variable<String>(routeKey.value);
    }
    if (routePath.present) {
      map['route_path'] = Variable<String>(routePath.value);
    }
    if (entryRouteNavOp.present) {
      map['entry_route_nav_op'] = Variable<String>(entryRouteNavOp.value);
    }
    if (exitRouteNavOp.present) {
      map['exit_route_nav_op'] = Variable<String>(exitRouteNavOp.value);
    }
    if (enterAtMs.present) {
      map['enter_at_ms'] = Variable<int>(enterAtMs.value);
    }
    if (exitAtMs.present) {
      map['exit_at_ms'] = Variable<int>(exitAtMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionTableCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('pageLabel: $pageLabel, ')
          ..write('routeType: $routeType, ')
          ..write('routeKey: $routeKey, ')
          ..write('routePath: $routePath, ')
          ..write('entryRouteNavOp: $entryRouteNavOp, ')
          ..write('exitRouteNavOp: $exitRouteNavOp, ')
          ..write('enterAtMs: $enterAtMs, ')
          ..write('exitAtMs: $exitAtMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('appVersion: $appVersion, ')
          ..write('platform: $platform, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionActionTableTable extends SessionActionTable
    with TableInfo<$SessionActionTableTable, SessionActionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionActionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES page_sessions (session_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _actionIndexMeta = const VerificationMeta(
    'actionIndex',
  );
  @override
  late final GeneratedColumn<int> actionIndex = GeneratedColumn<int>(
    'action_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descMeta = const VerificationMeta('desc');
  @override
  late final GeneratedColumn<String> desc = GeneratedColumn<String>(
    'desc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createTimeMsMeta = const VerificationMeta(
    'createTimeMs',
  );
  @override
  late final GeneratedColumn<int> createTimeMs = GeneratedColumn<int>(
    'create_time_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    actionIndex,
    label,
    result,
    desc,
    createTimeMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'page_session_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionActionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('action_index')) {
      context.handle(
        _actionIndexMeta,
        actionIndex.isAcceptableOrUnknown(
          data['action_index']!,
          _actionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actionIndexMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('desc')) {
      context.handle(
        _descMeta,
        desc.isAcceptableOrUnknown(data['desc']!, _descMeta),
      );
    } else if (isInserting) {
      context.missing(_descMeta);
    }
    if (data.containsKey('create_time_ms')) {
      context.handle(
        _createTimeMsMeta,
        createTimeMs.isAcceptableOrUnknown(
          data['create_time_ms']!,
          _createTimeMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createTimeMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionId, actionIndex},
  ];
  @override
  SessionActionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionActionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      actionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}action_index'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      desc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc'],
      )!,
      createTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}create_time_ms'],
      )!,
    );
  }

  @override
  $SessionActionTableTable createAlias(String alias) {
    return $SessionActionTableTable(attachedDatabase, alias);
  }
}

class SessionActionTableData extends DataClass
    implements Insertable<SessionActionTableData> {
  final int id;
  final String sessionId;
  final int actionIndex;
  final String label;
  final String result;
  final String desc;
  final int createTimeMs;
  const SessionActionTableData({
    required this.id,
    required this.sessionId,
    required this.actionIndex,
    required this.label,
    required this.result,
    required this.desc,
    required this.createTimeMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['action_index'] = Variable<int>(actionIndex);
    map['label'] = Variable<String>(label);
    map['result'] = Variable<String>(result);
    map['desc'] = Variable<String>(desc);
    map['create_time_ms'] = Variable<int>(createTimeMs);
    return map;
  }

  SessionActionTableCompanion toCompanion(bool nullToAbsent) {
    return SessionActionTableCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      actionIndex: Value(actionIndex),
      label: Value(label),
      result: Value(result),
      desc: Value(desc),
      createTimeMs: Value(createTimeMs),
    );
  }

  factory SessionActionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionActionTableData(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      actionIndex: serializer.fromJson<int>(json['actionIndex']),
      label: serializer.fromJson<String>(json['label']),
      result: serializer.fromJson<String>(json['result']),
      desc: serializer.fromJson<String>(json['desc']),
      createTimeMs: serializer.fromJson<int>(json['createTimeMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'actionIndex': serializer.toJson<int>(actionIndex),
      'label': serializer.toJson<String>(label),
      'result': serializer.toJson<String>(result),
      'desc': serializer.toJson<String>(desc),
      'createTimeMs': serializer.toJson<int>(createTimeMs),
    };
  }

  SessionActionTableData copyWith({
    int? id,
    String? sessionId,
    int? actionIndex,
    String? label,
    String? result,
    String? desc,
    int? createTimeMs,
  }) => SessionActionTableData(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    actionIndex: actionIndex ?? this.actionIndex,
    label: label ?? this.label,
    result: result ?? this.result,
    desc: desc ?? this.desc,
    createTimeMs: createTimeMs ?? this.createTimeMs,
  );
  SessionActionTableData copyWithCompanion(SessionActionTableCompanion data) {
    return SessionActionTableData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      actionIndex: data.actionIndex.present
          ? data.actionIndex.value
          : this.actionIndex,
      label: data.label.present ? data.label.value : this.label,
      result: data.result.present ? data.result.value : this.result,
      desc: data.desc.present ? data.desc.value : this.desc,
      createTimeMs: data.createTimeMs.present
          ? data.createTimeMs.value
          : this.createTimeMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionActionTableData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('actionIndex: $actionIndex, ')
          ..write('label: $label, ')
          ..write('result: $result, ')
          ..write('desc: $desc, ')
          ..write('createTimeMs: $createTimeMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    actionIndex,
    label,
    result,
    desc,
    createTimeMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionActionTableData &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.actionIndex == this.actionIndex &&
          other.label == this.label &&
          other.result == this.result &&
          other.desc == this.desc &&
          other.createTimeMs == this.createTimeMs);
}

class SessionActionTableCompanion
    extends UpdateCompanion<SessionActionTableData> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> actionIndex;
  final Value<String> label;
  final Value<String> result;
  final Value<String> desc;
  final Value<int> createTimeMs;
  const SessionActionTableCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.actionIndex = const Value.absent(),
    this.label = const Value.absent(),
    this.result = const Value.absent(),
    this.desc = const Value.absent(),
    this.createTimeMs = const Value.absent(),
  });
  SessionActionTableCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int actionIndex,
    required String label,
    required String result,
    required String desc,
    required int createTimeMs,
  }) : sessionId = Value(sessionId),
       actionIndex = Value(actionIndex),
       label = Value(label),
       result = Value(result),
       desc = Value(desc),
       createTimeMs = Value(createTimeMs);
  static Insertable<SessionActionTableData> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? actionIndex,
    Expression<String>? label,
    Expression<String>? result,
    Expression<String>? desc,
    Expression<int>? createTimeMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (actionIndex != null) 'action_index': actionIndex,
      if (label != null) 'label': label,
      if (result != null) 'result': result,
      if (desc != null) 'desc': desc,
      if (createTimeMs != null) 'create_time_ms': createTimeMs,
    });
  }

  SessionActionTableCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<int>? actionIndex,
    Value<String>? label,
    Value<String>? result,
    Value<String>? desc,
    Value<int>? createTimeMs,
  }) {
    return SessionActionTableCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      actionIndex: actionIndex ?? this.actionIndex,
      label: label ?? this.label,
      result: result ?? this.result,
      desc: desc ?? this.desc,
      createTimeMs: createTimeMs ?? this.createTimeMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (actionIndex.present) {
      map['action_index'] = Variable<int>(actionIndex.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (desc.present) {
      map['desc'] = Variable<String>(desc.value);
    }
    if (createTimeMs.present) {
      map['create_time_ms'] = Variable<int>(createTimeMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionActionTableCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('actionIndex: $actionIndex, ')
          ..write('label: $label, ')
          ..write('result: $result, ')
          ..write('desc: $desc, ')
          ..write('createTimeMs: $createTimeMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$NovaDatabase extends GeneratedDatabase {
  _$NovaDatabase(QueryExecutor e) : super(e);
  $NovaDatabaseManager get managers => $NovaDatabaseManager(this);
  late final $ApiCacheTableTable apiCacheTable = $ApiCacheTableTable(this);
  late final $SessionTableTable sessionTable = $SessionTableTable(this);
  late final $SessionActionTableTable sessionActionTable =
      $SessionActionTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    apiCacheTable,
    sessionTable,
    sessionActionTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'page_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('page_session_actions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ApiCacheTableTableCreateCompanionBuilder =
    ApiCacheTableCompanion Function({
      required String key,
      required String json,
      required int updatedAtMs,
      Value<int?> expireAtMs,
      Value<int> rowid,
    });
typedef $$ApiCacheTableTableUpdateCompanionBuilder =
    ApiCacheTableCompanion Function({
      Value<String> key,
      Value<String> json,
      Value<int> updatedAtMs,
      Value<int?> expireAtMs,
      Value<int> rowid,
    });

class $$ApiCacheTableTableFilterComposer
    extends Composer<_$NovaDatabase, $ApiCacheTableTable> {
  $$ApiCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expireAtMs => $composableBuilder(
    column: $table.expireAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApiCacheTableTableOrderingComposer
    extends Composer<_$NovaDatabase, $ApiCacheTableTable> {
  $$ApiCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expireAtMs => $composableBuilder(
    column: $table.expireAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApiCacheTableTableAnnotationComposer
    extends Composer<_$NovaDatabase, $ApiCacheTableTable> {
  $$ApiCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expireAtMs => $composableBuilder(
    column: $table.expireAtMs,
    builder: (column) => column,
  );
}

class $$ApiCacheTableTableTableManager
    extends
        RootTableManager<
          _$NovaDatabase,
          $ApiCacheTableTable,
          ApiCacheTableData,
          $$ApiCacheTableTableFilterComposer,
          $$ApiCacheTableTableOrderingComposer,
          $$ApiCacheTableTableAnnotationComposer,
          $$ApiCacheTableTableCreateCompanionBuilder,
          $$ApiCacheTableTableUpdateCompanionBuilder,
          (
            ApiCacheTableData,
            BaseReferences<
              _$NovaDatabase,
              $ApiCacheTableTable,
              ApiCacheTableData
            >,
          ),
          ApiCacheTableData,
          PrefetchHooks Function()
        > {
  $$ApiCacheTableTableTableManager(_$NovaDatabase db, $ApiCacheTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiCacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int?> expireAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApiCacheTableCompanion(
                key: key,
                json: json,
                updatedAtMs: updatedAtMs,
                expireAtMs: expireAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String json,
                required int updatedAtMs,
                Value<int?> expireAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ApiCacheTableCompanion.insert(
                key: key,
                json: json,
                updatedAtMs: updatedAtMs,
                expireAtMs: expireAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApiCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$NovaDatabase,
      $ApiCacheTableTable,
      ApiCacheTableData,
      $$ApiCacheTableTableFilterComposer,
      $$ApiCacheTableTableOrderingComposer,
      $$ApiCacheTableTableAnnotationComposer,
      $$ApiCacheTableTableCreateCompanionBuilder,
      $$ApiCacheTableTableUpdateCompanionBuilder,
      (
        ApiCacheTableData,
        BaseReferences<_$NovaDatabase, $ApiCacheTableTable, ApiCacheTableData>,
      ),
      ApiCacheTableData,
      PrefetchHooks Function()
    >;
typedef $$SessionTableTableCreateCompanionBuilder =
    SessionTableCompanion Function({
      required String sessionId,
      Value<String?> userId,
      required String pageLabel,
      required String routeType,
      Value<String?> routeKey,
      Value<String> routePath,
      Value<String> entryRouteNavOp,
      Value<String?> exitRouteNavOp,
      required int enterAtMs,
      Value<int?> exitAtMs,
      Value<int?> durationMs,
      Value<int> schemaVersion,
      Value<String?> appVersion,
      Value<String?> platform,
      Value<int> syncStatus,
      Value<int> retryCount,
      Value<String?> lastError,
      required int createdAtMs,
      required int updatedAtMs,
      Value<int> rowid,
    });
typedef $$SessionTableTableUpdateCompanionBuilder =
    SessionTableCompanion Function({
      Value<String> sessionId,
      Value<String?> userId,
      Value<String> pageLabel,
      Value<String> routeType,
      Value<String?> routeKey,
      Value<String> routePath,
      Value<String> entryRouteNavOp,
      Value<String?> exitRouteNavOp,
      Value<int> enterAtMs,
      Value<int?> exitAtMs,
      Value<int?> durationMs,
      Value<int> schemaVersion,
      Value<String?> appVersion,
      Value<String?> platform,
      Value<int> syncStatus,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<int> createdAtMs,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });

final class $$SessionTableTableReferences
    extends
        BaseReferences<_$NovaDatabase, $SessionTableTable, SessionTableData> {
  $$SessionTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $SessionActionTableTable,
    List<SessionActionTableData>
  >
  _sessionActionTableRefsTable(_$NovaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sessionActionTable,
        aliasName: $_aliasNameGenerator(
          db.sessionTable.sessionId,
          db.sessionActionTable.sessionId,
        ),
      );

  $$SessionActionTableTableProcessedTableManager get sessionActionTableRefs {
    final manager =
        $$SessionActionTableTableTableManager(
          $_db,
          $_db.sessionActionTable,
        ).filter(
          (f) => f.sessionId.sessionId.sqlEquals(
            $_itemColumn<String>('session_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _sessionActionTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionTableTableFilterComposer
    extends Composer<_$NovaDatabase, $SessionTableTable> {
  $$SessionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pageLabel => $composableBuilder(
    column: $table.pageLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeType => $composableBuilder(
    column: $table.routeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeKey => $composableBuilder(
    column: $table.routeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routePath => $composableBuilder(
    column: $table.routePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryRouteNavOp => $composableBuilder(
    column: $table.entryRouteNavOp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exitRouteNavOp => $composableBuilder(
    column: $table.exitRouteNavOp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get enterAtMs => $composableBuilder(
    column: $table.enterAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exitAtMs => $composableBuilder(
    column: $table.exitAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionActionTableRefs(
    Expression<bool> Function($$SessionActionTableTableFilterComposer f) f,
  ) {
    final $$SessionActionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionActionTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionActionTableTableFilterComposer(
            $db: $db,
            $table: $db.sessionActionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionTableTableOrderingComposer
    extends Composer<_$NovaDatabase, $SessionTableTable> {
  $$SessionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pageLabel => $composableBuilder(
    column: $table.pageLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeType => $composableBuilder(
    column: $table.routeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeKey => $composableBuilder(
    column: $table.routeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routePath => $composableBuilder(
    column: $table.routePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryRouteNavOp => $composableBuilder(
    column: $table.entryRouteNavOp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exitRouteNavOp => $composableBuilder(
    column: $table.exitRouteNavOp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enterAtMs => $composableBuilder(
    column: $table.enterAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exitAtMs => $composableBuilder(
    column: $table.exitAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionTableTableAnnotationComposer
    extends Composer<_$NovaDatabase, $SessionTableTable> {
  $$SessionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get pageLabel =>
      $composableBuilder(column: $table.pageLabel, builder: (column) => column);

  GeneratedColumn<String> get routeType =>
      $composableBuilder(column: $table.routeType, builder: (column) => column);

  GeneratedColumn<String> get routeKey =>
      $composableBuilder(column: $table.routeKey, builder: (column) => column);

  GeneratedColumn<String> get routePath =>
      $composableBuilder(column: $table.routePath, builder: (column) => column);

  GeneratedColumn<String> get entryRouteNavOp => $composableBuilder(
    column: $table.entryRouteNavOp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exitRouteNavOp => $composableBuilder(
    column: $table.exitRouteNavOp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get enterAtMs =>
      $composableBuilder(column: $table.enterAtMs, builder: (column) => column);

  GeneratedColumn<int> get exitAtMs =>
      $composableBuilder(column: $table.exitAtMs, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  Expression<T> sessionActionTableRefs<T extends Object>(
    Expression<T> Function($$SessionActionTableTableAnnotationComposer a) f,
  ) {
    final $$SessionActionTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.sessionActionTable,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SessionActionTableTableAnnotationComposer(
                $db: $db,
                $table: $db.sessionActionTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SessionTableTableTableManager
    extends
        RootTableManager<
          _$NovaDatabase,
          $SessionTableTable,
          SessionTableData,
          $$SessionTableTableFilterComposer,
          $$SessionTableTableOrderingComposer,
          $$SessionTableTableAnnotationComposer,
          $$SessionTableTableCreateCompanionBuilder,
          $$SessionTableTableUpdateCompanionBuilder,
          (SessionTableData, $$SessionTableTableReferences),
          SessionTableData,
          PrefetchHooks Function({bool sessionActionTableRefs})
        > {
  $$SessionTableTableTableManager(_$NovaDatabase db, $SessionTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> pageLabel = const Value.absent(),
                Value<String> routeType = const Value.absent(),
                Value<String?> routeKey = const Value.absent(),
                Value<String> routePath = const Value.absent(),
                Value<String> entryRouteNavOp = const Value.absent(),
                Value<String?> exitRouteNavOp = const Value.absent(),
                Value<int> enterAtMs = const Value.absent(),
                Value<int?> exitAtMs = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<String?> appVersion = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionTableCompanion(
                sessionId: sessionId,
                userId: userId,
                pageLabel: pageLabel,
                routeType: routeType,
                routeKey: routeKey,
                routePath: routePath,
                entryRouteNavOp: entryRouteNavOp,
                exitRouteNavOp: exitRouteNavOp,
                enterAtMs: enterAtMs,
                exitAtMs: exitAtMs,
                durationMs: durationMs,
                schemaVersion: schemaVersion,
                appVersion: appVersion,
                platform: platform,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastError: lastError,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                Value<String?> userId = const Value.absent(),
                required String pageLabel,
                required String routeType,
                Value<String?> routeKey = const Value.absent(),
                Value<String> routePath = const Value.absent(),
                Value<String> entryRouteNavOp = const Value.absent(),
                Value<String?> exitRouteNavOp = const Value.absent(),
                required int enterAtMs,
                Value<int?> exitAtMs = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<String?> appVersion = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required int createdAtMs,
                required int updatedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => SessionTableCompanion.insert(
                sessionId: sessionId,
                userId: userId,
                pageLabel: pageLabel,
                routeType: routeType,
                routeKey: routeKey,
                routePath: routePath,
                entryRouteNavOp: entryRouteNavOp,
                exitRouteNavOp: exitRouteNavOp,
                enterAtMs: enterAtMs,
                exitAtMs: exitAtMs,
                durationMs: durationMs,
                schemaVersion: schemaVersion,
                appVersion: appVersion,
                platform: platform,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastError: lastError,
                createdAtMs: createdAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionActionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionActionTableRefs) db.sessionActionTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionActionTableRefs)
                    await $_getPrefetchedData<
                      SessionTableData,
                      $SessionTableTable,
                      SessionActionTableData
                    >(
                      currentTable: table,
                      referencedTable: $$SessionTableTableReferences
                          ._sessionActionTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SessionTableTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionActionTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.sessionId == item.sessionId,
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

typedef $$SessionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$NovaDatabase,
      $SessionTableTable,
      SessionTableData,
      $$SessionTableTableFilterComposer,
      $$SessionTableTableOrderingComposer,
      $$SessionTableTableAnnotationComposer,
      $$SessionTableTableCreateCompanionBuilder,
      $$SessionTableTableUpdateCompanionBuilder,
      (SessionTableData, $$SessionTableTableReferences),
      SessionTableData,
      PrefetchHooks Function({bool sessionActionTableRefs})
    >;
typedef $$SessionActionTableTableCreateCompanionBuilder =
    SessionActionTableCompanion Function({
      Value<int> id,
      required String sessionId,
      required int actionIndex,
      required String label,
      required String result,
      required String desc,
      required int createTimeMs,
    });
typedef $$SessionActionTableTableUpdateCompanionBuilder =
    SessionActionTableCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<int> actionIndex,
      Value<String> label,
      Value<String> result,
      Value<String> desc,
      Value<int> createTimeMs,
    });

final class $$SessionActionTableTableReferences
    extends
        BaseReferences<
          _$NovaDatabase,
          $SessionActionTableTable,
          SessionActionTableData
        > {
  $$SessionActionTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionTableTable _sessionIdTable(_$NovaDatabase db) =>
      db.sessionTable.createAlias(
        $_aliasNameGenerator(
          db.sessionActionTable.sessionId,
          db.sessionTable.sessionId,
        ),
      );

  $$SessionTableTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionTableTableTableManager(
      $_db,
      $_db.sessionTable,
    ).filter((f) => f.sessionId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionActionTableTableFilterComposer
    extends Composer<_$NovaDatabase, $SessionActionTableTable> {
  $$SessionActionTableTableFilterComposer({
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

  ColumnFilters<int> get actionIndex => $composableBuilder(
    column: $table.actionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get desc => $composableBuilder(
    column: $table.desc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createTimeMs => $composableBuilder(
    column: $table.createTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionTableTableFilterComposer get sessionId {
    final $$SessionTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableFilterComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionActionTableTableOrderingComposer
    extends Composer<_$NovaDatabase, $SessionActionTableTable> {
  $$SessionActionTableTableOrderingComposer({
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

  ColumnOrderings<int> get actionIndex => $composableBuilder(
    column: $table.actionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get desc => $composableBuilder(
    column: $table.desc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createTimeMs => $composableBuilder(
    column: $table.createTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionTableTableOrderingComposer get sessionId {
    final $$SessionTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableOrderingComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionActionTableTableAnnotationComposer
    extends Composer<_$NovaDatabase, $SessionActionTableTable> {
  $$SessionActionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get actionIndex => $composableBuilder(
    column: $table.actionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get desc =>
      $composableBuilder(column: $table.desc, builder: (column) => column);

  GeneratedColumn<int> get createTimeMs => $composableBuilder(
    column: $table.createTimeMs,
    builder: (column) => column,
  );

  $$SessionTableTableAnnotationComposer get sessionId {
    final $$SessionTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessionTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionActionTableTableTableManager
    extends
        RootTableManager<
          _$NovaDatabase,
          $SessionActionTableTable,
          SessionActionTableData,
          $$SessionActionTableTableFilterComposer,
          $$SessionActionTableTableOrderingComposer,
          $$SessionActionTableTableAnnotationComposer,
          $$SessionActionTableTableCreateCompanionBuilder,
          $$SessionActionTableTableUpdateCompanionBuilder,
          (SessionActionTableData, $$SessionActionTableTableReferences),
          SessionActionTableData,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SessionActionTableTableTableManager(
    _$NovaDatabase db,
    $SessionActionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionActionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionActionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionActionTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> actionIndex = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> desc = const Value.absent(),
                Value<int> createTimeMs = const Value.absent(),
              }) => SessionActionTableCompanion(
                id: id,
                sessionId: sessionId,
                actionIndex: actionIndex,
                label: label,
                result: result,
                desc: desc,
                createTimeMs: createTimeMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required int actionIndex,
                required String label,
                required String result,
                required String desc,
                required int createTimeMs,
              }) => SessionActionTableCompanion.insert(
                id: id,
                sessionId: sessionId,
                actionIndex: actionIndex,
                label: label,
                result: result,
                desc: desc,
                createTimeMs: createTimeMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionActionTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$SessionActionTableTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$SessionActionTableTableReferences
                                        ._sessionIdTable(db)
                                        .sessionId,
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

typedef $$SessionActionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$NovaDatabase,
      $SessionActionTableTable,
      SessionActionTableData,
      $$SessionActionTableTableFilterComposer,
      $$SessionActionTableTableOrderingComposer,
      $$SessionActionTableTableAnnotationComposer,
      $$SessionActionTableTableCreateCompanionBuilder,
      $$SessionActionTableTableUpdateCompanionBuilder,
      (SessionActionTableData, $$SessionActionTableTableReferences),
      SessionActionTableData,
      PrefetchHooks Function({bool sessionId})
    >;

class $NovaDatabaseManager {
  final _$NovaDatabase _db;
  $NovaDatabaseManager(this._db);
  $$ApiCacheTableTableTableManager get apiCacheTable =>
      $$ApiCacheTableTableTableManager(_db, _db.apiCacheTable);
  $$SessionTableTableTableManager get sessionTable =>
      $$SessionTableTableTableManager(_db, _db.sessionTable);
  $$SessionActionTableTableTableManager get sessionActionTable =>
      $$SessionActionTableTableTableManager(_db, _db.sessionActionTable);
}
