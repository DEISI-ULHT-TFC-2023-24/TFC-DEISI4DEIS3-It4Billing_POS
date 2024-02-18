import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objetos/artigoObj.dart';
import '../objetos/pedidoObj.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBoxDatabase {
  /// The Store of this app.
  late final Store _store;

  /// A Box of pedidos.
  late final Box<PedidoObj> _pedidosBox;

  ObjectBoxDatabase._create(this._store) {
    _pedidosBox = Box<PedidoObj>(_store);

    //// Add some demo data if the box is empty. exemplo para dar infos de artigos porexemplo
    //if (_pedidosBox.isEmpty()) {
    //  _putDemoData();
    //}
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxDatabase> create() async {

    final store = await openStore(
        directory:
        p.join((await getApplicationDocumentsDirectory()).path, "obx-demo"),
        macosApplicationGroup: "objectbox.demo");
    return ObjectBoxDatabase._create(store);
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


}