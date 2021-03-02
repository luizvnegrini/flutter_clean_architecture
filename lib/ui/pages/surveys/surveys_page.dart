import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../ui/components/components.dart';
import '../../../ui/helpers/i18n/i18n.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/surveys/components/survey_items_component.dart';
import '../../../ui/pages/surveys/surveys.dart';

class SurveysPage extends StatefulWidget {
  final ISurveysPresenter presenter;

  const SurveysPage(this.presenter);

  @override
  _SurveysPageState createState() => _SurveysPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISurveysPresenter>('presenter', presenter));
  }
}

// ignore: prefer_mixin
class _SurveysPageState extends State<SurveysPage> with LoadingManager, NavigationManager, SessionManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(this, ModalRoute.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);
          handleNavigation(widget.presenter.navigateToStream);
          handleSessionExpired(widget.presenter.isSessionExpiredStream);
          widget.presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: widget.presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return Provider(
                  create: (_) => widget.presenter,
                  child: SurveyItems(snapshot.data),
                );
              }

              return const SizedBox(height: 0);
            },
          );
        },
      ),
    );
  }

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ISurveysPresenter>('presenter', widget.presenter));
  }
}
