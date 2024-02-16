import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objetos/artigoObj.dart';
import '../objetos/pedidoObj.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of pedidos.
  late final Box<PedidoObj> _pedidoBox;
  late List<PedidoObj> _pedidos;

  ObjectBox._create(this._store);

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Note: set macosApplicationGroup for sandboxed macOS applications, see the
    // info boxes at https://docs.objectbox.io/getting-started for details.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
        directory:
        p.join((await getApplicationDocumentsDirectory()).path, "obx-demo"),
        macosApplicationGroup: "objectbox.demo");
    return ObjectBox._create(store);
  }

  Future<void> addPedido(PedidoObj pedido) async {
    await _pedidoBox.put(pedido);
  }

  Future<void> removePedido(int index) async {
    await _pedidoBox.remove(index);
  }

  List<PedidoObj> getAllPedidos() {
    return _pedidoBox.getAll();
  }


}