import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/signup/signup.dart';
import '../../factories.dart';

ISignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
