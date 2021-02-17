import 'package:flutter/material.dart';

import '../../../../ui/pages/signup/signup_page.dart';
import './signup_presenter_factory.dart';

Widget makeSignUpPage() => SignUpPage(makeGetxSignUpPresenter());
