// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention_policy_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRetentionPolicyModelCollection on Isar {
  IsarCollection<RetentionPolicyModel> get retentionPolicyModels =>
      this.collection();
}

const RetentionPolicyModelSchema = CollectionSchema(
  name: r'RetentionPolicyModel',
  id: -340305718018032276,
  properties: {
    r'autoCleanupEnabled': PropertySchema(
      id: 0,
      name: r'autoCleanupEnabled',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deleteRouteDataOnly': PropertySchema(
      id: 2,
      name: r'deleteRouteDataOnly',
      type: IsarType.bool,
    ),
    r'exportBeforeDelete': PropertySchema(
      id: 3,
      name: r'exportBeforeDelete',
      type: IsarType.bool,
    ),
    r'exportFormat': PropertySchema(
      id: 4,
      name: r'exportFormat',
      type: IsarType.string,
    ),
    r'lastCleanupDate': PropertySchema(
      id: 5,
      name: r'lastCleanupDate',
      type: IsarType.dateTime,
    ),
    r'lastCleanupDeletedCount': PropertySchema(
      id: 6,
      name: r'lastCleanupDeletedCount',
      type: IsarType.long,
    ),
    r'retentionPeriod': PropertySchema(
      id: 7,
      name: r'retentionPeriod',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _retentionPolicyModelEstimateSize,
  serialize: _retentionPolicyModelSerialize,
  deserialize: _retentionPolicyModelDeserialize,
  deserializeProp: _retentionPolicyModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _retentionPolicyModelGetId,
  getLinks: _retentionPolicyModelGetLinks,
  attach: _retentionPolicyModelAttach,
  version: '3.1.0+1',
);

int _retentionPolicyModelEstimateSize(
  RetentionPolicyModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exportFormat.length * 3;
  bytesCount += 3 + object.retentionPeriod.length * 3;
  return bytesCount;
}

void _retentionPolicyModelSerialize(
  RetentionPolicyModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoCleanupEnabled);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.deleteRouteDataOnly);
  writer.writeBool(offsets[3], object.exportBeforeDelete);
  writer.writeString(offsets[4], object.exportFormat);
  writer.writeDateTime(offsets[5], object.lastCleanupDate);
  writer.writeLong(offsets[6], object.lastCleanupDeletedCount);
  writer.writeString(offsets[7], object.retentionPeriod);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

RetentionPolicyModel _retentionPolicyModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RetentionPolicyModel();
  object.autoCleanupEnabled = reader.readBool(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.deleteRouteDataOnly = reader.readBool(offsets[2]);
  object.exportBeforeDelete = reader.readBool(offsets[3]);
  object.exportFormat = reader.readString(offsets[4]);
  object.id = id;
  object.lastCleanupDate = reader.readDateTimeOrNull(offsets[5]);
  object.lastCleanupDeletedCount = reader.readLong(offsets[6]);
  object.retentionPeriod = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _retentionPolicyModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _retentionPolicyModelGetId(RetentionPolicyModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _retentionPolicyModelGetLinks(
    RetentionPolicyModel object) {
  return [];
}

void _retentionPolicyModelAttach(
    IsarCollection<dynamic> col, Id id, RetentionPolicyModel object) {
  object.id = id;
}

extension RetentionPolicyModelQueryWhereSort
    on QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QWhere> {
  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RetentionPolicyModelQueryWhere
    on QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QWhereClause> {
  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RetentionPolicyModelQueryFilter on QueryBuilder<RetentionPolicyModel,
    RetentionPolicyModel, QFilterCondition> {
  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> autoCleanupEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoCleanupEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> deleteRouteDataOnlyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deleteRouteDataOnly',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportBeforeDeleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exportBeforeDelete',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exportFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exportFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exportFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exportFormat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exportFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exportFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
          QAfterFilterCondition>
      exportFormatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exportFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
          QAfterFilterCondition>
      exportFormatMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exportFormat',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exportFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> exportFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exportFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCleanupDate',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCleanupDate',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCleanupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCleanupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCleanupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCleanupDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDeletedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCleanupDeletedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDeletedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCleanupDeletedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDeletedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCleanupDeletedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> lastCleanupDeletedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCleanupDeletedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retentionPeriod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retentionPeriod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retentionPeriod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retentionPeriod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'retentionPeriod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'retentionPeriod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
          QAfterFilterCondition>
      retentionPeriodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'retentionPeriod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
          QAfterFilterCondition>
      retentionPeriodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'retentionPeriod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retentionPeriod',
        value: '',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> retentionPeriodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'retentionPeriod',
        value: '',
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RetentionPolicyModelQueryObject on QueryBuilder<RetentionPolicyModel,
    RetentionPolicyModel, QFilterCondition> {}

extension RetentionPolicyModelQueryLinks on QueryBuilder<RetentionPolicyModel,
    RetentionPolicyModel, QFilterCondition> {}

extension RetentionPolicyModelQuerySortBy
    on QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QSortBy> {
  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByAutoCleanupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCleanupEnabled', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByAutoCleanupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCleanupEnabled', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByDeleteRouteDataOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteRouteDataOnly', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByDeleteRouteDataOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteRouteDataOnly', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByExportBeforeDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportBeforeDelete', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByExportBeforeDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportBeforeDelete', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByExportFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportFormat', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByExportFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportFormat', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByLastCleanupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDate', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByLastCleanupDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDate', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByLastCleanupDeletedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDeletedCount', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByLastCleanupDeletedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDeletedCount', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByRetentionPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retentionPeriod', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByRetentionPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retentionPeriod', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RetentionPolicyModelQuerySortThenBy
    on QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QSortThenBy> {
  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByAutoCleanupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCleanupEnabled', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByAutoCleanupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCleanupEnabled', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByDeleteRouteDataOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteRouteDataOnly', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByDeleteRouteDataOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteRouteDataOnly', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByExportBeforeDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportBeforeDelete', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByExportBeforeDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportBeforeDelete', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByExportFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportFormat', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByExportFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exportFormat', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByLastCleanupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDate', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByLastCleanupDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDate', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByLastCleanupDeletedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDeletedCount', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByLastCleanupDeletedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCleanupDeletedCount', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByRetentionPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retentionPeriod', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByRetentionPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retentionPeriod', Sort.desc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RetentionPolicyModelQueryWhereDistinct
    on QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct> {
  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByAutoCleanupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoCleanupEnabled');
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByDeleteRouteDataOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleteRouteDataOnly');
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByExportBeforeDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exportBeforeDelete');
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByExportFormat({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exportFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByLastCleanupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCleanupDate');
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByLastCleanupDeletedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCleanupDeletedCount');
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByRetentionPeriod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retentionPeriod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RetentionPolicyModel, RetentionPolicyModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension RetentionPolicyModelQueryProperty on QueryBuilder<
    RetentionPolicyModel, RetentionPolicyModel, QQueryProperty> {
  QueryBuilder<RetentionPolicyModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RetentionPolicyModel, bool, QQueryOperations>
      autoCleanupEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoCleanupEnabled');
    });
  }

  QueryBuilder<RetentionPolicyModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RetentionPolicyModel, bool, QQueryOperations>
      deleteRouteDataOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleteRouteDataOnly');
    });
  }

  QueryBuilder<RetentionPolicyModel, bool, QQueryOperations>
      exportBeforeDeleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exportBeforeDelete');
    });
  }

  QueryBuilder<RetentionPolicyModel, String, QQueryOperations>
      exportFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exportFormat');
    });
  }

  QueryBuilder<RetentionPolicyModel, DateTime?, QQueryOperations>
      lastCleanupDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCleanupDate');
    });
  }

  QueryBuilder<RetentionPolicyModel, int, QQueryOperations>
      lastCleanupDeletedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCleanupDeletedCount');
    });
  }

  QueryBuilder<RetentionPolicyModel, String, QQueryOperations>
      retentionPeriodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retentionPeriod');
    });
  }

  QueryBuilder<RetentionPolicyModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetentionPolicyModel _$RetentionPolicyModelFromJson(
        Map<String, dynamic> json) =>
    RetentionPolicyModel()
      ..id = (json['id'] as num?)?.toInt()
      ..autoCleanupEnabled = json['autoCleanupEnabled'] as bool
      ..retentionPeriod = json['retentionPeriod'] as String
      ..deleteRouteDataOnly = json['deleteRouteDataOnly'] as bool
      ..exportBeforeDelete = json['exportBeforeDelete'] as bool
      ..exportFormat = json['exportFormat'] as String
      ..lastCleanupDate = json['lastCleanupDate'] == null
          ? null
          : DateTime.parse(json['lastCleanupDate'] as String)
      ..lastCleanupDeletedCount =
          (json['lastCleanupDeletedCount'] as num).toInt()
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..updatedAt = DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$RetentionPolicyModelToJson(
        RetentionPolicyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'autoCleanupEnabled': instance.autoCleanupEnabled,
      'retentionPeriod': instance.retentionPeriod,
      'deleteRouteDataOnly': instance.deleteRouteDataOnly,
      'exportBeforeDelete': instance.exportBeforeDelete,
      'exportFormat': instance.exportFormat,
      'lastCleanupDate': instance.lastCleanupDate?.toIso8601String(),
      'lastCleanupDeletedCount': instance.lastCleanupDeletedCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
