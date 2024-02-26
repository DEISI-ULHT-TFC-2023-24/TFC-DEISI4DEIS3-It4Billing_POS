import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objetos/artigoObj.dart';
import '../objetos/localObj.dart';
import '../objetos/pedidoObj.dart';
import '../objetos/utilizadorObj.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBoxDatabase {
  /// The Store of this app.
  late final Store _store;

  /// A Box of pedidos.
  late final Box<PedidoObj> _pedidosBox;
  late final Box<Utilizador> _utilizadoresBox;
  late final Box<LocalObj> _locaisBox;

  ObjectBoxDatabase._create(this._store) {
    _pedidosBox = Box<PedidoObj>(_store);
    _utilizadoresBox = Box<Utilizador>(_store);

    _locaisBox = Box<LocalObj>(_store);

    // Add some demo data if the box is empty.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxDatabase> create() async {

    final store = await openStore(
        directory:
        p.join((await getApplicationDocumentsDirectory()).path, "obx-demo"),
        macosApplicationGroup: "objectbox.demo");
    return ObjectBoxDatabase._create(store);
  }

  void putDemoUsers() {
    final demoUsers = [
      Utilizador('User 001', 9638),
      Utilizador('User 064', 9849),
    ];
    final List<LocalObj> locais = [
      LocalObj('Mesa 1'),
      LocalObj('Mesa 2'),
      LocalObj('Mesa 3'),
      LocalObj('Balcão 1'),
    ];
    _utilizadoresBox.putManyAsync(demoUsers);

  }
  void putDemoLocais() {
    final List<LocalObj> locais = [
      LocalObj('Mesa 1'),
      LocalObj('Mesa 2'),
      LocalObj('Mesa 3'),
      LocalObj('Balcão 1'),
    ];
    _locaisBox.putManyAsync(locais);

  }

  Future<void> addPedido(PedidoObj pedido) async {
    await _pedidosBox.put(pedido);
  }

  Future<void> removePedido(int index) async {
    await _pedidosBox.remove(index);
  }

  List<PedidoObj> getAllPedidos() {
    return _pedidosBox.getAll();
  }

  PedidoObj? getPedido(int id) {
    return _pedidosBox.get(id);
  }

  Future<void> removeAll() async {
    await _pedidosBox.removeAll();
  }

  ///---------------------------------------------------------
  // Funções para adicionar e manipular funcionarios
  Future<void> addUtilizador(Utilizador utilizador) async {
    await _utilizadoresBox.put(utilizador);
  }

  Utilizador? getUtilizador(int id) {
    return _utilizadoresBox.get(id);
  }

  bool containUtilizador(int id) {
    return _utilizadoresBox.contains(id);
  }

  List<Utilizador> getAllUtilizadores() {
    return _utilizadoresBox.getAll();
  }
  Future<void> removeAlUtilizadores() async {
    await _utilizadoresBox.removeAll();
  }
///---------------------------------------------------------

  Future<void> addLocal(LocalObj local) async {
    await _locaisBox.put(local);
  }

  LocalObj? getLocal(int id) {
    return _locaisBox.get(id);
  }
  List<LocalObj> getAllLocal() {
    return _locaisBox.getAll();
  }

  Future<void> removeAlllocais() async {
    await _locaisBox.removeAll();
  }

}