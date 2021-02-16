import 'package:home_automation/domain/entities/account_entity.dart';
import 'package:home_automation/domain/usecases/add_account_prams.dart';

abstract class IAddAccount {
  Future<AccountEntity> add(AddAccountParams addAccountParams);
}
