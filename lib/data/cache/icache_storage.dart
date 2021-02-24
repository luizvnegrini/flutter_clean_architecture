import 'package:meta/meta.dart';

abstract class ICacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
  // ignore: type_annotate_public_apis
  // ignore: avoid_annotating_with_dynamic
  Future<void> save({@required String key, @required dynamic value});
}
