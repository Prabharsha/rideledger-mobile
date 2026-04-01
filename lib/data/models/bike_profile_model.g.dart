// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bike_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBikeProfileModelCollection on Isar {
  IsarCollection<BikeProfileModel> get bikeProfileModels => this.collection();
}

const BikeProfileModelSchema = CollectionSchema(
  name: r'BikeProfileModel',
  id: -13829939919659138,
  properties: {
    r'bikeModel': PropertySchema(
      id: 0,
      name: r'bikeModel',
      type: IsarType.string,
    ),
    r'breakInModeEnabled': PropertySchema(
      id: 1,
      name: r'breakInModeEnabled',
      type: IsarType.bool,
    ),
    r'breakInProfile': PropertySchema(
      id: 2,
      name: r'breakInProfile',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'firstOilChangeKm': PropertySchema(
      id: 4,
      name: r'firstOilChangeKm',
      type: IsarType.double,
    ),
    r'isBreakInEnabled': PropertySchema(
      id: 5,
      name: r'isBreakInEnabled',
      type: IsarType.bool,
    ),
    r'isFirstLaunch': PropertySchema(
      id: 6,
      name: r'isFirstLaunch',
      type: IsarType.bool,
    ),
    r'manualFuelEconomyKmPerLiter': PropertySchema(
      id: 7,
      name: r'manualFuelEconomyKmPerLiter',
      type: IsarType.double,
    ),
    r'officeDaysPerWeek': PropertySchema(
      id: 8,
      name: r'officeDaysPerWeek',
      type: IsarType.long,
    ),
    r'officeOneWayDistanceKm': PropertySchema(
      id: 9,
      name: r'officeOneWayDistanceKm',
      type: IsarType.double,
    ),
    r'rebuildDate': PropertySchema(
      id: 10,
      name: r'rebuildDate',
      type: IsarType.dateTime,
    ),
    r'rebuildOdometerKm': PropertySchema(
      id: 11,
      name: r'rebuildOdometerKm',
      type: IsarType.double,
    ),
    r'rebuildStartOdometerKm': PropertySchema(
      id: 12,
      name: r'rebuildStartOdometerKm',
      type: IsarType.double,
    ),
    r'secondOilChangeKm': PropertySchema(
      id: 13,
      name: r'secondOilChangeKm',
      type: IsarType.double,
    ),
    r'targetFuelEconomyKmPerLiter': PropertySchema(
      id: 14,
      name: r'targetFuelEconomyKmPerLiter',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'vehicleNumber': PropertySchema(
      id: 16,
      name: r'vehicleNumber',
      type: IsarType.string,
    ),
    r'weeklyFuelBalanceLiters': PropertySchema(
      id: 17,
      name: r'weeklyFuelBalanceLiters',
      type: IsarType.double,
    ),
    r'weeklyFuelQuotaLiters': PropertySchema(
      id: 18,
      name: r'weeklyFuelQuotaLiters',
      type: IsarType.double,
    ),
    r'weeklyResetDate': PropertySchema(
      id: 19,
      name: r'weeklyResetDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _bikeProfileModelEstimateSize,
  serialize: _bikeProfileModelSerialize,
  deserialize: _bikeProfileModelDeserialize,
  deserializeProp: _bikeProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bikeProfileModelGetId,
  getLinks: _bikeProfileModelGetLinks,
  attach: _bikeProfileModelAttach,
  version: '3.1.0+1',
);

int _bikeProfileModelEstimateSize(
  BikeProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bikeModel.length * 3;
  bytesCount += 3 + object.breakInProfile.length * 3;
  {
    final value = object.vehicleNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bikeProfileModelSerialize(
  BikeProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bikeModel);
  writer.writeBool(offsets[1], object.breakInModeEnabled);
  writer.writeString(offsets[2], object.breakInProfile);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeDouble(offsets[4], object.firstOilChangeKm);
  writer.writeBool(offsets[5], object.isBreakInEnabled);
  writer.writeBool(offsets[6], object.isFirstLaunch);
  writer.writeDouble(offsets[7], object.manualFuelEconomyKmPerLiter);
  writer.writeLong(offsets[8], object.officeDaysPerWeek);
  writer.writeDouble(offsets[9], object.officeOneWayDistanceKm);
  writer.writeDateTime(offsets[10], object.rebuildDate);
  writer.writeDouble(offsets[11], object.rebuildOdometerKm);
  writer.writeDouble(offsets[12], object.rebuildStartOdometerKm);
  writer.writeDouble(offsets[13], object.secondOilChangeKm);
  writer.writeDouble(offsets[14], object.targetFuelEconomyKmPerLiter);
  writer.writeDateTime(offsets[15], object.updatedAt);
  writer.writeString(offsets[16], object.vehicleNumber);
  writer.writeDouble(offsets[17], object.weeklyFuelBalanceLiters);
  writer.writeDouble(offsets[18], object.weeklyFuelQuotaLiters);
  writer.writeDateTime(offsets[19], object.weeklyResetDate);
}

BikeProfileModel _bikeProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BikeProfileModel();
  object.bikeModel = reader.readString(offsets[0]);
  object.breakInProfile = reader.readString(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.firstOilChangeKm = reader.readDouble(offsets[4]);
  object.id = id;
  object.isBreakInEnabled = reader.readBoolOrNull(offsets[5]);
  object.isFirstLaunch = reader.readBool(offsets[6]);
  object.manualFuelEconomyKmPerLiter = reader.readDouble(offsets[7]);
  object.officeDaysPerWeek = reader.readLong(offsets[8]);
  object.officeOneWayDistanceKm = reader.readDouble(offsets[9]);
  object.rebuildDate = reader.readDateTime(offsets[10]);
  object.rebuildOdometerKm = reader.readDoubleOrNull(offsets[11]);
  object.rebuildStartOdometerKm = reader.readDouble(offsets[12]);
  object.secondOilChangeKm = reader.readDouble(offsets[13]);
  object.targetFuelEconomyKmPerLiter = reader.readDouble(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  object.vehicleNumber = reader.readStringOrNull(offsets[16]);
  object.weeklyFuelBalanceLiters = reader.readDouble(offsets[17]);
  object.weeklyFuelQuotaLiters = reader.readDouble(offsets[18]);
  object.weeklyResetDate = reader.readDateTime(offsets[19]);
  return object;
}

P _bikeProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bikeProfileModelGetId(BikeProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bikeProfileModelGetLinks(BikeProfileModel object) {
  return [];
}

void _bikeProfileModelAttach(
    IsarCollection<dynamic> col, Id id, BikeProfileModel object) {
  object.id = id;
}

extension BikeProfileModelQueryWhereSort
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QWhere> {
  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BikeProfileModelQueryWhere
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QWhereClause> {
  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterWhereClause>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterWhereClause> idBetween(
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

extension BikeProfileModelQueryFilter
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QFilterCondition> {
  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bikeModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bikeModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bikeModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bikeModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bikeModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bikeModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bikeModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bikeModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bikeModel',
        value: '',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      bikeModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bikeModel',
        value: '',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInModeEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breakInModeEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breakInProfile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'breakInProfile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'breakInProfile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'breakInProfile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'breakInProfile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'breakInProfile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'breakInProfile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'breakInProfile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breakInProfile',
        value: '',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      breakInProfileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'breakInProfile',
        value: '',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      firstOilChangeKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstOilChangeKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      firstOilChangeKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstOilChangeKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      firstOilChangeKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstOilChangeKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      firstOilChangeKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstOilChangeKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      isBreakInEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isBreakInEnabled',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      isBreakInEnabledIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isBreakInEnabled',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      isBreakInEnabledEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBreakInEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      isFirstLaunchEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFirstLaunch',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      manualFuelEconomyKmPerLiterEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manualFuelEconomyKmPerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      manualFuelEconomyKmPerLiterGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'manualFuelEconomyKmPerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      manualFuelEconomyKmPerLiterLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'manualFuelEconomyKmPerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      manualFuelEconomyKmPerLiterBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'manualFuelEconomyKmPerLiter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeDaysPerWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'officeDaysPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeDaysPerWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'officeDaysPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeDaysPerWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'officeDaysPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeDaysPerWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'officeDaysPerWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeOneWayDistanceKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'officeOneWayDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeOneWayDistanceKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'officeOneWayDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeOneWayDistanceKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'officeOneWayDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      officeOneWayDistanceKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'officeOneWayDistanceKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rebuildDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rebuildDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rebuildDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rebuildDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildOdometerKmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rebuildOdometerKm',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildOdometerKmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rebuildOdometerKm',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildOdometerKmEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rebuildOdometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildOdometerKmGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rebuildOdometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildOdometerKmLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rebuildOdometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildOdometerKmBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rebuildOdometerKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildStartOdometerKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rebuildStartOdometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildStartOdometerKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rebuildStartOdometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildStartOdometerKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rebuildStartOdometerKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      rebuildStartOdometerKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rebuildStartOdometerKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      secondOilChangeKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondOilChangeKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      secondOilChangeKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secondOilChangeKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      secondOilChangeKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secondOilChangeKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      secondOilChangeKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secondOilChangeKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      targetFuelEconomyKmPerLiterEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetFuelEconomyKmPerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      targetFuelEconomyKmPerLiterGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetFuelEconomyKmPerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      targetFuelEconomyKmPerLiterLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetFuelEconomyKmPerLiter',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      targetFuelEconomyKmPerLiterBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetFuelEconomyKmPerLiter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
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

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleNumber',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleNumber',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      vehicleNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelBalanceLitersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyFuelBalanceLiters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelBalanceLitersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyFuelBalanceLiters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelBalanceLitersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyFuelBalanceLiters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelBalanceLitersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyFuelBalanceLiters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelQuotaLitersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyFuelQuotaLiters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelQuotaLitersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyFuelQuotaLiters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelQuotaLitersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyFuelQuotaLiters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyFuelQuotaLitersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyFuelQuotaLiters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyResetDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyResetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyResetDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyResetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyResetDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyResetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterFilterCondition>
      weeklyResetDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyResetDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BikeProfileModelQueryObject
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QFilterCondition> {}

extension BikeProfileModelQueryLinks
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QFilterCondition> {}

extension BikeProfileModelQuerySortBy
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QSortBy> {
  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByBikeModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeModel', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByBikeModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeModel', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByBreakInModeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInModeEnabled', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByBreakInModeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInModeEnabled', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByBreakInProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInProfile', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByBreakInProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInProfile', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByFirstOilChangeKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstOilChangeKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByFirstOilChangeKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstOilChangeKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByIsBreakInEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBreakInEnabled', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByIsBreakInEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBreakInEnabled', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByIsFirstLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFirstLaunch', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByIsFirstLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFirstLaunch', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByManualFuelEconomyKmPerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualFuelEconomyKmPerLiter', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByManualFuelEconomyKmPerLiterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualFuelEconomyKmPerLiter', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByOfficeDaysPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeDaysPerWeek', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByOfficeDaysPerWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeDaysPerWeek', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByOfficeOneWayDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeOneWayDistanceKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByOfficeOneWayDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeOneWayDistanceKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByRebuildDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildDate', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByRebuildDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildDate', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByRebuildOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildOdometerKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByRebuildOdometerKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildOdometerKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByRebuildStartOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildStartOdometerKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByRebuildStartOdometerKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildStartOdometerKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortBySecondOilChangeKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondOilChangeKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortBySecondOilChangeKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondOilChangeKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByTargetFuelEconomyKmPerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFuelEconomyKmPerLiter', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByTargetFuelEconomyKmPerLiterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFuelEconomyKmPerLiter', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByVehicleNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleNumber', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByVehicleNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleNumber', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByWeeklyFuelBalanceLiters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelBalanceLiters', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByWeeklyFuelBalanceLitersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelBalanceLiters', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByWeeklyFuelQuotaLiters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelQuotaLiters', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByWeeklyFuelQuotaLitersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelQuotaLiters', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByWeeklyResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyResetDate', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      sortByWeeklyResetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyResetDate', Sort.desc);
    });
  }
}

extension BikeProfileModelQuerySortThenBy
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QSortThenBy> {
  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByBikeModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeModel', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByBikeModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bikeModel', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByBreakInModeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInModeEnabled', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByBreakInModeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInModeEnabled', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByBreakInProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInProfile', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByBreakInProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakInProfile', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByFirstOilChangeKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstOilChangeKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByFirstOilChangeKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstOilChangeKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByIsBreakInEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBreakInEnabled', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByIsBreakInEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBreakInEnabled', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByIsFirstLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFirstLaunch', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByIsFirstLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFirstLaunch', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByManualFuelEconomyKmPerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualFuelEconomyKmPerLiter', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByManualFuelEconomyKmPerLiterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualFuelEconomyKmPerLiter', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByOfficeDaysPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeDaysPerWeek', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByOfficeDaysPerWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeDaysPerWeek', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByOfficeOneWayDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeOneWayDistanceKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByOfficeOneWayDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'officeOneWayDistanceKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByRebuildDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildDate', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByRebuildDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildDate', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByRebuildOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildOdometerKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByRebuildOdometerKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildOdometerKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByRebuildStartOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildStartOdometerKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByRebuildStartOdometerKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rebuildStartOdometerKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenBySecondOilChangeKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondOilChangeKm', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenBySecondOilChangeKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondOilChangeKm', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByTargetFuelEconomyKmPerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFuelEconomyKmPerLiter', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByTargetFuelEconomyKmPerLiterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFuelEconomyKmPerLiter', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByVehicleNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleNumber', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByVehicleNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleNumber', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByWeeklyFuelBalanceLiters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelBalanceLiters', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByWeeklyFuelBalanceLitersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelBalanceLiters', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByWeeklyFuelQuotaLiters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelQuotaLiters', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByWeeklyFuelQuotaLitersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyFuelQuotaLiters', Sort.desc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByWeeklyResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyResetDate', Sort.asc);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QAfterSortBy>
      thenByWeeklyResetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyResetDate', Sort.desc);
    });
  }
}

extension BikeProfileModelQueryWhereDistinct
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct> {
  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByBikeModel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bikeModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByBreakInModeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakInModeEnabled');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByBreakInProfile({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakInProfile',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByFirstOilChangeKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstOilChangeKm');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByIsBreakInEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBreakInEnabled');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByIsFirstLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFirstLaunch');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByManualFuelEconomyKmPerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manualFuelEconomyKmPerLiter');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByOfficeDaysPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'officeDaysPerWeek');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByOfficeOneWayDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'officeOneWayDistanceKm');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByRebuildDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rebuildDate');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByRebuildOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rebuildOdometerKm');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByRebuildStartOdometerKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rebuildStartOdometerKm');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctBySecondOilChangeKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondOilChangeKm');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByTargetFuelEconomyKmPerLiter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetFuelEconomyKmPerLiter');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByVehicleNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByWeeklyFuelBalanceLiters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyFuelBalanceLiters');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByWeeklyFuelQuotaLiters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyFuelQuotaLiters');
    });
  }

  QueryBuilder<BikeProfileModel, BikeProfileModel, QDistinct>
      distinctByWeeklyResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyResetDate');
    });
  }
}

