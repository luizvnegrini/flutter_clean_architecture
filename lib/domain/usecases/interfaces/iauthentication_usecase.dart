import '../../entities/entities.dart';
import '../usecases.dart';

abstract class IAuthentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}
