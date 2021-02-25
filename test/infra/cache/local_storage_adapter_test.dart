import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  // ignore: avoid_annotating_with_dynamic
  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  test('should call LocalStorage with correct values', () async {
    final key = faker.randomGenerator.string(5);
    final value = faker.randomGenerator.string(50);
    final localStorage = LocalStorageSpy();
    final sut = LocalStorageAdapter(localStorage: localStorage);

    await sut.save(key: key, value: value);

    verify(localStorage.setItem(key, value)).called(1);
  });
}
