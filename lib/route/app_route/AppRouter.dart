import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'AppRouter.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter{


  @override
  List<AutoRoute> get routes=>[

    AutoRoute(page: MyHomePage.page,initial: true),
    AutoRoute(page: IntroPage.page),
    AutoRoute(page: LoginPage.page),
    AutoRoute(page: OtpPage.page),
    AutoRoute(page: UpdateNamePage.page),
    AutoRoute(page: DashboardPage.page),
    AutoRoute(page: MessageRoute.page),
    AutoRoute(page: CreateGroupRoute.page),
    AutoRoute(page: GroupMessageRoute.page),
    AutoRoute(page: GroupDetailsRoute.page),
    AutoRoute(page: GroupMessageDetailsRoute.page),
    AutoRoute(page: FriendDetailsRoute.page),


  ];
   BuildContext? get ctx =>
      navigatorKey.currentContext;

}
