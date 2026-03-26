// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_schedule_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationScheduleModelCollection on Isar {
  IsarCollection<NotificationScheduleModel> get notificationScheduleModels =>
      this.collection();
}

const NotificationScheduleModelSchema = CollectionSchema(
  name: r'NotificationScheduleModel',
  id: 8686129278259378436,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'completed': PropertySchema(
      id: 2,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 3,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'enabled': PropertySchema(
      id: 5,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'fired': PropertySchema(
      id: 6,
      name: r'fired',
      type: IsarType.bool,
    ),
    r'firedAt': PropertySchema(
      id: 7,
      name: r'firedAt',
      type: IsarType.dateTime,
    ),
    r'linkedReminderId': PropertySchema(
      id: 8,
      name: r'linkedReminderId',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 9,
      name: r'notes',
      type: IsarType.string,
    ),
    r'notificationId': PropertySchema(
      id: 10,
      name: r'notificationId',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 11,
      name: r'priority',
      type: IsarType.string,
    ),
    r'recurring': PropertySchema(
      id: 12,
      name: r'recurring',
      type: IsarType.bool,
    ),
    r'recurringInterval': PropertySchema(
      id: 13,
      name: r'recurringInterval',
      type: IsarType.string,
    ),
    r'recurringIntervalKm': PropertySchema(
      id: 14,
      name: r'recurringIntervalKm',
      type: IsarType.long,
    ),
    r'scheduledDate': PropertySchema(
      id: 15,
      name: r'scheduledDate',
      type: IsarType.dateTime,
    ),
    r'snoozed': PropertySchema(
      id: 16,
      name: r'snoozed',
      type: IsarType.bool,
    ),
    r'snoozedUntil': PropertySchema(
      id: 17,
      name: r'snoozedUntil',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 18,
      name: r'title',
      type: IsarType.string,
    ),
    r'triggerAtKm': PropertySchema(
      id: 19,
      name: r'triggerAtKm',
      type: IsarType.double,
    ),
    r'triggerType': PropertySchema(
      id: 20,
      name: r'triggerType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 21,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _notificationScheduleModelEstimateSize,
  serialize: _notificationScheduleModelSerialize,
  deserialize: _notificationScheduleModelDeserialize,
  deserializeProp: _notificationScheduleModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationScheduleModelGetId,
  getLinks: _notificationScheduleModelGetLinks,
  attach: _notificationScheduleModelAttach,
  version: '3.1.0+1',
);

int _notificationScheduleModelEstimateSize(
  NotificationScheduleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.body.length * 3;
  bytesCount += 3 + object.category.length * 3;
  {
    final value = object.linkedReminderId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.notificationId.length * 3;
  bytesCount += 3 + object.priority.length * 3;
  {
    final value = object.recurringInterval;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.triggerType.length * 3;
  return bytesCount;
}

void _notificationScheduleModelSerialize(
  NotificationScheduleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeString(offsets[1], object.category);
  writer.writeBool(offsets[2], object.completed);
  writer.writeDateTime(offsets[3], object.completedAt);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeBool(offsets[5], object.enabled);
  writer.writeBool(offsets[6], object.fired);
  writer.writeDateTime(offsets[7], object.firedAt);
  writer.writeString(offsets[8], object.linkedReminderId);
  writer.writeString(offsets[9], object.notes);
  writer.writeString(offsets[10], object.notificationId);
  writer.writeString(offsets[11], object.priority);
  writer.writeBool(offsets[12], object.recurring);
  writer.writeString(offsets[13], object.recurringInterval);
  writer.writeLong(offsets[14], object.recurringIntervalKm);
  writer.writeDateTime(offsets[15], object.scheduledDate);
  writer.writeBool(offsets[16], object.snoozed);
  writer.writeDateTime(offsets[17], object.snoozedUntil);
  writer.writeString(offsets[18], object.title);
  writer.writeDouble(offsets[19], object.triggerAtKm);
  writer.writeString(offsets[20], object.triggerType);
  writer.writeDateTime(offsets[21], object.updatedAt);
}

NotificationScheduleModel _notificationScheduleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationScheduleModel();
  object.body = reader.readString(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.completed = reader.readBool(offsets[2]);
  object.completedAt = reader.readDateTimeOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.enabled = reader.readBool(offsets[5]);
  object.fired = reader.readBool(offsets[6]);
  object.firedAt = reader.readDateTimeOrNull(offsets[7]);
  object.id = id;
  object.linkedReminderId = reader.readStringOrNull(offsets[8]);
  object.notes = reader.readStringOrNull(offsets[9]);
  object.notificationId = reader.readString(offsets[10]);
  object.priority = reader.readString(offsets[11]);
  object.recurring = reader.readBool(offsets[12]);
  object.recurringInterval = reader.readStringOrNull(offsets[13]);
  object.recurringIntervalKm = reader.readLongOrNull(offsets[14]);
  object.scheduledDate = reader.readDateTimeOrNull(offsets[15]);
  object.snoozed = reader.readBool(offsets[16]);
  object.snoozedUntil = reader.readDateTimeOrNull(offsets[17]);
  object.title = reader.readString(offsets[18]);
  object.triggerAtKm = reader.readDoubleOrNull(offsets[19]);
  object.triggerType = reader.readString(offsets[20]);
  object.updatedAt = reader.readDateTime(offsets[21]);
  return object;
}

P _notificationScheduleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readDoubleOrNull(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationScheduleModelGetId(NotificationScheduleModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _notificationScheduleModelGetLinks(
    NotificationScheduleModel object) {
  return [];
}

void _notificationScheduleModelAttach(
    IsarCollection<dynamic> col, Id id, NotificationScheduleModel object) {
  object.id = id;
}

extension NotificationScheduleModelQueryWhereSort on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QWhere> {
  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationScheduleModelQueryWhere on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QWhereClause> {
  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterWhereClause> idBetween(
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

extension NotificationScheduleModelQueryFilter on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QFilterCondition> {
  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      bodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      bodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fired',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firedAt',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firedAt',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> firedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedReminderId',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedReminderId',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedReminderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      linkedReminderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedReminderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      linkedReminderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedReminderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedReminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> linkedReminderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedReminderId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      notificationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      notificationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notificationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> notificationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notificationId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      priorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      priorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurring',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurringInterval',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurringInterval',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringInterval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurringInterval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurringInterval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurringInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recurringInterval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recurringInterval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      recurringIntervalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recurringInterval',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      recurringIntervalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recurringInterval',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringInterval',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurringInterval',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalKmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurringIntervalKm',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalKmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurringIntervalKm',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalKmEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringIntervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalKmGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurringIntervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalKmLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurringIntervalKm',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> recurringIntervalKmBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurringIntervalKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> scheduledDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledDate',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> scheduledDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledDate',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> scheduledDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> scheduledDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> scheduledDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> scheduledDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozed',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedUntilIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snoozedUntil',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedUntilIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snoozedUntil',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedUntilEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedUntilGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedUntilLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> snoozedUntilBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snoozedUntil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerAtKmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggerAtKm',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerAtKmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggerAtKm',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerAtKmEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerAtKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerAtKmGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerAtKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerAtKmLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerAtKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerAtKmBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerAtKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'triggerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'triggerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      triggerTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'triggerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
          QAfterFilterCondition>
      triggerTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'triggerType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerType',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> triggerTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'triggerType',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
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

extension NotificationScheduleModelQueryObject on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QFilterCondition> {}

extension NotificationScheduleModelQueryLinks on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QFilterCondition> {}

extension NotificationScheduleModelQuerySortBy on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QSortBy> {
  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByFired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fired', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByFiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fired', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByFiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByLinkedReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedReminderId', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByLinkedReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedReminderId', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByRecurringInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringInterval', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByRecurringIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringInterval', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByRecurringIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringIntervalKm', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByRecurringIntervalKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringIntervalKm', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByScheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortBySnoozed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozed', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortBySnoozedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozed', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortBySnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortBySnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByTriggerAtKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerAtKm', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByTriggerAtKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerAtKm', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByTriggerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerType', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByTriggerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerType', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension NotificationScheduleModelQuerySortThenBy on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QSortThenBy> {
  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByFired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fired', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByFiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fired', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByFiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByLinkedReminderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedReminderId', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByLinkedReminderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedReminderId', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByRecurringInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringInterval', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByRecurringIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringInterval', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByRecurringIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringIntervalKm', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByRecurringIntervalKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringIntervalKm', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByScheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenBySnoozed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozed', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenBySnoozedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozed', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenBySnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenBySnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByTriggerAtKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerAtKm', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByTriggerAtKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerAtKm', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByTriggerType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerType', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByTriggerTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerType', Sort.desc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension NotificationScheduleModelQueryWhereDistinct on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QDistinct> {
  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByFired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fired');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByFiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firedAt');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByLinkedReminderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedReminderId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByNotificationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByPriority({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurring');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByRecurringInterval({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringInterval',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByRecurringIntervalKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringIntervalKm');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledDate');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctBySnoozed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozed');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctBySnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozedUntil');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByTriggerAtKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerAtKm');
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByTriggerType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationScheduleModel, NotificationScheduleModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension NotificationScheduleModelQueryProperty on QueryBuilder<
    NotificationScheduleModel, NotificationScheduleModel, QQueryProperty> {
  QueryBuilder<NotificationScheduleModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationScheduleModel, String, QQueryOperations>
      bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<NotificationScheduleModel, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<NotificationScheduleModel, bool, QQueryOperations>
      completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<NotificationScheduleModel, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<NotificationScheduleModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<NotificationScheduleModel, bool, QQueryOperations>
      enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<NotificationScheduleModel, bool, QQueryOperations>
      firedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fired');
    });
  }

  QueryBuilder<NotificationScheduleModel, DateTime?, QQueryOperations>
      firedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firedAt');
    });
  }

  QueryBuilder<NotificationScheduleModel, String?, QQueryOperations>
      linkedReminderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedReminderId');
    });
  }

  QueryBuilder<NotificationScheduleModel, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<NotificationScheduleModel, String, QQueryOperations>
      notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<NotificationScheduleModel, String, QQueryOperations>
      priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<NotificationScheduleModel, bool, QQueryOperations>
      recurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurring');
    });
  }

  QueryBuilder<NotificationScheduleModel, String?, QQueryOperations>
      recurringIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringInterval');
    });
  }

  QueryBuilder<NotificationScheduleModel, int?, QQueryOperations>
      recurringIntervalKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringIntervalKm');
    });
  }

  QueryBuilder<NotificationScheduleModel, DateTime?, QQueryOperations>
      scheduledDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledDate');
    });
  }

  QueryBuilder<NotificationScheduleModel, bool, QQueryOperations>
      snoozedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozed');
    });
  }

  QueryBuilder<NotificationScheduleModel, DateTime?, QQueryOperations>
      snoozedUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozedUntil');
    });
  }

  QueryBuilder<NotificationScheduleModel, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<NotificationScheduleModel, double?, QQueryOperations>
      triggerAtKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerAtKm');
    });
  }

  QueryBuilder<NotificationScheduleModel, String, QQueryOperations>
      triggerTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerType');
    });
  }

  QueryBuilder<NotificationScheduleModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationScheduleModel _$NotificationScheduleModelFromJson(
        Map<String, dynamic> json) =>
    NotificationScheduleModel()
      ..id = (json['id'] as num?)?.toInt()
      ..notificationId = json['notificationId'] as String
      ..category = json['category'] as String
      ..title = json['title'] as String
      ..body = json['body'] as String
      ..triggerType = json['triggerType'] as String
      ..scheduledDate = json['scheduledDate'] == null
          ? null
          : DateTime.parse(json['scheduledDate'] as String)
      ..triggerAtKm = (json['triggerAtKm'] as num?)?.toDouble()
      ..recurring = json['recurring'] as bool
      ..recurringInterval = json['recurringInterval'] as String?
      ..recurringIntervalKm = (json['recurringIntervalKm'] as num?)?.toInt()
      ..enabled = json['enabled'] as bool
      ..fired = json['fired'] as bool
      ..firedAt = json['firedAt'] == null
          ? null
          : DateTime.parse(json['firedAt'] as String)
      ..completed = json['completed'] as bool
      ..completedAt = json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String)
      ..snoozed = json['snoozed'] as bool
      ..snoozedUntil = json['snoozedUntil'] == null
          ? null
          : DateTime.parse(json['snoozedUntil'] as String)
      ..linkedReminderId = json['linkedReminderId'] as String?
      ..notes = json['notes'] as String?
      ..priority = json['priority'] as String
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..updatedAt = DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$NotificationScheduleModelToJson(
        NotificationScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notificationId': instance.notificationId,
      'category': instance.category,
      'title': instance.title,
      'body': instance.body,
      'triggerType': instance.triggerType,
      'scheduledDate': instance.scheduledDate?.toIso8601String(),
      'triggerAtKm': instance.triggerAtKm,
      'recurring': instance.recurring,
      'recurringInterval': instance.recurringInterval,
      'recurringIntervalKm': instance.recurringIntervalKm,
      'enabled': instance.enabled,
      'fired': instance.fired,
      'firedAt': instance.firedAt?.toIso8601String(),
      'completed': instance.completed,
      'completedAt': instance.completedAt?.toIso8601String(),
      'snoozed': instance.snoozed,
      'snoozedUntil': instance.snoozedUntil?.toIso8601String(),
      'linkedReminderId': instance.linkedReminderId,
      'notes': instance.notes,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
