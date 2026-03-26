// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_log_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFuelLogModelCollection on Isar {
  IsarCollection<FuelLogModel> get fuelLogModels => this.collection();
}

const FuelLogModelSchema = CollectionSchema(
  name: r'FuelLogModel',
  id: -468066837802876187,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'fuelLogId': PropertySchema(
      id: 2,
      name: r'fuelLogId',
      type: IsarType.string,
    ),
    r'litersAdded': PropertySchema(
      id: 3,
      name: r'litersAdded',
      type: IsarType.double,
    ),
    r'note': PropertySchema(
      id: 4,
      name: r'note',
      type: IsarType.string,
    ),
    r'odometerKm': PropertySchema(
      id: 5,
      name: r'odometerKm',
      type: IsarType.double,
    ),
    r'pricePerLiter': PropertySchema(
      id: 6,
      name: r'pricePerLiter',
      type: IsarType.double,
    ),
    r'totalCost': PropertySchema(
      id: 7,
      name: r'totalCost',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _fuelLogModelEstimateSize,
  serialize: _fuelLogModelSerialize,
  deserialize: _fuelLogModelDeserialize,
  deserializeProp: _fuelLogModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _fuelLogModelGetId,
  getLinks: _fuelLogModelGetLinks,
  attach: _fuelLogModelAttach,
  version: '3.1.0+1',
);

int _fuelLogModelEstimateSize(
  FuelLogModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fuelLogId.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fuelLogModelSerialize(
  FuelLogModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.fuelLogId);
  writer.writeDouble(offsets[3], object.litersAdded);
  writer.writeString(offsets[4], object.note);
  writer.writeDouble(offsets[5], object.odometerKm);
  writer.writeDouble(offsets[6], object.pricePerLiter);
  writer.writeDouble(offsets[7], object.totalCost);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

FuelLogModel _fuelLogModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FuelLogModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.fuelLogId = reader.readString(offsets[2]);
  object.id = id;
  object.litersAdded = reader.readDouble(offsets[3]);
  object.note = reader.readStringOrNull(offsets[4]);
  object.odometerKm = reader.readDouble(offsets[5]);
  object.pricePerLiter = reader.readDoubleOrNull(offsets[6]);
  object.totalCost = reader.readDoubleOrNull(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _fuelLogModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fuelLogModelGetId(FuelLogModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _fuelLogModelGetLinks(FuelLogModel object) {
  return [];
}

void _fuelLogModelAttach(
    IsarCollection<dynamic> col, Id id, FuelLogModel object) {
  object.id = id;
}

extension FuelLogModelQueryWhereSort
    on QueryBuilder<FuelLogModel, FuelLogModel, QWhere> {
  QueryBuilder<FuelLogModel, FuelLogModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FuelLogModelQueryWhere
    on QueryBuilder<FuelLogModel, FuelLogModel, QWhereClause> {
  QueryBuilder<FuelLogModel, FuelLogModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterWhereClause> idBetween(
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

extension FuelLogModelQueryFilter
    on QueryBuilder<FuelLogModel, FuelLogModel, QFilterCondition> {
  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuelLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fuelLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fuelLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fuelLogId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fuelLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fuelLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fuelLogId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fuelLogId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuelLogId',
        value: '',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      fuelLogIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fuelLogId',
        value: '',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      litersAddedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'litersAdded',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      litersAddedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'litersAdded',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      litersAddedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'litersAdded',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      litersAddedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'litersAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      odometerKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      odometerKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'odometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      odometerKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'odometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      odometerKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'odometerKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      pricePerLiterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pricePerLiter',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      pricePerLiterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pricePerLiter',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      pricePerLiterEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pricePerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      pricePerLiterGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pricePerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      pricePerLiterLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pricePerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      pricePerLiterBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pricePerLiter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      totalCostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalCost',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      totalCostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalCost',
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      totalCostEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      totalCostGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      totalCostLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      totalCostBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterFilterCondition>
      updatedAtBetween(
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

extension FuelLogModelQueryObject
    on QueryBuilder<FuelLogModel, FuelLogModel, QFilterCondition> {}

extension FuelLogModelQueryLinks
    on QueryBuilder<FuelLogModel, FuelLogModel, QFilterCondition> {}

extension FuelLogModelQuerySortBy
    on QueryBuilder<FuelLogModel, FuelLogModel, QSortBy> {
  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByFuelLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLogId', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByFuelLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLogId', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByLitersAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litersAdded', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy>
      sortByLitersAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litersAdded', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odometerKm', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy>
      sortByOdometerKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odometerKm', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByPricePerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLiter', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy>
      sortByPricePerLiterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLiter', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByTotalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByTotalCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FuelLogModelQuerySortThenBy
    on QueryBuilder<FuelLogModel, FuelLogModel, QSortThenBy> {
  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByFuelLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLogId', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByFuelLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelLogId', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByLitersAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litersAdded', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy>
      thenByLitersAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litersAdded', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odometerKm', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy>
      thenByOdometerKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odometerKm', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByPricePerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLiter', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy>
      thenByPricePerLiterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLiter', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByTotalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByTotalCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCost', Sort.desc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FuelLogModelQueryWhereDistinct
    on QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> {
  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByFuelLogId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fuelLogId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByLitersAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'litersAdded');
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'odometerKm');
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct>
      distinctByPricePerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pricePerLiter');
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByTotalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCost');
    });
  }

  QueryBuilder<FuelLogModel, FuelLogModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FuelLogModelQueryProperty
    on QueryBuilder<FuelLogModel, FuelLogModel, QQueryProperty> {
  QueryBuilder<FuelLogModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FuelLogModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FuelLogModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<FuelLogModel, String, QQueryOperations> fuelLogIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fuelLogId');
    });
  }

  QueryBuilder<FuelLogModel, double, QQueryOperations> litersAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'litersAdded');
    });
  }

  QueryBuilder<FuelLogModel, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<FuelLogModel, double, QQueryOperations> odometerKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'odometerKm');
    });
  }

  QueryBuilder<FuelLogModel, double?, QQueryOperations>
      pricePerLiterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pricePerLiter');
    });
  }

  QueryBuilder<FuelLogModel, double?, QQueryOperations> totalCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCost');
    });
  }

  QueryBuilder<FuelLogModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuelLogModel _$FuelLogModelFromJson(Map<String, dynamic> json) => FuelLogModel()
  ..id = (json['id'] as num?)?.toInt()
  ..fuelLogId = json['fuelLogId'] as String
  ..date = DateTime.parse(json['date'] as String)
  ..odometerKm = (json['odometerKm'] as num).toDouble()
  ..litersAdded = (json['litersAdded'] as num).toDouble()
  ..pricePerLiter = (json['pricePerLiter'] as num?)?.toDouble()
  ..totalCost = (json['totalCost'] as num?)?.toDouble()
  ..note = json['note'] as String?
  ..createdAt = DateTime.parse(json['createdAt'] as String)
  ..updatedAt = DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$FuelLogModelToJson(FuelLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fuelLogId': instance.fuelLogId,
      'date': instance.date.toIso8601String(),
      'odometerKm': instance.odometerKm,
      'litersAdded': instance.litersAdded,
      'pricePerLiter': instance.pricePerLiter,
      'totalCost': instance.totalCost,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
