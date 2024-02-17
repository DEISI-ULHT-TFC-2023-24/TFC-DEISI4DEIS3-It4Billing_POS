// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../objetos/artigoObj.dart';
import '../objetos/categoriaObj.dart';
import '../objetos/localObj.dart';
import '../objetos/pedidoObj.dart';
import '../objetos/utilizadorObj.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 3191427397601551436),
      name: 'Artigo',
      lastPropertyId: const obx_int.IdUid(18, 9118405432975613389),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8100061187814830515),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7490721058486202145),
            name: 'referencia',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 1985335769611045271),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5596711480341129763),
            name: 'barCod',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 6861233568490127938),
            name: 'description',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 7435185830802118236),
            name: 'productType',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 3406409228919577783),
            name: 'price',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 8034174130524508962),
            name: 'unitPrice',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 3448841899088094757),
            name: 'idTaxes',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 6668496038161365638),
            name: 'taxPrecentage',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 3321413912172968322),
            name: 'taxName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(13, 8101927225884580375),
            name: 'taxDescription',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(14, 4929507131458561628),
            name: 'idRetention',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(15, 1155123289016320138),
            name: 'retentionPercentage',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(16, 1431144779497111513),
            name: 'retentionName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(17, 581257936241306090),
            name: 'stock',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(18, 9118405432975613389),
            name: 'observacoes',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 5583956632136704967),
      name: 'Categoria',
      lastPropertyId: const obx_int.IdUid(4, 1855846717063499664),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4968895184744523969),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 5186778276475480054),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 248064170236266345),
            name: 'nomeCurto',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 1855846717063499664),
            name: 'description',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 3291211985064249028),
      name: 'LocalObj',
      lastPropertyId: const obx_int.IdUid(2, 8603684169517755335),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 6946334239615026495),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8603684169517755335),
            name: 'nome',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 7104298556461174362),
      name: 'PedidoObj',
      lastPropertyId: const obx_int.IdUid(5, 7515691703509998257),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5758938227539770021),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1012013142213818343),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 4287944465857653243),
            name: 'hora',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7039800546900743210),
            name: 'total',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 7515691703509998257),
            name: 'nrArtigos',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(5, 6422666133805705485),
      name: 'Utilizador',
      lastPropertyId: const obx_int.IdUid(3, 2484477567318182640),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 2874757383010796151),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 381916233866981134),
            name: 'nome',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2484477567318182640),
            name: 'pin',
            type: 6,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(6, 4772283387577696936),
      name: 'Note',
      lastPropertyId: const obx_int.IdUid(4, 7628756088963777523),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 3408471008171598888),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 4620978447039160973),
            name: 'text',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 1523034204437704542),
            name: 'comment',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 7628756088963777523),
            name: 'date',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(6, 4772283387577696936),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [5920608008104397494],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Artigo: obx_int.EntityDefinition<Artigo>(
        model: _entities[0],
        toOneRelations: (Artigo object) => [],
        toManyRelations: (Artigo object) => {},
        getId: (Artigo object) => object.id,
        setId: (Artigo object, int id) {
          object.id = id;
        },
        objectToFB: (Artigo object, fb.Builder fbb) {
          final referenciaOffset = fbb.writeString(object.referencia);
          final nomeOffset = fbb.writeString(object.nome);
          final barCodOffset = fbb.writeString(object.barCod);
          final descriptionOffset = fbb.writeString(object.description);
          final productTypeOffset = fbb.writeString(object.productType);
          final taxNameOffset = fbb.writeString(object.taxName);
          final taxDescriptionOffset = fbb.writeString(object.taxDescription);
          final retentionNameOffset = fbb.writeString(object.retentionName);
          final observacoesOffset = fbb.writeString(object.observacoes);
          fbb.startTable(19);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, referenciaOffset);
          fbb.addOffset(2, nomeOffset);
          fbb.addOffset(3, barCodOffset);
          fbb.addOffset(4, descriptionOffset);
          fbb.addOffset(5, productTypeOffset);
          fbb.addFloat64(6, object.price);
          fbb.addFloat64(7, object.unitPrice);
          fbb.addInt64(9, object.idTaxes);
          fbb.addInt64(10, object.taxPrecentage);
          fbb.addOffset(11, taxNameOffset);
          fbb.addOffset(12, taxDescriptionOffset);
          fbb.addInt64(13, object.idRetention);
          fbb.addInt64(14, object.retentionPercentage);
          fbb.addOffset(15, retentionNameOffset);
          fbb.addInt64(16, object.stock);
          fbb.addOffset(17, observacoesOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final referenciaParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final barCodParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final descriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, '');
          final productTypeParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, '');
          final unitPriceParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 18, 0);
          final idTaxesParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0);
          final taxPrecentageParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0);
          final taxNameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 26, '');
          final taxDescriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 28, '');
          final idRetentionParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 30, 0);
          final retentionPercentageParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 32, 0);
          final retentionNameParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 34, '');
          final stockParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 36, 0);
          final object = Artigo(
              referencia: referenciaParam,
              nome: nomeParam,
              barCod: barCodParam,
              description: descriptionParam,
              productType: productTypeParam,
              unitPrice: unitPriceParam,
              idTaxes: idTaxesParam,
              taxPrecentage: taxPrecentageParam,
              taxName: taxNameParam,
              taxDescription: taxDescriptionParam,
              idRetention: idRetentionParam,
              retentionPercentage: retentionPercentageParam,
              retentionName: retentionNameParam,
              stock: stockParam, categoria: Categoria(nome: 'nome', nomeCurto: 'nomeCurto', description: 'description'))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..price =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 16, 0)
            ..observacoes = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 38, '');

          return object;
        }),
    Categoria: obx_int.EntityDefinition<Categoria>(
        model: _entities[1],
        toOneRelations: (Categoria object) => [],
        toManyRelations: (Categoria object) => {},
        getId: (Categoria object) => object.id,
        setId: (Categoria object, int id) {
          object.id = id;
        },
        objectToFB: (Categoria object, fb.Builder fbb) {
          final nomeOffset = fbb.writeString(object.nome);
          final nomeCurtoOffset = fbb.writeString(object.nomeCurto);
          final descriptionOffset = fbb.writeString(object.description);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.addOffset(2, nomeCurtoOffset);
          fbb.addOffset(3, descriptionOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final nomeCurtoParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final descriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, '');
          final object = Categoria(
              nome: nomeParam,
              nomeCurto: nomeCurtoParam,
              description: descriptionParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    LocalObj: obx_int.EntityDefinition<LocalObj>(
        model: _entities[2],
        toOneRelations: (LocalObj object) => [],
        toManyRelations: (LocalObj object) => {},
        getId: (LocalObj object) => object.id,
        setId: (LocalObj object, int id) {
          object.id = id;
        },
        objectToFB: (LocalObj object, fb.Builder fbb) {
          final nomeOffset = fbb.writeString(object.nome);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final object = LocalObj(nomeParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    PedidoObj: obx_int.EntityDefinition<PedidoObj>(
        model: _entities[3],
        toOneRelations: (PedidoObj object) => [],
        toManyRelations: (PedidoObj object) => {},
        getId: (PedidoObj object) => object.id,
        setId: (PedidoObj object, int id) {
          object.id = id;
        },
        objectToFB: (PedidoObj object, fb.Builder fbb) {
          final nomeOffset = fbb.writeString(object.nome);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.addInt64(2, object.hora.millisecondsSinceEpoch);
          fbb.addFloat64(3, object.total);
          fbb.addInt64(4, object.nrArtigos);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final horaParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final totalParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0);
          final object = PedidoObj(
              nome: nomeParam, hora: horaParam, total: totalParam, funcionario: Utilizador('nome', 1234))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..nrArtigos =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);

          return object;
        }),
    Utilizador: obx_int.EntityDefinition<Utilizador>(
        model: _entities[4],
        toOneRelations: (Utilizador object) => [],
        toManyRelations: (Utilizador object) => {},
        getId: (Utilizador object) => object.id,
        setId: (Utilizador object, int id) {
          object.id = id;
        },
        objectToFB: (Utilizador object, fb.Builder fbb) {
          final nomeOffset = fbb.writeString(object.nome);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nomeOffset);
          fbb.addInt64(2, object.pin);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final nomeParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final pinParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final object = Utilizador(nomeParam, pinParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),

  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Artigo] entity fields to define ObjectBox queries.
class Artigo_ {
  /// see [Artigo.id]
  static final id =
      obx.QueryIntegerProperty<Artigo>(_entities[0].properties[0]);

  /// see [Artigo.referencia]
  static final referencia =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[1]);

  /// see [Artigo.nome]
  static final nome =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[2]);

  /// see [Artigo.barCod]
  static final barCod =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[3]);

  /// see [Artigo.description]
  static final description =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[4]);

  /// see [Artigo.productType]
  static final productType =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[5]);

  /// see [Artigo.price]
  static final price =
      obx.QueryDoubleProperty<Artigo>(_entities[0].properties[6]);

  /// see [Artigo.unitPrice]
  static final unitPrice =
      obx.QueryDoubleProperty<Artigo>(_entities[0].properties[7]);

  /// see [Artigo.idTaxes]
  static final idTaxes =
      obx.QueryIntegerProperty<Artigo>(_entities[0].properties[8]);

  /// see [Artigo.taxPrecentage]
  static final taxPrecentage =
      obx.QueryIntegerProperty<Artigo>(_entities[0].properties[9]);

  /// see [Artigo.taxName]
  static final taxName =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[10]);

  /// see [Artigo.taxDescription]
  static final taxDescription =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[11]);

  /// see [Artigo.idRetention]
  static final idRetention =
      obx.QueryIntegerProperty<Artigo>(_entities[0].properties[12]);

  /// see [Artigo.retentionPercentage]
  static final retentionPercentage =
      obx.QueryIntegerProperty<Artigo>(_entities[0].properties[13]);

  /// see [Artigo.retentionName]
  static final retentionName =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[14]);

  /// see [Artigo.stock]
  static final stock =
      obx.QueryIntegerProperty<Artigo>(_entities[0].properties[15]);

  /// see [Artigo.observacoes]
  static final observacoes =
      obx.QueryStringProperty<Artigo>(_entities[0].properties[16]);
}

