import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/authentication/login_screen.dart';
import 'package:flutter_app/screens/authentication/otp_screen.dart';
import 'package:flutter_app/screens/home_screen/screens/main_page.dart';
import 'package:flutter_app/utils/my_print.dart';

import '../splash_screen.dart';

class NavigationController {
  Route? onGeneratedRoutes(RouteSettings routeSettings) {
    MyPrint.printOnConsole("OnGeneratedRoutes Called for ${routeSettings.name} with arguments:${routeSettings.arguments}");

    Widget? widget;

    switch(routeSettings.name) {
      case SplashScreen.routeName : {
        widget = const SplashScreen();
        break;
      }
      case LoginScreen.routeName : {
        widget = const LoginScreen();
        break;
      }
      case OtpScreen.routeName : {
        String mobile = routeSettings.arguments?.toString() ?? "";
        if (mobile.isNotEmpty) {
          widget = OtpScreen(mobile: mobile,);
        }
        break;
      }
      case MainPage.routeName : {
        widget = const MainPage();
        break;
      }
      default : {
        widget = const SplashScreen();
      }
    }

    if(widget != null)return MaterialPageRoute(builder: (_) => widget!);
  }
}