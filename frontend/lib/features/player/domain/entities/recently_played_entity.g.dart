// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentlyPlayedEntityCollection on Isar {
  IsarCollection<RecentlyPlayedEntity> get recentlyPlayedEntitys =>
      this.collection();
}

const RecentlyPlayedEntitySchema = CollectionSchema(
  name: r'RecentlyPlayedEntity',
  id: 2313323638749217169,
  properties: {
    r'albumId': PropertySchema(id: 0, name: r'albumId', type: IsarType.string),
    r'artist': PropertySchema(id: 1, name: r'artist', type: IsarType.string),
    r'artistId': PropertySchema(
      id: 2,
      name: r'artistId',
      type: IsarType.string,
    ),
    r'coverArt': PropertySchema(
      id: 3,
      name: r'coverArt',
      type: IsarType.string,
    ),
    r'lastPlayedAt': PropertySchema(
      id: 4,
      name: r'lastPlayedAt',
      type: IsarType.dateTime,
    ),
    r'streamUrl': PropertySchema(
      id: 5,
      name: r'streamUrl',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 6, name: r'title', type: IsarType.string),
    r'trackId': PropertySchema(id: 7, name: r'trackId', type: IsarType.string),
  },
  estimateSize: _recentlyPlayedEntityEstimateSize,
  serialize: _recentlyPlayedEntitySerialize,
  deserialize: _recentlyPlayedEntityDeserialize,
  deserializeProp: _recentlyPlayedEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'trackId': IndexSchema(
      id: -8614467705999066844,
      name: r'trackId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'trackId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'lastPlayedAt': IndexSchema(
      id: 1709968845012040220,
      name: r'lastPlayedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastPlayedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _recentlyPlayedEntityGetId,
  getLinks: _recentlyPlayedEntityGetLinks,
  attach: _recentlyPlayedEntityAttach,
  version: '3.1.0+1',
);

int _recentlyPlayedEntityEstimateSize(
  RecentlyPlayedEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.artist.length * 3;
  bytesCount += 3 + object.artistId.length * 3;
  bytesCount += 3 + object.coverArt.length * 3;
  bytesCount += 3 + object.streamUrl.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.trackId.length * 3;
  return bytesCount;
}

void _recentlyPlayedEntitySerialize(
  RecentlyPlayedEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeString(offsets[1], object.artist);
  writer.writeString(offsets[2], object.artistId);
  writer.writeString(offsets[3], object.coverArt);
  writer.writeDateTime(offsets[4], object.lastPlayedAt);
  writer.writeString(offsets[5], object.streamUrl);
  writer.writeString(offsets[6], object.title);
  writer.writeString(offsets[7], object.trackId);
}

RecentlyPlayedEntity _recentlyPlayedEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentlyPlayedEntity();
  object.albumId = reader.readString(offsets[0]);
  object.artist = reader.readString(offsets[1]);
  object.artistId = reader.readString(offsets[2]);
  object.coverArt = reader.readString(offsets[3]);
  object.id = id;
  object.lastPlayedAt = reader.readDateTime(offsets[4]);
  object.streamUrl = reader.readString(offsets[5]);
  object.title = reader.readString(offsets[6]);
  object.trackId = reader.readString(offsets[7]);
  return object;
}

P _recentlyPlayedEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentlyPlayedEntityGetId(RecentlyPlayedEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentlyPlayedEntityGetLinks(
  RecentlyPlayedEntity object,
) {
  return [];
}

void _recentlyPlayedEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  RecentlyPlayedEntity object,
) {
  object.id = id;
}

extension RecentlyPlayedEntityByIndex on IsarCollection<RecentlyPlayedEntity> {
  Future<RecentlyPlayedEntity?> getByTrackId(String trackId) {
    return getByIndex(r'trackId', [trackId]);
  }

  RecentlyPlayedEntity? getByTrackIdSync(String trackId) {
    return getByIndexSync(r'trackId', [trackId]);
  }

  Future<bool> deleteByTrackId(String trackId) {
    return deleteByIndex(r'trackId', [trackId]);
  }

  bool deleteByTrackIdSync(String trackId) {
    return deleteByIndexSync(r'trackId', [trackId]);
  }

  Future<List<RecentlyPlayedEntity?>> getAllByTrackId(
    List<String> trackIdValues,
  ) {
    final values = trackIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'trackId', values);
  }

  List<RecentlyPlayedEntity?> getAllByTrackIdSync(List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'trackId', values);
  }

  Future<int> deleteAllByTrackId(List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'trackId', values);
  }

  int deleteAllByTrackIdSync(List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'trackId', values);
  }

  Future<Id> putByTrackId(RecentlyPlayedEntity object) {
    return putByIndex(r'trackId', object);
  }

  Id putByTrackIdSync(RecentlyPlayedEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'trackId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTrackId(List<RecentlyPlayedEntity> objects) {
    return putAllByIndex(r'trackId', objects);
  }

  List<Id> putAllByTrackIdSync(
    List<RecentlyPlayedEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'trackId', objects, saveLinks: saveLinks);
  }
}

