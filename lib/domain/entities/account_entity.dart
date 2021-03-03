import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String token;

  const AccountEntity({@required this.token});

  @override
  List get props => [token];
}
