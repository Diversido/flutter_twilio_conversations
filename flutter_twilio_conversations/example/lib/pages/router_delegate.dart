import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_twilio_conversations_example/pages/dialog_page.dart';
import 'package:flutter_twilio_conversations_example/redux/states/app_state.dart';
import 'package:flutter_twilio_conversations_example/redux/states/navigation_state.dart';
import 'package:flutter_twilio_conversations_example/widgets/auth_widget.dart';
import 'package:flutter_twilio_conversations_example/widgets/dialogs_list.dart';

class AppRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> _store;

  AppRouterDelegate(this._store) : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NavigationState>(
      distinct: true,
      converter: (store) => _store.state.navigationState,
      onDidChange: (viewModel, oldViewModel) => notifyListeners(),
      builder: (context, viewModel) => Navigator(
        onPopPage: (route, dynamic result) {
          return true;
        },
        pages: [
          if (!viewModel.isAuthorized)
            MaterialPage<void>(
              child: AuthWidget(),
            ),
          if (viewModel.isAuthorized)
            MaterialPage<void>(
              child: DialogsList(),
            ),
          if (viewModel.isDialogOpened)
            const MaterialPage<void>(
              child: DialogPage(),
            ),
        ],
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState navigationState) async {}
}
