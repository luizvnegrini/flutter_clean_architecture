import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

ILoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(),
    );