extension BikeProfileModelQueryProperty
    on QueryBuilder<BikeProfileModel, BikeProfileModel, QQueryProperty> {
  QueryBuilder<BikeProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BikeProfileModel, String, QQueryOperations> bikeModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bikeModel');
    });
  }

  QueryBuilder<BikeProfileModel, bool, QQueryOperations>
      breakInModeEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakInModeEnabled');
    });
  }

  QueryBuilder<BikeProfileModel, String, QQueryOperations>
      breakInProfileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakInProfile');
    });
  }

  QueryBuilder<BikeProfileModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      firstOilChangeKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstOilChangeKm');
    });
  }

  QueryBuilder<BikeProfileModel, bool?, QQueryOperations>
      isBreakInEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBreakInEnabled');
    });
  }

  QueryBuilder<BikeProfileModel, bool, QQueryOperations>
      isFirstLaunchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFirstLaunch');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      manualFuelEconomyKmPerLiterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manualFuelEconomyKmPerLiter');
    });
  }

  QueryBuilder<BikeProfileModel, int, QQueryOperations>
      officeDaysPerWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'officeDaysPerWeek');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      officeOneWayDistanceKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'officeOneWayDistanceKm');
    });
  }

  QueryBuilder<BikeProfileModel, DateTime, QQueryOperations>
      rebuildDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rebuildDate');
    });
  }

  QueryBuilder<BikeProfileModel, double?, QQueryOperations>
      rebuildOdometerKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rebuildOdometerKm');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      rebuildStartOdometerKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rebuildStartOdometerKm');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      secondOilChangeKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondOilChangeKm');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      targetFuelEconomyKmPerLiterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetFuelEconomyKmPerLiter');
    });
  }

  QueryBuilder<BikeProfileModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BikeProfileModel, String?, QQueryOperations>
      vehicleNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleNumber');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      weeklyFuelBalanceLitersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyFuelBalanceLiters');
    });
  }

  QueryBuilder<BikeProfileModel, double, QQueryOperations>
      weeklyFuelQuotaLitersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyFuelQuotaLiters');
    });
  }

  QueryBuilder<BikeProfileModel, DateTime, QQueryOperations>
      weeklyResetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyResetDate');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BikeProfileModel _$BikeProfileModelFromJson(Map<String, dynamic> json) =>
    BikeProfileModel()
      ..id = (json['id'] as num).toInt()
      ..bikeModel = json['bikeModel'] as String
      ..vehicleNumber = json['vehicleNumber'] as String?
      ..rebuildDate = DateTime.parse(json['rebuildDate'] as String)
      ..rebuildStartOdometerKm =
          (json['rebuildStartOdometerKm'] as num).toDouble()
      ..firstOilChangeKm = (json['firstOilChangeKm'] as num).toDouble()
      ..secondOilChangeKm = (json['secondOilChangeKm'] as num).toDouble()
      ..breakInProfile = json['breakInProfile'] as String
      ..officeOneWayDistanceKm =
          (json['officeOneWayDistanceKm'] as num).toDouble()
      ..officeDaysPerWeek = (json['officeDaysPerWeek'] as num).toInt()
      ..weeklyFuelQuotaLiters =
          (json['weeklyFuelQuotaLiters'] as num).toDouble()
      ..weeklyFuelBalanceLiters =
          (json['weeklyFuelBalanceLiters'] as num).toDouble()
      ..weeklyResetDate = DateTime.parse(json['weeklyResetDate'] as String)
      ..manualFuelEconomyKmPerLiter =
          (json['manualFuelEconomyKmPerLiter'] as num).toDouble()
      ..targetFuelEconomyKmPerLiter =
          (json['targetFuelEconomyKmPerLiter'] as num).toDouble()
      ..isFirstLaunch = json['isFirstLaunch'] as bool
      ..rebuildOdometerKm = (json['rebuildOdometerKm'] as num?)?.toDouble()
      ..isBreakInEnabled = json['isBreakInEnabled'] as bool?
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..updatedAt = DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$BikeProfileModelToJson(BikeProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bikeModel': instance.bikeModel,
      'vehicleNumber': instance.vehicleNumber,
      'rebuildDate': instance.rebuildDate.toIso8601String(),
      'rebuildStartOdometerKm': instance.rebuildStartOdometerKm,
      'firstOilChangeKm': instance.firstOilChangeKm,
      'secondOilChangeKm': instance.secondOilChangeKm,
      'breakInProfile': instance.breakInProfile,
      'officeOneWayDistanceKm': instance.officeOneWayDistanceKm,
      'officeDaysPerWeek': instance.officeDaysPerWeek,
      'weeklyFuelQuotaLiters': instance.weeklyFuelQuotaLiters,
      'weeklyFuelBalanceLiters': instance.weeklyFuelBalanceLiters,
      'weeklyResetDate': instance.weeklyResetDate.toIso8601String(),
      'manualFuelEconomyKmPerLiter': instance.manualFuelEconomyKmPerLiter,
      'targetFuelEconomyKmPerLiter': instance.targetFuelEconomyKmPerLiter,
      'isFirstLaunch': instance.isFirstLaunch,
      'rebuildOdometerKm': instance.rebuildOdometerKm,
      'isBreakInEnabled': instance.isBreakInEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
