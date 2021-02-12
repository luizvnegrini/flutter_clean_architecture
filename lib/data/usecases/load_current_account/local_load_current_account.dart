import 'package:meta/meta.dart';

import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/enums/enums.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements ILoadCurrentAccount {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: only_throw_errors
      throw DomainError.unexpected;
    }
  }
}
