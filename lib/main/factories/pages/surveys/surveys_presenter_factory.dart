import '../../../../main/factories/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/surveys/surveys.dart';

ISurveysPresenter makeGetxSurveysPresenter() => GetxSurveysPresenter(
      loadSurveys: makeRemoteLoadSurveysWithLocalFallback(),
    );
