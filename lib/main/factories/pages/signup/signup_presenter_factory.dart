import 'package:home_automation/presentation/presenters/getx_signup_presenter.dart';

import '../../../../main/factories/pages/signup/signup.dart';
import '../../../../ui/pages/signup/signup.dart';

ISignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      validation: makeSignUpValidation(),
    );
