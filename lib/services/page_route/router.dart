
import 'package:covidcapstone/Pages/phone_number_page.dart';
import 'package:covidcapstone/Services/page_route/page_route.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/pages/on_boarding_components/getting_started_screen.dart';
import 'package:covidcapstone/pages/on_boarding_components/onboarding.dart';
import 'package:flutter/cupertino.dart';

class Router {

  final TargetPlatform platform;

  Router(this.platform);

  Route<dynamic> generateRoute(RouteSettings settings) {
    PageRouting routing = PageRouting(platform);
    switch (settings.name) {
      case '/':
        return routing.pageRoute(nextScreen: OnboardingScreen());
      case '/phoneNumber':
        return routing.pageRoute(nextScreen: PhoneNumberPage());
      case '/getStarted':
        return routing.pageRoute(nextScreen: GettingStarted());
      default:
        return routing.pageRoute(
            nextScreen: ScaffoldAdaptive(
              child: Center(
                  child: Text('No route defined for ${settings.name}')
              ),
            )
        );
    }
  }

}