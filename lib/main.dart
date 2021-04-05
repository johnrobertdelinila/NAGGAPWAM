
import 'package:covidcapstone/Pages/landing_page.dart';
import 'package:covidcapstone/Pages/notification_page.dart';
import 'package:covidcapstone/Pages/on_boarding_components/getting_started_screen.dart';
import 'package:covidcapstone/Pages/on_boarding_components/onboarding.dart';
import 'package:covidcapstone/models/health_declaration.dart';
import 'package:covidcapstone/pages/check_status_page.dart';
import 'package:covidcapstone/pages/health_declaration_page.dart';
import 'package:covidcapstone/pages/home_page.dart';
import 'package:covidcapstone/Widgets/scaffold_adaptive.dart';
import 'package:covidcapstone/pages/qr_registration_page.dart';
import 'package:covidcapstone/pages/qr_scan_page.dart';
import 'package:covidcapstone/pages/scanning_registration_page.dart';
import 'package:covidcapstone/pages/sign_in/sign_in.dart';
import 'package:covidcapstone/pages/success_page.dart';
import 'package:covidcapstone/pages/thankyou_page.dart';
import 'package:covidcapstone/pages/verify.dart';
import 'package:covidcapstone/services/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:google_fonts/google_fonts.dart';
import 'Pages/phone_number_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Services/page_route/page_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final String title = "Naggapwam App";
final String initialRoute = "/";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static final navKey = new GlobalKey<NavigatorState>();

  dynamic buildTheme(TargetPlatform platform, BuildContext context) {
    if(platform == TargetPlatform.iOS) {
      return CupertinoThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: CupertinoColors.activeBlue,
        barBackgroundColor: CupertinoColors.extraLightBackgroundGray,
      );
    }else {
      return ThemeData(
        backgroundColor: backgroundColor,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      );
    }
  }

  Widget buildApp(TargetPlatform platform, BuildContext context) {
    if(platform == TargetPlatform.iOS) {
      return CupertinoApp(
        title: title,
        initialRoute: initialRoute,
        onGenerateRoute: Router(platform).generateRoute,
        theme: buildTheme(platform, context),
      );
    }else {
      return MaterialApp(
        title: title,
        initialRoute: initialRoute,
        onGenerateRoute: Router(platform).generateRoute,
        theme: buildTheme(platform, context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return buildApp(platform, context);
  }
}

class Router {

  final TargetPlatform platform;
  Router(this.platform);

  Widget _fbInitializer(Widget page) {
    final Future _fbApp = Firebase.initializeApp();
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          print("You have an error! ${snapshot.error.toString()}");
          return Text("Some went wrong");
        }else if(snapshot.hasData) {
          return page;
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    PageRouting routing = PageRouting(platform);
    switch (settings.name) {
      case '/':
        if(isDeveloping) {
          // Development
          return routing.pageRoute(nextScreen: _fbInitializer(QrScanPage()));
        }else {
          // Production
          if(kIsWeb) {
            return routing.pageRoute(nextScreen: _fbInitializer(LandingPage()));
          }else {
            return routing.pageRoute(nextScreen: _fbInitializer(OnboardingScreen()));
          }
        }
        break;
      case '/landing':
        return routing.pageRoute(nextScreen: LandingPage());
      case '/phoneNumber':
        return routing.pageRoute(nextScreen: PhoneNumberPage());
      case '/getStarted':
        return routing.pageRoute(nextScreen: GettingStarted());
      case '/thankYou':
        return routing.pageRoute(nextScreen: ThankYouPage());
      case '/homePage':
        return routing.pageRoute(nextScreen: HomePage());
      case '/individualRegistration':
        return routing.pageRoute(nextScreen: QrRegistrationPage());
      case '/notification':
        return routing.pageRoute(nextScreen: NotificationPage());
      case '/healthDeclaration':
        return routing.pageRoute(nextScreen: HealthDeclarationPage(citizen: settings.arguments, hdf: HealthDeclaration(), formKey: GlobalKey<FormState>()));
      case '/successPage':
        return routing.pageRoute(nextScreen: SuccessPage(arguments: settings.arguments,));
      case '/checkStatus':
        return routing.pageRoute(nextScreen: CheckStatusPage());
      case '/scanningRegistration':
        return routing.pageRoute(nextScreen: ScanningRegistrationPage());
      case '/signIn':
        return routing.pageRoute(nextScreen: SignIn());
      case '/qrScan':
        return routing.pageRoute(nextScreen: QrScanPage());
      case '/verify':
        return routing.pageRoute(nextScreen: PhoneAuthVerify(phoneNumber: settings.arguments.toString(),));
      default:
        return routing.pageRoute(
            nextScreen: ScaffoldAdaptive(
              child: Center(
                  child: Text('No route defined for ${settings.name}')),
            )
        );
    }
  }

}
