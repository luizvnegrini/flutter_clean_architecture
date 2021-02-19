import '../../entities/account_entity.dart';

abstract class ISaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