extension RecentlyPlayedEntityQueryWhereSort
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QWhere> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhere>
  anyLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastPlayedAt'),
      );
    });
  }
}

extension RecentlyPlayedEntityQueryWhere
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QWhereClause> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
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

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  trackIdEqualTo(String trackId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'trackId', value: [trackId]),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  trackIdNotEqualTo(String trackId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trackId',
                lower: [],
                upper: [trackId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trackId',
                lower: [trackId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trackId',
                lower: [trackId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'trackId',
                lower: [],
                upper: [trackId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  lastPlayedAtEqualTo(DateTime lastPlayedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'lastPlayedAt',
          value: [lastPlayedAt],
        ),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  lastPlayedAtNotEqualTo(DateTime lastPlayedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastPlayedAt',
                lower: [],
                upper: [lastPlayedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastPlayedAt',
                lower: [lastPlayedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastPlayedAt',
                lower: [lastPlayedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lastPlayedAt',
                lower: [],
                upper: [lastPlayedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  lastPlayedAtGreaterThan(DateTime lastPlayedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastPlayedAt',
          lower: [lastPlayedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  lastPlayedAtLessThan(DateTime lastPlayedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastPlayedAt',
          lower: [],
          upper: [lastPlayedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterWhereClause>
  lastPlayedAtBetween(
    DateTime lowerLastPlayedAt,
    DateTime upperLastPlayedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lastPlayedAt',
          lower: [lowerLastPlayedAt],
          includeLower: includeLower,
          upper: [upperLastPlayedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension RecentlyPlayedEntityQueryFilter
    on
        QueryBuilder<
          RecentlyPlayedEntity,
          RecentlyPlayedEntity,
          QFilterCondition
        > {
  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'albumId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'albumId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'albumId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'albumId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'albumId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'albumId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'albumId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'albumId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'albumId', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'albumId', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'artist',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'artist',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'artist',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'artist', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'artist', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'artistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'artistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'artistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'artistId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'artistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'artistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'artistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'artistId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'artistId', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  artistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'artistId', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverArt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverArt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverArt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverArt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverArt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverArt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverArt',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverArt',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverArt', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  coverArtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coverArt', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  lastPlayedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPlayedAt', value: value),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  lastPlayedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPlayedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  lastPlayedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPlayedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  lastPlayedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPlayedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'streamUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'streamUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'streamUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'streamUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'streamUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'streamUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'streamUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'streamUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'streamUrl', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  streamUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'streamUrl', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'trackId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trackId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trackId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trackId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'trackId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'trackId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'trackId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'trackId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackId', value: ''),
      );
    });
  }

  QueryBuilder<
    RecentlyPlayedEntity,
    RecentlyPlayedEntity,
    QAfterFilterCondition
  >
  trackIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'trackId', value: ''),
      );
    });
  }
}

extension RecentlyPlayedEntityQueryObject
    on
        QueryBuilder<
          RecentlyPlayedEntity,
          RecentlyPlayedEntity,
          QFilterCondition
        > {}

extension RecentlyPlayedEntityQueryLinks
    on
        QueryBuilder<
          RecentlyPlayedEntity,
          RecentlyPlayedEntity,
          QFilterCondition
        > {}

extension RecentlyPlayedEntityQuerySortBy
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QSortBy> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByCoverArt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByCoverArtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByLastPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByStreamUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByStreamUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  sortByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }
}

extension RecentlyPlayedEntityQuerySortThenBy
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QSortThenBy> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByCoverArt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByCoverArtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByLastPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayedAt', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByStreamUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByStreamUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QAfterSortBy>
  thenByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }
}

extension RecentlyPlayedEntityQueryWhereDistinct
    on QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct> {
  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByAlbumId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByArtist({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByArtistId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByCoverArt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverArt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByLastPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPlayedAt');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByStreamUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streamUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecentlyPlayedEntity, RecentlyPlayedEntity, QDistinct>
  distinctByTrackId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackId', caseSensitive: caseSensitive);
    });
  }
}

extension RecentlyPlayedEntityQueryProperty
    on
        QueryBuilder<
          RecentlyPlayedEntity,
          RecentlyPlayedEntity,
          QQueryProperty
        > {
  QueryBuilder<RecentlyPlayedEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
  albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
  artistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artist');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
  artistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistId');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
  coverArtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverArt');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, DateTime, QQueryOperations>
  lastPlayedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPlayedAt');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
  streamUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streamUrl');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<RecentlyPlayedEntity, String, QQueryOperations>
  trackIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackId');
    });
  }
}
