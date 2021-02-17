import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

abstract class IAddAccount {
  Future<AccountEntity> add(AddAccountParams addAccountParams);
}
