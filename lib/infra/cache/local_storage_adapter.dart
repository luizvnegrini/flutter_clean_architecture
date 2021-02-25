import 'package:meta/meta.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  // ignore: avoid_annotating_with_dynamic
  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}
