import '../../entities/entities.dart';
import '../usecases.dart';

abstract class IAddAccount {
  Future<AccountEntity> add(AddAccountParams addAccountParams);
}
