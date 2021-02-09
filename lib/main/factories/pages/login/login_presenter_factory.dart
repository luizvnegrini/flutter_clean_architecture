import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

ILoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(),
    );

ILoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(),
    );
