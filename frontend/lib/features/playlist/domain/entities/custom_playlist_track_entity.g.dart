// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_playlist_track_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomPlaylistTrackEntityCollection on Isar {
  IsarCollection<CustomPlaylistTrackEntity> get customPlaylistTrackEntitys =>
      this.collection();
}

const CustomPlaylistTrackEntitySchema = CollectionSchema(
  name: r'CustomPlaylistTrackEntity',
  id: 3136565852417505181,
  properties: {
    r'addedAt': PropertySchema(
      id: 0,
      name: r'addedAt',
      type: IsarType.dateTime,
    ),
    r'albumId': PropertySchema(id: 1, name: r'albumId', type: IsarType.string),
    r'artist': PropertySchema(id: 2, name: r'artist', type: IsarType.string),
    r'artistId': PropertySchema(
      id: 3,
      name: r'artistId',
      type: IsarType.string,
    ),
    r'coverArt': PropertySchema(
      id: 4,
      name: r'coverArt',
      type: IsarType.string,
    ),
    r'playlistId': PropertySchema(
      id: 5,
      name: r'playlistId',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 6,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'streamUrl': PropertySchema(
      id: 7,
      name: r'streamUrl',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 8, name: r'title', type: IsarType.string),
    r'trackId': PropertySchema(id: 9, name: r'trackId', type: IsarType.string),
  },
  estimateSize: _customPlaylistTrackEntityEstimateSize,
  serialize: _customPlaylistTrackEntitySerialize,
  deserialize: _customPlaylistTrackEntityDeserialize,
  deserializeProp: _customPlaylistTrackEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'playlistId': IndexSchema(
      id: 7921918076105486368,
      name: r'playlistId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'playlistId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'addedAt': IndexSchema(
      id: -8595779697745674092,
      name: r'addedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'addedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _customPlaylistTrackEntityGetId,
  getLinks: _customPlaylistTrackEntityGetLinks,
  attach: _customPlaylistTrackEntityAttach,
  version: '3.1.0+1',
);

int _customPlaylistTrackEntityEstimateSize(
  CustomPlaylistTrackEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.artist.length * 3;
  bytesCount += 3 + object.artistId.length * 3;
  bytesCount += 3 + object.coverArt.length * 3;
  bytesCount += 3 + object.playlistId.length * 3;
  bytesCount += 3 + object.remoteId.length * 3;
  bytesCount += 3 + object.streamUrl.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.trackId.length * 3;
  return bytesCount;
}

void _customPlaylistTrackEntitySerialize(
  CustomPlaylistTrackEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.addedAt);
  writer.writeString(offsets[1], object.albumId);
  writer.writeString(offsets[2], object.artist);
  writer.writeString(offsets[3], object.artistId);
  writer.writeString(offsets[4], object.coverArt);
  writer.writeString(offsets[5], object.playlistId);
  writer.writeString(offsets[6], object.remoteId);
  writer.writeString(offsets[7], object.streamUrl);
  writer.writeString(offsets[8], object.title);
  writer.writeString(offsets[9], object.trackId);
}

CustomPlaylistTrackEntity _customPlaylistTrackEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomPlaylistTrackEntity();
  object.addedAt = reader.readDateTime(offsets[0]);
  object.albumId = reader.readString(offsets[1]);
  object.artist = reader.readString(offsets[2]);
  object.artistId = reader.readString(offsets[3]);
  object.coverArt = reader.readString(offsets[4]);
  object.id = id;
  object.playlistId = reader.readString(offsets[5]);
  object.remoteId = reader.readString(offsets[6]);
  object.streamUrl = reader.readString(offsets[7]);
  object.title = reader.readString(offsets[8]);
  object.trackId = reader.readString(offsets[9]);
  return object;
}

P _customPlaylistTrackEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _customPlaylistTrackEntityGetId(CustomPlaylistTrackEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customPlaylistTrackEntityGetLinks(
  CustomPlaylistTrackEntity object,
) {
  return [];
}

void _customPlaylistTrackEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  CustomPlaylistTrackEntity object,
) {
  object.id = id;
}

extension CustomPlaylistTrackEntityByIndex
    on IsarCollection<CustomPlaylistTrackEntity> {
  Future<CustomPlaylistTrackEntity?> getByRemoteId(String remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  CustomPlaylistTrackEntity? getByRemoteIdSync(String remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<CustomPlaylistTrackEntity?>> getAllByRemoteId(
    List<String> remoteIdValues,
  ) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<CustomPlaylistTrackEntity?> getAllByRemoteIdSync(
    List<String> remoteIdValues,
  ) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(CustomPlaylistTrackEntity object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(
    CustomPlaylistTrackEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<CustomPlaylistTrackEntity> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(
    List<CustomPlaylistTrackEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension CustomPlaylistTrackEntityQueryWhereSort
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QWhere
        > {
  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhere
  >
  anyAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'addedAt'),
      );
    });
  }
}

extension CustomPlaylistTrackEntityQueryWhere
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QWhereClause
        > {
  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  remoteIdEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'remoteId', value: [remoteId]),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  remoteIdNotEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [],
                upper: [remoteId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [remoteId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [remoteId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [],
                upper: [remoteId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  playlistIdEqualTo(String playlistId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'playlistId', value: [playlistId]),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  playlistIdNotEqualTo(String playlistId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playlistId',
                lower: [],
                upper: [playlistId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playlistId',
                lower: [playlistId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playlistId',
                lower: [playlistId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playlistId',
                lower: [],
                upper: [playlistId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  addedAtEqualTo(DateTime addedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'addedAt', value: [addedAt]),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  addedAtNotEqualTo(DateTime addedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [],
                upper: [addedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [addedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [addedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [],
                upper: [addedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  addedAtGreaterThan(DateTime addedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'addedAt',
          lower: [addedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  addedAtLessThan(DateTime addedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'addedAt',
          lower: [],
          upper: [addedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterWhereClause
  >
  addedAtBetween(
    DateTime lowerAddedAt,
    DateTime upperAddedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'addedAt',
          lower: [lowerAddedAt],
          includeLower: includeLower,
          upper: [upperAddedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CustomPlaylistTrackEntityQueryFilter
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QFilterCondition
        > {
  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  addedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'addedAt', value: value),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  addedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'addedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  addedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'addedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  addedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'addedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'playlistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playlistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playlistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playlistId',
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'playlistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'playlistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'playlistId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'playlistId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playlistId', value: ''),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  playlistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'playlistId', value: ''),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remoteId',
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'remoteId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterFilterCondition
  >
  remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
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

extension CustomPlaylistTrackEntityQueryObject
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QFilterCondition
        > {}

extension CustomPlaylistTrackEntityQueryLinks
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QFilterCondition
        > {}

extension CustomPlaylistTrackEntityQuerySortBy
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QSortBy
        > {
  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByCoverArt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByCoverArtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByPlaylistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByPlaylistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByStreamUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByStreamUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  sortByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }
}

extension CustomPlaylistTrackEntityQuerySortThenBy
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QSortThenBy
        > {
  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByCoverArt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByCoverArtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverArt', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByPlaylistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByPlaylistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByStreamUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByStreamUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamUrl', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<
    CustomPlaylistTrackEntity,
    CustomPlaylistTrackEntity,
    QAfterSortBy
  >
  thenByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }
}

extension CustomPlaylistTrackEntityQueryWhereDistinct
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QDistinct
        > {
  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedAt');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByAlbumId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByArtist({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByArtistId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByCoverArt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverArt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByPlaylistId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playlistId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByStreamUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streamUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, CustomPlaylistTrackEntity, QDistinct>
  distinctByTrackId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackId', caseSensitive: caseSensitive);
    });
  }
}

extension CustomPlaylistTrackEntityQueryProperty
    on
        QueryBuilder<
          CustomPlaylistTrackEntity,
          CustomPlaylistTrackEntity,
          QQueryProperty
        > {
  QueryBuilder<CustomPlaylistTrackEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, DateTime, QQueryOperations>
  addedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedAt');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  artistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artist');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  artistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistId');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  coverArtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverArt');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  playlistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playlistId');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  streamUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streamUrl');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<CustomPlaylistTrackEntity, String, QQueryOperations>
  trackIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackId');
    });
  }
}
