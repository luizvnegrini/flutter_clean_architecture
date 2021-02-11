import 'package:meta/meta.dart';

import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccountUsecase implements ISaveCurrentAccount {
  final ISaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccountUsecase({@required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}