/// [Categoria] entity fields to define ObjectBox queries.
class Categoria_ {
  /// see [Categoria.id]
  static final id =
      obx.QueryIntegerProperty<Categoria>(_entities[1].properties[0]);

  /// see [Categoria.nome]
  static final nome =
      obx.QueryStringProperty<Categoria>(_entities[1].properties[1]);

  /// see [Categoria.nomeCurto]
  static final nomeCurto =
      obx.QueryStringProperty<Categoria>(_entities[1].properties[2]);

  /// see [Categoria.description]
  static final description =
      obx.QueryStringProperty<Categoria>(_entities[1].properties[3]);
}

/// [LocalObj] entity fields to define ObjectBox queries.
class LocalObj_ {
  /// see [LocalObj.id]
  static final id =
      obx.QueryIntegerProperty<LocalObj>(_entities[2].properties[0]);

  /// see [LocalObj.nome]
  static final nome =
      obx.QueryStringProperty<LocalObj>(_entities[2].properties[1]);
}

/// [PedidoObj] entity fields to define ObjectBox queries.
class PedidoObj_ {
  /// see [PedidoObj.id]
  static final id =
      obx.QueryIntegerProperty<PedidoObj>(_entities[3].properties[0]);

  /// see [PedidoObj.nome]
  static final nome =
      obx.QueryStringProperty<PedidoObj>(_entities[3].properties[1]);

  /// see [PedidoObj.hora]
  static final hora =
      obx.QueryDateProperty<PedidoObj>(_entities[3].properties[2]);

  /// see [PedidoObj.total]
  static final total =
      obx.QueryDoubleProperty<PedidoObj>(_entities[3].properties[3]);

  /// see [PedidoObj.nrArtigos]
  static final nrArtigos =
      obx.QueryIntegerProperty<PedidoObj>(_entities[3].properties[4]);
}

/// [Utilizador] entity fields to define ObjectBox queries.
class Utilizador_ {
  /// see [Utilizador.id]
  static final id =
      obx.QueryIntegerProperty<Utilizador>(_entities[4].properties[0]);

  /// see [Utilizador.nome]
  static final nome =
      obx.QueryStringProperty<Utilizador>(_entities[4].properties[1]);

  /// see [Utilizador.pin]
  static final pin =
      obx.QueryIntegerProperty<Utilizador>(_entities[4].properties[2]);
}

